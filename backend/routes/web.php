<?php

use Illuminate\Support\Facades\Route;

// Backend is purely an API for the mobile app - No website admin
Route::get('/', function () {
    return response()->json([
        'service' => 'Gym Bilal Backend API',
        'status'  => 'online',
        'message' => 'Backend is running for Flutter mobile app only.',
    ]);
});
