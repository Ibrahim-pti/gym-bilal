<?php

namespace App\Http\Controllers;

use App\Models\Sale;
use App\Models\Product;
use App\Models\Member;
use App\Models\SaleItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SaleController extends Controller
{
    public function index(Request $request)
    {
        $sales = Sale::with(['member', 'items.product'])->latest()->paginate(10);
        return view('sales.index', compact('sales'));
    }

    public function create()
    {
        $products = Product::where('status', true)->get();
        $members = Member::all();
        return view('sales.pos', compact('products', 'members'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'member_id' => 'nullable|exists:members,id',
            'items' => 'required|array|min:1',
            'items.*.id' => 'required|exists:products,id',
            'items.*.quantity' => 'required|integer|min:1',
            'discount' => 'nullable|numeric|min:0',
            'payment_method' => 'required|string',
        ]);

        try {
            DB::beginTransaction();

            $totalAmount = 0;
            $saleItems = [];

            foreach ($validated['items'] as $itemData) {
                $product = Product::findOrFail($itemData['id']);
                
                if ($product->stock_quantity < $itemData['quantity']) {
                    throw new \Exception("Insufficient stock for product: {$product->name}");
                }

                $subtotal = $product->price * $itemData['quantity'];
                $totalAmount += $subtotal;

                $saleItems[] = new SaleItem([
                    'product_id' => $product->id,
                    'quantity' => $itemData['quantity'],
                    'unit_price' => $product->price,
                    'subtotal' => $subtotal,
                ]);

                // Update stock
                $product->decrement('stock_quantity', $itemData['quantity']);
            }

            $sale = Sale::create([
                'member_id' => $validated['member_id'],
                'total_amount' => $totalAmount - ($validated['discount'] ?? 0),
                'discount' => $validated['discount'] ?? 0,
                'payment_method' => $validated['payment_method'],
                'status' => 'completed',
            ]);

            $sale->items()->saveMany($saleItems);

            // Handle Member Balance if payment is 'debt'
            if ($validated['payment_method'] === 'debt') {
                if (!$validated['member_id']) {
                    throw new \Exception("Member must be selected for debt payment.");
                }
                $member = Member::find($validated['member_id']);
                $member->increment('balance', $sale->total_amount);
            }

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Sale completed successfully.',
                'sale_id' => $sale->id
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 422);
        }
    }

    public function show(Sale $sale)
    {
        $sale->load(['member', 'items.product']);
        return view('sales.show', compact('sale'));
    }

    public function destroy(Sale $sale)
    {
        // Restore stock before deleting
        foreach ($sale->items as $item) {
            if ($item->product) {
                $item->product->increment('stock_quantity', $item->quantity);
            }
        }
        
        $sale->delete();
        return redirect()->route('sales.index')->with('success', 'Sale deleted successfully.');
    }

    public function print(Sale $sale)
    {
        $sale->load(['member', 'items.product']);
        $settings = \App\Models\Setting::all()->pluck('value', 'key');
        return view('sales.print', compact('sale', 'settings'));
    }
}
