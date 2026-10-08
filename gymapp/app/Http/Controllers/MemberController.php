<?php

namespace App\Http\Controllers;

use App\Models\Member;
use App\Models\SubscriptionPlan;
use Carbon\Carbon;
use Illuminate\Http\Request;

class MemberController extends Controller
{
    public function index(Request $request)
    {
        $query = Member::with('subscriptions');

        if ($search = $request->get('search')) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%$search%")
                  ->orWhere('phone', 'like', "%$search%");
            });
        }

        if ($status = $request->get('status')) {
            if ($status === 'active') {
                $query->whereHas('subscriptions', fn($q) =>
                    $q->where('status', 'active')->where('end_date', '>=', Carbon::today())
                );
            } elseif ($status === 'expired') {
                $query->whereDoesntHave('subscriptions', fn($q) =>
                    $q->where('status', 'active')->where('end_date', '>=', Carbon::today())
                );
            }
        }

        if ($gender = $request->get('gender')) {
            $query->where('gender', $gender);
        }

        $members = $query->orderByDesc('created_at')->paginate(15)->withQueryString();

        return view('members.index', compact('members'));
    }

    public function create()
    {
        $plans = SubscriptionPlan::where('is_active', true)->get();
        return view('members.create', compact('plans'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name'   => 'required|string|max:255',
            'phone'  => 'nullable|string|max:20',
            'age'    => 'nullable|integer|min:5|max:120',
            'gender' => 'required|in:male,female',
            'notes'  => 'nullable|string|max:1000',
            'photo'  => 'nullable|image|max:2048',
            'subscription_plan_id' => 'nullable|exists:subscription_plans,id',
            'start_date' => 'nullable|date',
        ]);

        if ($request->hasFile('photo')) {
            $validated['photo'] = $request->file('photo')->store('members', 'public');
        }

        $member = Member::create($validated);

        if ($request->filled('subscription_plan_id')) {
            $plan      = SubscriptionPlan::findOrFail($request->subscription_plan_id);
            $startDate = $request->start_date ? Carbon::parse($request->start_date) : Carbon::today();
            $endDate   = $startDate->copy()->addDays($plan->duration_days);

            $subscription = $member->subscriptions()->create([
                'subscription_plan_id' => $plan->id,
                'start_date'           => $startDate,
                'end_date'             => $endDate,
                'status'               => 'active',
                'amount_paid'          => $plan->price,
            ]);

            $member->payments()->create([
                'subscription_id' => $subscription->id,
                'amount'          => $plan->price,
                'payment_method'  => 'cash',
                'payment_date'    => $startDate,
            ]);
        }

        return redirect()->route('members.index')
                         ->with('success', __('messages.member_created'));
    }

    public function show(Member $member)
    {
        $member->load(['subscriptions.plan', 'payments']);
        return view('members.show', compact('member'));
    }

    public function edit(Member $member)
    {
        $plans = SubscriptionPlan::where('is_active', true)->get();
        return view('members.edit', compact('member', 'plans'));
    }

    public function update(Request $request, Member $member)
    {
        $validated = $request->validate([
            'name'   => 'required|string|max:255',
            'phone'  => 'nullable|string|max:20',
            'age'    => 'nullable|integer|min:5|max:120',
            'gender' => 'required|in:male,female',
            'notes'  => 'nullable|string|max:1000',
            'photo'  => 'nullable|image|max:2048',
        ]);

        if ($request->hasFile('photo')) {
            $validated['photo'] = $request->file('photo')->store('members', 'public');
        }

        $member->update($validated);

        return redirect()->route('members.show', $member)
                         ->with('success', __('messages.member_updated'));
    }

    public function destroy(Member $member)
    {
        $member->delete();
        return redirect()->route('members.index')
                         ->with('success', __('messages.member_deleted'));
    }
}
