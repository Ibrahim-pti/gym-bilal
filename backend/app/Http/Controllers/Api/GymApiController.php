<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Member;
use App\Models\SubscriptionPlan;
use App\Models\WorkoutPlan;
use App\Models\DietPlan;
use App\Models\Trainer;
use App\Models\Attendance;
use Illuminate\Http\Request;
use Carbon\Carbon;

class GymApiController extends Controller
{
    /**
     * Get all active subscription plans
     */
    public function getSubscriptionPlans()
    {
        $plans = SubscriptionPlan::where('is_active', true)->get()->map(function($plan) {
            return [
                'id'            => $plan->id,
                'name'          => $plan->name,
                'price'         => (float)$plan->price,
                'duration_days' => $plan->duration_days,
                'type'          => $plan->type,
                'description'   => $plan->description,
            ];
        });

        return response()->json([
            'status' => true,
            'plans'  => $plans,
        ]);
    }

    /**
     * Get workouts for the member (or default gym workouts)
     */
    public function getMemberWorkouts(Request $request)
    {
        $memberId = $request->input('member_id');
        $workouts = [];

        if ($memberId) {
            $workouts = WorkoutPlan::where('member_id', $memberId)
                ->with('trainer')
                ->latest()
                ->get();
        }

        if ($workouts->isEmpty()) {
            // Provide curated gym exercises if member has no custom plan assigned yet
            return response()->json([
                'status'   => true,
                'has_custom_plan' => false,
                'workouts' => [
                    [
                        'id'          => 1,
                        'title'       => 'Full Body Strength & Hypertrophy',
                        'trainer'     => 'Coach Bilal',
                        'description' => 'سیستەمی ڕاهێنانی گشتی ماسولکە بۆ بەرزکردنەوەی هێز و لەشجوانی',
                        'exercises'   => [
                            ['name' => 'Barbell Bench Press', 'sets' => '4', 'reps' => '8-10', 'target' => 'Chest'],
                            ['name' => 'Barbell Back Squat', 'sets' => '4', 'reps' => '8-10', 'target' => 'Legs'],
                            ['name' => 'Lat Pulldown', 'sets' => '3', 'reps' => '10-12', 'target' => 'Back'],
                            ['name' => 'Dumbbell Shoulder Press', 'sets' => '3', 'reps' => '10-12', 'target' => 'Shoulders'],
                            ['name' => 'Barbell Bicep Curl', 'sets' => '3', 'reps' => '12', 'target' => 'Biceps'],
                        ]
                    ],
                    [
                        'id'          => 2,
                        'title'       => 'Push Day (Chest, Shoulders & Triceps)',
                        'trainer'     => 'Coach Bilal',
                        'description' => 'ڕاهێنانی پاڵنان تایبەت بە سنگ و شان و سێ سەر',
                        'exercises'   => [
                            ['name' => 'Incline Dumbbell Press', 'sets' => '4', 'reps' => '10', 'target' => 'Upper Chest'],
                            ['name' => 'Dips / Cable Fly', 'sets' => '3', 'reps' => '12', 'target' => 'Chest'],
                            ['name' => 'Lateral Raises', 'sets' => '4', 'reps' => '15', 'target' => 'Side Delts'],
                            ['name' => 'Tricep Rope Pushdown', 'sets' => '3', 'reps' => '12-15', 'target' => 'Triceps'],
                        ]
                    ]
                ]
            ]);
        }

        return response()->json([
            'status'          => true,
            'has_custom_plan' => true,
            'workouts'        => $workouts->map(function($w) {
                return [
                    'id'          => $w->id,
                    'title'       => $w->title,
                    'trainer'     => $w->trainer?->name ?? 'Gym Coach',
                    'description' => $w->description,
                    'exercises'   => is_array($w->exercises) ? $w->exercises : json_decode($w->exercises ?: '[]', true),
                ];
            }),
        ]);
    }

