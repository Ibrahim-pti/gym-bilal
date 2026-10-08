<?php

namespace App\Http\Controllers;

use App\Models\Member;
use App\Models\Subscription;
use App\Models\SubscriptionPlan;
use Carbon\Carbon;
use Illuminate\Http\Request;

class SubscriptionController extends Controller
{
    public function index(Request $request)
    {
        $query = Subscription::with(['member', 'plan']);

        if ($status = $request->get('status')) {
            $query->where('status', $status);
        }

        $subscriptions = $query->orderByDesc('created_at')->paginate(15)->withQueryString();
        return view('subscriptions.index', compact('subscriptions'));
    }

    public function create(Request $request)
    {
        $members = Member::orderBy('name')->get();
        $plans   = SubscriptionPlan::where('is_active', true)->get();
        $selectedMember = $request->get('member_id') ? Member::find($request->member_id) : null;
        return view('subscriptions.create', compact('members', 'plans', 'selectedMember'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'member_id'            => 'required|exists:members,id',
            'subscription_plan_id' => 'required|exists:subscription_plans,id',
            'start_date'           => 'required|date',
            'amount_paid'          => 'required|numeric|min:0',
            'notes'                => 'nullable|string|max:1000',
        ]);

        $plan    = SubscriptionPlan::findOrFail($validated['subscription_plan_id']);
        $start   = Carbon::parse($validated['start_date']);
        $end     = $start->copy()->addDays($plan->duration_days);

        $subscription = Subscription::create([
            'member_id'            => $validated['member_id'],
            'subscription_plan_id' => $validated['subscription_plan_id'],
            'start_date'           => $start,
            'end_date'             => $end,
            'status'               => 'active',
            'amount_paid'          => $validated['amount_paid'],
            'notes'                => $validated['notes'] ?? null,
        ]);

        // Record payment
        Member::find($validated['member_id'])->payments()->create([
            'subscription_id' => $subscription->id,
            'amount'          => $validated['amount_paid'],
            'payment_method'  => 'cash',
            'payment_date'    => $start,
        ]);

        return redirect()->route('subscriptions.index')
                         ->with('success', __('messages.subscription_created'));
    }

    public function show(Subscription $subscription)
    {
        $subscription->load(['member', 'plan', 'payments']);
        return view('subscriptions.show', compact('subscription'));
    }

    public function edit(Subscription $subscription)
    {
        $plans = SubscriptionPlan::where('is_active', true)->get();
        return view('subscriptions.edit', compact('subscription', 'plans'));
    }

    public function update(Request $request, Subscription $subscription)
    {
        $validated = $request->validate([
            'start_date'  => 'required|date',
            'end_date'    => 'required|date|after:start_date',
            'status'      => 'required|in:active,expired,pending',
            'amount_paid' => 'required|numeric|min:0',
            'notes'       => 'nullable|string|max:1000',
        ]);

        $subscription->update($validated);
        return redirect()->route('subscriptions.show', $subscription)
                         ->with('success', __('messages.subscription_updated'));
    }

    public function destroy(Subscription $subscription)
    {
        $subscription->delete();
        return redirect()->route('subscriptions.index')
                         ->with('success', __('messages.subscription_deleted'));
    }

    public function renew(Subscription $subscription)
    {
        $plan  = $subscription->plan;
        $start = Carbon::today();
        $end   = $start->copy()->addDays($plan->duration_days);

        $newSub = Subscription::create([
            'member_id'            => $subscription->member_id,
            'subscription_plan_id' => $subscription->subscription_plan_id,
            'start_date'           => $start,
            'end_date'             => $end,
            'status'               => 'active',
            'amount_paid'          => $plan->price,
        ]);

        $subscription->member->payments()->create([
            'subscription_id' => $newSub->id,
            'amount'          => $plan->price,
            'payment_method'  => 'cash',
            'payment_date'    => $start,
        ]);

        return redirect()->route('members.show', $subscription->member_id)
                         ->with('success', __('messages.subscription_renewed'));
    }
}
