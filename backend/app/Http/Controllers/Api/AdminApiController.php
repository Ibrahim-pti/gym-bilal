<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Member;
use App\Models\Subscription;
use App\Models\SubscriptionPlan;
use App\Models\Attendance;
use Illuminate\Http\Request;
use Carbon\Carbon;

class AdminApiController extends Controller
{
    /**
     * Admin QR Scanner: check in member by Barcode or Member ID
     */
    public function scanAttendance(Request $request)
    {
        $request->validate([
            'barcode' => 'required|string',
        ]);

        $barcode = trim($request->barcode);

        $member = Member::where('barcode', $barcode)
            ->orWhere('phone', $barcode)
            ->orWhere('id', $barcode)
            ->first();

        if (!$member) {
            return response()->json([
                'status'  => false,
                'message' => 'ئەندامەکە لە سیستەم نەدۆزرایەوە (Member not found)',
            ], 404);
        }

        $member->load('activeSubscription.plan');

        // Check if member subscription is active
        $isSubscriptionActive = $member->activeSubscription !== null;

        // Check if already checked in within the last 4 hours
        $recentCheckIn = Attendance::where('member_id', $member->id)
            ->where('check_in', '>=', Carbon::now()->subHours(4))
            ->first();

        $alreadyLogged = false;
        if ($recentCheckIn) {
            $alreadyLogged = true;
        } else {
            // Log new attendance
            Attendance::create([
                'member_id' => $member->id,
                'check_in'  => Carbon::now(),
            ]);
        }

        return response()->json([
            'status'               => true,
            'message'              => $alreadyLogged ? 'پێشتر هاتووەتە ژوورەوە' : 'بە سەرکەوتوویی تۆمارکرا',
            'already_logged'       => $alreadyLogged,
            'is_subscription_valid'=> $isSubscriptionActive,
            'member' => [
                'id'        => $member->id,
                'name'      => $member->name,
                'phone'     => $member->phone,
                'barcode'   => $member->barcode,
                'status'    => $member->status,
                'days_left' => $member->activeSubscription ? max(0, Carbon::today()->diffInDays($member->activeSubscription->end_date, false)) : 0,
                'plan_name' => $member->activeSubscription?->plan?->name ?? 'بێ بەشداریکردن',
                'end_date'  => $member->activeSubscription?->end_date?->format('Y-m-d') ?? 'بەسەرچووە',
            ],
            'time' => Carbon::now()->format('h:i A'),
        ]);
    }

    /**
     * Admin stats summary for mobile dashboard
     */
    public function getDashboardStats()
    {
        $totalMembers = Member::count();
        $todayCheckIns = Attendance::whereDate('check_in', Carbon::today())->count();
        $activeMembers = Member::whereHas('subscriptions', function($q) {
            $q->where('status', 'active')->where('end_date', '>=', Carbon::today());
        })->count();
        $expiredMembers = $totalMembers - $activeMembers;

        return response()->json([
            'status' => true,
            'stats'  => [
                'total_members'   => $totalMembers,
                'today_checkins'  => $todayCheckIns,
                'active_members'  => $activeMembers,
                'expired_members' => $expiredMembers,
            ],
        ]);
    }

    /**
     * Search and list members for admin
     */
    public function getMembers(Request $request)
    {
        $query = Member::query()->with('activeSubscription.plan');

        if ($request->has('search') && !empty($request->search)) {
            $s = trim($request->search);
            $query->where(function($q) use ($s) {
                $q->where('name', 'like', "%{$s}%")
                  ->orWhere('phone', 'like', "%{$s}%")
                  ->orWhere('barcode', 'like', "%{$s}%");
            });
        }

        $members = $query->latest()->paginate(25);

        return response()->json([
            'status'  => true,
            'members' => $members->map(function($m) {
                return [
                    'id'          => $m->id,
                    'name'        => $m->name,
                    'phone'       => $m->phone,
                    'barcode'     => $m->barcode,
                    'status'      => $m->status,
                    'plan'        => $m->activeSubscription?->plan?->name ?? 'None',
                    'end_date'    => $m->activeSubscription?->end_date?->format('Y-m-d') ?? 'N/A',
                ];
            }),
        ]);
    }

    /**
     * Renew member subscription from admin phone
     */
    public function renewSubscription(Request $request)
    {
        $request->validate([
            'member_id' => 'required|exists:members,id',
            'plan_id'   => 'required|exists:subscription_plans,id',
        ]);

        $member = Member::findOrFail($request->member_id);
        $plan = SubscriptionPlan::findOrFail($request->plan_id);

        $subscription = Subscription::create([
            'member_id'            => $member->id,
            'subscription_plan_id' => $plan->id,
            'start_date'           => Carbon::today(),
            'end_date'             => Carbon::today()->addDays($plan->duration_days ?: 30),
            'status'               => 'active',
            'amount_paid'          => $plan->price,
            'notes'                => 'Renewed via Admin Mobile App',
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'بەشدارییەکە بە سەرکەوتوویی نوێکرایەوە',
            'subscription' => [
                'id'       => $subscription->id,
                'end_date' => $subscription->end_date->format('Y-m-d'),
            ],
        ]);
    }
}
