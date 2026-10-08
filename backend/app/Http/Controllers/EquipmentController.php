<?php

namespace App\Http\Controllers;

use App\Models\Equipment;
use Illuminate\Http\Request;

class EquipmentController extends Controller
{
    public function index(Request $request)
    {
        $query = Equipment::query();

        if ($search = $request->get('search')) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%$search%")
                  ->orWhere('category', 'like', "%$search%");
            });
        }

        if ($category = $request->get('category')) {
            $query->where('category', $category);
        }

        if ($condition = $request->get('condition')) {
            $query->where('condition', $condition);
        }

        $equipment = $query->orderByDesc('created_at')->paginate(15)->withQueryString();
        $totalValue = Equipment::all()->sum(fn($e) => $e->purchase_price * $e->quantity);
        $needsMaintenance = Equipment::where('next_maintenance', '<=', now())->count();

        return view('equipment.index', compact('equipment', 'totalValue', 'needsMaintenance'));
    }

    public function create()
    {
        return view('equipment.create');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'category' => 'nullable|in:cardio,weights,machines,accessories,other',
            'quantity' => 'required|integer|min:1',
            'purchase_price' => 'nullable|numeric|min:0',
            'purchase_date' => 'nullable|date',
            'condition' => 'required|in:new,good,fair,needs_repair,broken',
            'last_maintenance' => 'nullable|date',
            'next_maintenance' => 'nullable|date',
            'notes' => 'nullable|string|max:1000',
        ]);

        Equipment::create($validated);

        return redirect()->route('equipment.index')
                         ->with('success', __('messages.equipment_created'));
    }

    public function edit(Equipment $equipment)
    {
        return view('equipment.edit', compact('equipment'));
    }

    public function update(Request $request, Equipment $equipment)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'category' => 'nullable|in:cardio,weights,machines,accessories,other',
            'quantity' => 'required|integer|min:1',
            'purchase_price' => 'nullable|numeric|min:0',
            'purchase_date' => 'nullable|date',
            'condition' => 'required|in:new,good,fair,needs_repair,broken',
            'last_maintenance' => 'nullable|date',
            'next_maintenance' => 'nullable|date',
            'notes' => 'nullable|string|max:1000',
        ]);

        $equipment->update($validated);

        return redirect()->route('equipment.index')
                         ->with('success', __('messages.equipment_updated'));
    }

    public function destroy(Equipment $equipment)
    {
        $equipment->delete();
        return redirect()->route('equipment.index')
                         ->with('success', __('messages.equipment_deleted'));
    }
}
