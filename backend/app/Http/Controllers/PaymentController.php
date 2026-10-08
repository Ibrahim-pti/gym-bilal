<?php

namespace App\Http\Controllers;

use App\Models\Member;
use App\Models\Payment;
use App\Models\Subscription;
use Illuminate\Http\Request;

class PaymentController extends Controller
{
    public function index(Request $request)
    {
        $query = Payment::with(['member', 'subscription.plan']);

        if ($search = $request->get('search')) {
            $query->whereHas('member', fn($q) =>
                $q->where('name', 'like', "%$search%")
                  ->orWhere('phone', 'like', "%$search%")
            )->orWhere('receipt_number', 'like', "%$search%");
        }

        if ($method = $request->get('payment_method')) {
            $query->where('payment_method', $method);
        }

        if ($from = $request->get('from')) {
            $query->whereDate('payment_date', '>=', $from);
        }

        if ($to = $request->get('to')) {
            $query->whereDate('payment_date', '<=', $to);
        }

        $payments = $query->orderByDesc('payment_date')->paginate(20)->withQueryString();
        $total    = $query->sum('amount');

        return view('payments.index', compact('payments', 'total'));
    }

    public function create(Request $request)
    {
        $members = Member::orderBy('name')->get();
        $selectedMember = $request->get('member_id') ? Member::with('subscriptions.plan')->find($request->member_id) : null;
        return view('payments.create', compact('members', 'selectedMember'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'member_id'      => 'required|exists:members,id',
            'subscription_id'=> 'nullable|exists:subscriptions,id',
            'amount'         => 'required|numeric|min:0.01',
            'payment_method' => 'required|in:cash,card,transfer',
            'payment_date'   => 'required|date',
            'notes'          => 'nullable|string|max:500',
        ]);

        Payment::create($validated);

        return redirect()->route('payments.index')
                         ->with('success', __('messages.payment_created'));
    }

    public function show(Payment $payment)
    {
        $payment->load(['member', 'subscription.plan']);
        return view('payments.show', compact('payment'));
    }

    public function destroy(Payment $payment)
    {
        $payment->delete();
        return redirect()->route('payments.index')
                         ->with('success', __('messages.payment_deleted'));
    }
}
