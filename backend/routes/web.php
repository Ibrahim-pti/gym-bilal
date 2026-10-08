<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\MemberController;
use App\Http\Controllers\SubscriptionController;
use App\Http\Controllers\SubscriptionPlanController;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\ReportController;
use App\Http\Controllers\SettingsController;
use App\Http\Controllers\BackupController;
use App\Http\Controllers\LanguageController;
use App\Http\Controllers\ExpenseController;
use App\Http\Controllers\AttendanceController;
use App\Http\Controllers\TrainerController;
use App\Http\Controllers\EquipmentController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\SaleController;
use App\Http\Controllers\DietPlanController;
use App\Http\Controllers\WorkoutPlanController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\DebtController;

// Redirect root to dashboard or login
Route::get('/', fn() => redirect()->route('dashboard'));

// Language switch
Route::get('/lang/{locale}', [LanguageController::class, 'switch'])->name('lang.switch');

// Auth
Route::get('/login',  [LoginController::class, 'showLoginForm'])->name('login');
Route::post('/login', [LoginController::class, 'login']);
Route::post('/logout', [LoginController::class, 'logout'])->name('logout');

// Authenticated routes
Route::middleware('auth')->group(function () {
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

    // Admin Only Routes
    Route::middleware('role:admin')->group(function () {
        // Members
        Route::resource('members', MemberController::class);

        // Subscriptions
        Route::resource('subscriptions', SubscriptionController::class);
        Route::post('/subscriptions/{subscription}/renew', [SubscriptionController::class, 'renew'])
             ->name('subscriptions.renew');

        // Subscription Plans
        Route::resource('subscription-plans', SubscriptionPlanController::class);

        // Payments
        Route::resource('payments', PaymentController::class)->except(['edit', 'update']);

        // Reports
        Route::get('/reports', [ReportController::class, 'index'])->name('reports.index');
        Route::get('/reports/export', [ReportController::class, 'export'])->name('reports.export');

        // Expenses
        Route::resource('expenses', ExpenseController::class)->except(['show']);

        // Attendances
        Route::resource('attendances', AttendanceController::class)->only(['index', 'store', 'update', 'destroy']);

        // Trainers
        Route::resource('trainers', TrainerController::class);

        // Equipment
        Route::resource('equipment', EquipmentController::class)->except(['show']);

        // Settings
        Route::get('/settings', [SettingsController::class, 'index'])->name('settings.index');
        Route::post('/settings', [SettingsController::class, 'update'])->name('settings.update');

        // Backups
        Route::get('/backups', [BackupController::class, 'index'])->name('backups.index');
        Route::post('/backups', [BackupController::class, 'store'])->name('backups.store');
        Route::get('/backups/{filename}/download', [BackupController::class, 'download'])->name('backups.download');
        Route::delete('/backups/{filename}', [BackupController::class, 'destroy'])->name('backups.destroy');

        // Users
        Route::resource('users', UserController::class);

        // Plans
        Route::resource('diet-plans', DietPlanController::class);
        Route::resource('workout-plans', WorkoutPlanController::class);
    });

    // Store & POS (Accessible by Admin and Store Keeper)
    Route::middleware('role:admin,store_keeper')->group(function () {
        Route::resource('products', ProductController::class);
        Route::resource('sales', SaleController::class);
        Route::get('/sales/{sale}/print', [SaleController::class, 'print'])->name('sales.print');
        
        // Debts Management
        Route::get('/debts', [DebtController::class, 'index'])->name('debts.index');
        Route::post('/debts/{member}/pay', [DebtController::class, 'pay'])->name('debts.pay');
    });
});
