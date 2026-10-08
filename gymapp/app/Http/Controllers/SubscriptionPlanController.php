<?php

namespace App\Http\Controllers;

use App\Models\SubscriptionPlan;
use Illuminate\Http\Request;

class SubscriptionPlanController extends Controller
{
    public function index()
    {
        $plans = SubscriptionPlan::withCount('subscriptions')->orderByDesc('created_at')->get();
        return view('subscription-plans.index', compact('plans'));
    }

    public function create()
    {
        return view('subscription-plans.create');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name'          => 'required|string|max:255',
            'price'         => 'required|numeric|min:0',
            'duration_days' => 'required|integer|min:1',
            'type'          => 'required|in:monthly,yearly,custom',
            'description'   => 'nullable|string|max:1000',
            'is_active'     => 'boolean',
        ]);
        $validated['is_active'] = $request->has('is_active');

        SubscriptionPlan::create($validated);
        return redirect()->route('subscription-plans.index')
                         ->with('success', __('messages.plan_created'));
    }

    public function show(SubscriptionPlan $subscriptionPlan)
    {
        $subscriptionPlan->load('subscriptions.member');
        return view('subscription-plans.show', compact('subscriptionPlan'));
    }

    public function edit(SubscriptionPlan $subscriptionPlan)
    {
        return view('subscription-plans.edit', compact('subscriptionPlan'));
    }

    public function update(Request $request, SubscriptionPlan $subscriptionPlan)
    {
        $validated = $request->validate([
            'name'          => 'required|string|max:255',
            'price'         => 'required|numeric|min:0',
            'duration_days' => 'required|integer|min:1',
            'type'          => 'required|in:monthly,yearly,custom',
            'description'   => 'nullable|string|max:1000',
        ]);
        $validated['is_active'] = $request->has('is_active');

        $subscriptionPlan->update($validated);
        return redirect()->route('subscription-plans.index')
                         ->with('success', __('messages.plan_updated'));
    }

    public function destroy(SubscriptionPlan $subscriptionPlan)
    {
        if ($subscriptionPlan->subscriptions()->exists()) {
            return back()->with('error', __('messages.plan_has_subscriptions'));
        }
        $subscriptionPlan->delete();
        return redirect()->route('subscription-plans.index')
                         ->with('success', __('messages.plan_deleted'));
    }
}
