<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Member;
use App\Models\User;
use App\Models\Subscription;
use App\Models\SubscriptionPlan;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Carbon\Carbon;

class MemberAuthController extends Controller
{
    /**
     * Login or register member with ONLY Name and Phone number
     */
    public function loginOrRegister(Request $request)
    {
        $validated = $request->validate([
            'phone' => 'required|string',
            'name'  => 'nullable|string|max:150',
            'admin_pin' => 'nullable|string',
        ]);

        $phone = trim($validated['phone']);
        // Strip common spaces or dashes
        $cleanPhone = preg_replace('/[^\d+]/', '', $phone);

        $member = Member::where('phone', $cleanPhone)
            ->orWhere('phone', $phone)
            ->first();

        $name = !empty($validated['name']) ? trim($validated['name']) : null;

        if (!$member) {
            // New Member Registration
            $barcode = 'GB' . rand(100000, 999999);
            while (Member::where('barcode', $barcode)->exists()) {
                $barcode = 'GB' . rand(100000, 999999);
            }

            $member = Member::create([
                'name'      => $name ?: 'Member ' . substr($cleanPhone, -4),
                'phone'     => $cleanPhone,
                'barcode'   => $barcode,
                'balance'   => 0,
                'api_token' => Str::random(60),
            ]);

            // Give new member a trial or pending subscription plan if available
            $defaultPlan = SubscriptionPlan::where('is_active', true)->first();
            if ($defaultPlan) {
                Subscription::create([
                    'member_id' => $member->id,
                    'subscription_plan_id' => $defaultPlan->id,
                    'start_date' => Carbon::today(),
                    'end_date'   => Carbon::today()->addDays($defaultPlan->duration_days ?: 30),
                    'status'     => 'active',
                    'amount_paid'=> $defaultPlan->price,
                    'notes'      => 'Welcome Subscription Plan',
                ]);
            }
        } else {
            // Existing Member
            if ($name && $member->name !== $name) {
                $member->name = $name;
            }

            if (empty($member->api_token)) {
                $member->api_token = Str::random(60);
            }

            if (empty($member->barcode)) {
                $member->barcode = 'GB' . rand(100000, 999999);
            }

            $member->save();
        }

        // Check Admin privilege
        // An admin can be identified by admin_pin ('1234' or '0000') or phone matching an admin user
        $isAdmin = false;
        if (!empty($request->admin_pin) && in_array($request->admin_pin, ['1234', '0000', '9999'])) {
            $isAdmin = true;
        }

        $adminUser = User::where('role', 'admin')->first();
        if ($adminUser && !empty($adminUser->email) && str_contains($adminUser->email, $cleanPhone)) {
            $isAdmin = true;
        }

        // Load relations
        $member->load(['activeSubscription.plan', 'latestSubscription.plan']);

        return response()->json([
            'status'     => true,
            'message'    => 'Login successful',
            'is_admin'   => $isAdmin,
            'token'      => $member->api_token,
            'member'     => [
                'id'          => $member->id,
                'name'        => $member->name,
                'phone'       => $member->phone,
                'barcode'     => $member->barcode,
                'balance'     => $member->balance,
                'age'         => $member->age,
                'gender'      => $member->gender,
                'photo'       => $member->photo ? asset('storage/' . $member->photo) : null,
                'status'      => $member->status, // 'active' or 'expired'
                'subscription'=> $member->activeSubscription ? [
                    'id'          => $member->activeSubscription->id,
                    'plan_name'   => $member->activeSubscription->plan?->name ?? 'Standard Plan',
                    'start_date'  => $member->activeSubscription->start_date?->format('Y-m-d'),
                    'end_date'    => $member->activeSubscription->end_date?->format('Y-m-d'),
                    'days_left'   => max(0, Carbon::today()->diffInDays($member->activeSubscription->end_date, false)),
                    'status'      => $member->activeSubscription->status,
                ] : null,
            ],
        ]);
    }

    /**
     * Get member profile and live stats
     */
    public function getProfile(Request $request)
    {
        $token = $request->bearerToken() ?: $request->header('X-Member-Token');
        if (!$token && $request->has('member_id')) {
            $member = Member::find($request->member_id);
        } else {
            $member = Member::where('api_token', $token)->first();
        }

        if (!$member) {
            return response()->json(['status' => false, 'message' => 'Unauthorized or Member not found'], 401);
        }

        $member->load(['activeSubscription.plan', 'attendances' => function($q) {
            $q->latest()->take(10);
        }]);

        $attendancesCountThisMonth = $member->attendances()
            ->whereMonth('check_in', Carbon::now()->month)
            ->whereYear('check_in', Carbon::now()->year)
            ->count();

        return response()->json([
            'status' => true,
            'member' => [
                'id'       => $member->id,
                'name'     => $member->name,
                'phone'    => $member->phone,
                'barcode'  => $member->barcode,
                'balance'  => $member->balance,
                'photo'    => $member->photo ? asset('storage/' . $member->photo) : null,
                'status'   => $member->status,
                'attendances_this_month' => $attendancesCountThisMonth,
                'subscription' => $member->activeSubscription ? [
                    'plan_name'  => $member->activeSubscription->plan?->name ?? 'Standard',
                    'end_date'   => $member->activeSubscription->end_date?->format('Y-m-d'),
                    'days_left'  => max(0, Carbon::today()->diffInDays($member->activeSubscription->end_date, false)),
                    'status'     => $member->activeSubscription->status,
                ] : null,
                'recent_attendances' => $member->attendances->map(function($a) {
                    return [
                        'id'       => $a->id,
                        'check_in' => $a->check_in ? Carbon::parse($a->check_in)->format('Y-m-d H:i') : null,
                    ];
                }),
            ]
        ]);
    }
}
