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

    // Admin Mobile API Endpoints (Cable / Admin Phone)
    Route::prefix('admin')->group(function () {
        Route::post('/scan-attendance', [AdminApiController::class, 'scanAttendance']);
        Route::get('/dashboard-stats', [AdminApiController::class, 'getDashboardStats']);
        Route::get('/members', [AdminApiController::class, 'getMembers']);
        Route::post('/renew-subscription', [AdminApiController::class, 'renewSubscription']);
    });
});
