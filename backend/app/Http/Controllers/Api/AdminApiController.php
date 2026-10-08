<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Member;
use App\Models\Subscription;
use App\Models\SubscriptionPlan;
use App\Models\Attendance;
use App\Models\WorkoutPlan;
use App\Models\Trainer;
use App\Models\Reel;
use Illuminate\Http\Request;
use Carbon\Carbon;

class AdminApiController extends Controller
{
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
                'total_workouts'  => WorkoutPlan::count(),
                'total_reels'     => Reel::count(),
                'total_trainers'  => Trainer::count(),
                'total_plans'     => SubscriptionPlan::count(),
            ],
        ]);
    }

    // ==========================================
    // 1. MEMBERS MANAGEMENT
    // ==========================================

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

        $members = $query->latest()->get();

        return response()->json([
            'status'  => true,
            'members' => $members->map(function($m) {
                return [
                    'id'          => $m->id,
                    'name'        => $m->name,
                    'phone'       => $m->phone,
                    'barcode'     => $m->barcode,
                    'balance'     => (float)$m->balance,
                    'age'         => $m->age,
                    'gender'      => $m->gender,
                    'notes'       => $m->notes,
                    'status'      => $m->status,
                    'plan'        => $m->activeSubscription?->plan?->name ?? 'بێ بەشداریکردن',
                    'end_date'    => $m->activeSubscription?->end_date?->format('Y-m-d') ?? 'N/A',
                ];
            }),
        ]);
    }

    public function saveMember(Request $request)
    {
        $request->validate([
            'name'  => 'required|string|max:150',
            'phone' => 'required|string|max:50',
        ]);

        $id = $request->input('id');
        if ($id) {
            $member = Member::findOrFail($id);
            $member->update($request->only(['name', 'phone', 'balance', 'age', 'gender', 'notes']));
        } else {
            $barcode = 'GB' . rand(100000, 999999);
            while (Member::where('barcode', $barcode)->exists()) {
                $barcode = 'GB' . rand(100000, 999999);
            }
            $member = Member::create([
                'name'    => $request->name,
                'phone'   => $request->phone,
                'barcode' => $barcode,
                'balance' => $request->input('balance', 0),
                'age'     => $request->input('age'),
                'gender'  => $request->input('gender', 'male'),
                'notes'   => $request->input('notes'),
            ]);
        }

        return response()->json([
            'status'  => true,
            'message' => 'ئەندامەکە بە سەرکەوتوویی سەیڤ کرا',
            'member'  => $member,
        ]);
    }

    public function deleteMember($id)
    {
        $member = Member::findOrFail($id);
        $member->delete();
        return response()->json(['status' => true, 'message' => 'ئەندامەکە سڕایەوە']);
    }

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

    // ==========================================
    // 2. WORKOUTS MANAGEMENT
    // ==========================================

    public function getWorkouts()
    {
        $workouts = WorkoutPlan::with('trainer')->latest()->get();

        return response()->json([
            'status'   => true,
            'workouts' => $workouts->map(function($w) {
                return [
                    'id'          => $w->id,
                    'title'       => $w->title,
                    'description' => $w->description,
                    'trainer_name'=> $w->trainer?->name ?? 'Coach Bilal',
                    'trainer_id'  => $w->trainer_id,
                    'exercises'   => is_array($w->exercises) ? $w->exercises : json_decode($w->exercises ?: '[]', true),
                ];
            }),
        ]);
    }

    public function saveWorkout(Request $request)
    {
        $request->validate([
            'title'       => 'required|string',
            'description' => 'nullable|string',
            'exercises'   => 'nullable|array',
            'trainer_id'  => 'nullable|exists:trainers,id',
            'member_id'   => 'nullable|exists:members,id',
        ]);

        $id = $request->input('id');
        $data = [
            'title'       => $request->title,
            'description' => $request->description,
            'exercises'   => $request->input('exercises', []),
            'trainer_id'  => $request->trainer_id,
            'member_id'   => $request->input('member_id', Member::first()?->id ?? 1),
        ];

        if ($id) {
            $workout = WorkoutPlan::findOrFail($id);
            $workout->update($data);
        } else {
            $workout = WorkoutPlan::create($data);
        }

        return response()->json([
            'status'  => true,
            'message' => 'ڕاهێنانەکە بە سەرکەوتوویی سەیڤ کرا',
            'workout' => $workout,
        ]);
    }

    public function deleteWorkout($id)
    {
        $workout = WorkoutPlan::findOrFail($id);
        $workout->delete();
        return response()->json(['status' => true, 'message' => 'ڕاهێنانەکە سڕایەوە']);
    }

    // ==========================================
    // 3. REELS MANAGEMENT
    // ==========================================

    public function getReels()
    {
        $reels = Reel::latest()->get();
        return response()->json([
            'status' => true,
            'reels'  => $reels,
        ]);
    }

    public function saveReel(Request $request)
    {
        $request->validate([
            'title'      => 'required|string',
            'video_url'  => 'required|string',
            'coach_name' => 'nullable|string',
        ]);

        $id = $request->input('id');
        $data = [
            'title'       => $request->title,
            'video_url'   => $request->video_url,
            'coach_name'  => $request->input('coach_name', 'Coach Bilal'),
            'likes_count' => $request->input('likes_count', 0),
        ];

        if ($id) {
            $reel = Reel::findOrFail($id);
            $reel->update($data);
        } else {
            $reel = Reel::create($data);
        }

        return response()->json([
            'status'  => true,
            'message' => 'ڕیڵزەکە بە سەرکەوتوویی سەیڤ کرا',
            'reel'    => $reel,
        ]);
    }

    public function deleteReel($id)
    {
        $reel = Reel::findOrFail($id);
        $reel->delete();
        return response()->json(['status' => true, 'message' => 'ڕیڵزەکە سڕایەوە']);
    }

    // ==========================================
    // 4. TRAINERS MANAGEMENT
    // ==========================================

    public function getTrainers()
    {
        $trainers = Trainer::all();
        return response()->json([
            'status'   => true,
            'trainers' => $trainers,
        ]);
    }

    public function saveTrainer(Request $request)
    {
        $request->validate([
            'name'      => 'required|string',
            'phone'     => 'nullable|string',
            'specialty' => 'nullable|string',
        ]);

        $id = $request->input('id');
        $data = [
            'name'      => $request->name,
            'phone'     => $request->phone,
            'specialty' => $request->input('specialty', 'Bodybuilding & Fitness Coach'),
        ];

        if ($id) {
            $trainer = Trainer::findOrFail($id);
            $trainer->update($data);
        } else {
            $trainer = Trainer::create($data);
        }

        return response()->json([
            'status'  => true,
            'message' => 'ڕاهێنەرەکە بە سەرکەوتوویی سەیڤ کرا',
            'trainer' => $trainer,
        ]);
    }

    public function deleteTrainer($id)
    {
        $trainer = Trainer::findOrFail($id);
        $trainer->delete();
        return response()->json(['status' => true, 'message' => 'ڕاهێنەرەکە سڕایەوە']);
    }

    // ==========================================
    // 5. SUBSCRIPTION PLANS MANAGEMENT
    // ==========================================

    public function getPlans()
    {
        $plans = SubscriptionPlan::all();
        return response()->json([
            'status' => true,
            'plans'  => $plans,
        ]);
    }

    public function savePlan(Request $request)
    {
        $request->validate([
            'name'          => 'required|string',
            'price'         => 'required|numeric',
            'duration_days' => 'required|integer',
            'type'          => 'nullable|string',
            'description'   => 'nullable|string',
            'is_active'     => 'nullable|boolean',
        ]);

        $id = $request->input('id');
        $data = [
            'name'          => $request->name,
            'price'         => $request->price,
            'duration_days' => $request->duration_days,
            'type'          => $request->input('type', 'monthly'),
            'description'   => $request->input('description'),
            'is_active'     => $request->input('is_active', true),
        ];

        if ($id) {
            $plan = SubscriptionPlan::findOrFail($id);
            $plan->update($data);
        } else {
            $plan = SubscriptionPlan::create($data);
        }

        return response()->json([
            'status' => true,
            'message'=> 'پلانەکە بە سەرکەوتوویی سەیڤ کرا',
            'plan'   => $plan,
        ]);
    }

    public function deletePlan($id)
    {
        $plan = SubscriptionPlan::findOrFail($id);
        $plan->delete();
        return response()->json(['status' => true, 'message' => 'پلانەکە سڕایەوە']);
    }
}
