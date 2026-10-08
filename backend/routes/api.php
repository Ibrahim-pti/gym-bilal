<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\MemberAuthController;
use App\Http\Controllers\Api\GymApiController;
use App\Http\Controllers\Api\AdminApiController;

// Public Member Routes
Route::prefix('v1')->group(function () {
    // Member Auth (Only Name & Phone)
    Route::post('/member/login', [MemberAuthController::class, 'loginOrRegister']);
    Route::get('/member/profile', [MemberAuthController::class, 'getProfile']);

    // Gym Public & Member Features
    Route::get('/plans', [GymApiController::class, 'getSubscriptionPlans']);
    Route::get('/workouts', [GymApiController::class, 'getMemberWorkouts']);
    Route::get('/diet-plans', [GymApiController::class, 'getMemberDietPlans']);
    Route::get('/leaderboard', [GymApiController::class, 'getLeaderboard']);
    Route::get('/reels', [GymApiController::class, 'getReels']);
    Route::get('/trainers', [GymApiController::class, 'getTrainers']);

    // Admin Mobile API Endpoints (In-App Admin Management Hub)
    Route::prefix('admin')->group(function () {
        Route::get('/dashboard-stats', [AdminApiController::class, 'getDashboardStats']);

        // Members
        Route::get('/members', [AdminApiController::class, 'getMembers']);
        Route::post('/members/save', [AdminApiController::class, 'saveMember']);
        Route::delete('/members/{id}', [AdminApiController::class, 'deleteMember']);
        Route::post('/renew-subscription', [AdminApiController::class, 'renewSubscription']);

        // Workouts
        Route::get('/workouts', [AdminApiController::class, 'getWorkouts']);
        Route::post('/workouts/save', [AdminApiController::class, 'saveWorkout']);
        Route::delete('/workouts/{id}', [AdminApiController::class, 'deleteWorkout']);

        // Reels
        Route::get('/reels', [AdminApiController::class, 'getReels']);
        Route::post('/reels/save', [AdminApiController::class, 'saveReel']);
        Route::delete('/reels/{id}', [AdminApiController::class, 'deleteReel']);

        // Trainers
        Route::get('/trainers', [AdminApiController::class, 'getTrainers']);
        Route::post('/trainers/save', [AdminApiController::class, 'saveTrainer']);
        Route::delete('/trainers/{id}', [AdminApiController::class, 'deleteTrainer']);

        // Plans & Pricing
        Route::get('/plans', [AdminApiController::class, 'getPlans']);
        Route::post('/plans/save', [AdminApiController::class, 'savePlan']);
        Route::delete('/plans/{id}', [AdminApiController::class, 'deletePlan']);
    });
});