    /**
     * Get diet / nutrition plan
     */
    public function getMemberDietPlans(Request $request)
    {
        $memberId = $request->input('member_id');
        $diets = [];

        if ($memberId) {
            $diets = DietPlan::where('member_id', $memberId)->latest()->get();
        }

        if ($diets->isEmpty()) {
            return response()->json([
                'status'          => true,
                'has_custom_plan' => false,
                'diet_plans'      => [
                    [
                        'id'          => 1,
                        'title'       => 'High Protein Fitness Meal Plan',
                        'calories'    => 2400,
                        'protein_g'   => 160,
                        'carbs_g'     => 220,
                        'fats_g'      => 65,
                        'meals'       => [
                            ['meal' => 'Breakfast', 'items' => '٤ هێلکەی کوڵاو + شۆفان لەگەڵ شیر و مۆز', 'calories' => 550],
                            ['meal' => 'Lunch', 'items' => '٢٠٠ گرام سنگی مریشک + برنجی کوردی + زەڵاتە', 'calories' => 750],
                            ['meal' => 'Pre-workout', 'items' => 'قاوەی ڕەش + سێو یان مۆز', 'calories' => 150],
                            ['meal' => 'Dinner', 'items' => 'گۆشتی کوڵاو یان تونە + پەتاتەی کوڵاو', 'calories' => 650],
                        ]
                    ]
                ]
            ]);
        }

        return response()->json([
            'status'          => true,
            'has_custom_plan' => true,
            'diet_plans'      => $diets->map(function($d) {
                return [
                    'id'          => $d->id,
                    'title'       => $d->title,
                    'description' => $d->description,
                    'meals'       => is_array($d->meals) ? $d->meals : json_decode($d->meals ?: '[]', true),
                ];
            }),
        ]);
    }

    /**
     * Get Gym Leaderboard (Top Members by attendance)
     */
    public function getLeaderboard()
    {
        $topMembers = Member::withCount(['attendances' => function($q) {
            $q->whereMonth('check_in', Carbon::now()->month);
        }])
        ->orderByDesc('attendances_count')
        ->take(15)
        ->get()
        ->map(function($member, $index) {
            return [
                'rank'             => $index + 1,
                'id'               => $member->id,
                'name'             => $member->name,
                'check_ins'        => $member->attendances_count,
                'status'           => $member->status,
                'avatar'           => $member->photo ? asset('storage/' . $member->photo) : null,
            ];
        });

        return response()->json([
            'status'      => true,
            'month'       => Carbon::now()->translatedFormat('F Y'),
            'leaderboard' => $topMembers,
        ]);
    }

    /**
     * Get Reels / Fitness Shorts
     */
    public function getReels()
    {
        // Sample reels curated for Gym Bilal app
        return response()->json([
            'status' => true,
            'reels'  => [
                [
                    'id'          => 1,
                    'title'       => 'چۆنیەتی ڕاستی ئەنجامدانی Bench Press',
                    'coach'       => 'Coach Bilal',
                    'likes'       => 245,
                    'comments'    => 18,
                    'video_url'   => 'https://assets.mixkit.co/videos/preview/mixkit-athlete-working-out-with-heavy-weights-in-a-gym-40544-large.mp4',
                    'thumbnail'   => 'assets/images/workout_back.jpg',
                ],
                [
                    'id'          => 2,
                    'title'       => 'گرنگترین ڕێنمایی بۆ ماسولکەی شان',
                    'coach'       => 'Coach Bilal',
                    'likes'       => 189,
                    'comments'    => 12,
                    'video_url'   => 'https://assets.mixkit.co/videos/preview/mixkit-man-exercising-with-dumbbells-in-a-gym-40543-large.mp4',
                    'thumbnail'   => 'assets/images/splash_athlete.jpg',
                ],
            ]
        ]);
    }

    /**
     * Get Trainers
     */
    public function getTrainers()
    {
        $trainers = Trainer::all()->map(function($t) {
            return [
                'id'         => $t->id,
                'name'       => $t->name,
                'phone'      => $t->phone,
                'specialty'  => $t->specialty ?? 'Bodybuilding & Fitness Coach',
                'photo'      => $t->photo ? asset('storage/' . $t->photo) : null,
            ];
        });

        return response()->json([
            'status'   => true,
            'trainers' => $trainers,
        ]);
    }
}
