<?php

namespace App\Http\Controllers;

use App\Models\Member;
use App\Models\Payment;
use App\Models\Subscription;
use App\Models\Expense;
use App\Models\Attendance;
use App\Models\Trainer;
use App\Models\Equipment;
use App\Models\Sale;
use App\Models\Product;
use Carbon\Carbon;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index()
    {
        $totalMembers   = Member::count();
        $activeMembers  = Member::whereHas('subscriptions', fn($q) =>
            $q->where('status', 'active')->where('end_date', '>=', Carbon::today())
        )->count();
        $expiredMembers = $totalMembers - $activeMembers;

        $todayRevenue   = Payment::whereDate('payment_date', Carbon::today())->sum('amount');
        $monthRevenue   = Payment::whereYear('payment_date', Carbon::now()->year)
                                 ->whereMonth('payment_date', Carbon::now()->month)
                                 ->sum('amount');

        // Store Sales
        $todayStoreSales = Sale::whereDate('created_at', Carbon::today())->sum('total_amount');
        $monthStoreSales = Sale::whereYear('created_at', Carbon::now()->year)
                               ->whereMonth('created_at', Carbon::now()->month)
                               ->sum('total_amount');

        // Expenses
        $monthExpenses = Expense::whereYear('date', Carbon::now()->year)
                                ->whereMonth('date', Carbon::now()->month)
                                ->sum('amount');
        $monthProfit = $monthRevenue - $monthExpenses;

        // Today's attendance
        $todayAttendance = Attendance::whereDate('check_in', Carbon::today())->count();
        $activeNow = Attendance::whereDate('check_in', Carbon::today())
                               ->whereNull('check_out')
                               ->count();

        // Active trainers
        $activeTrainers = Trainer::where('status', 'active')->count();

        // Equipment needing maintenance
        $equipmentAlert = Equipment::where('next_maintenance', '<=', Carbon::today())->count();

        // Product Alerts
        $lowStockProducts = Product::where('stock_quantity', '<=', 5)->count();
        $expiredProducts = Product::where('expiry_date', '<', Carbon::today())->count();
        $nearExpiryProducts = Product::whereBetween('expiry_date', [Carbon::today(), Carbon::today()->addDays(30)])->count();
        $totalProducts = Product::count();

        $recentPayments = Payment::with('member')
                                 ->orderByDesc('payment_date')
                                 ->limit(5)
                                 ->get();

        $expiringMembers = Subscription::with('member')
            ->where('status', 'active')
            ->whereBetween('end_date', [Carbon::today(), Carbon::today()->addDays(7)])
            ->get();

        // Monthly revenue chart - SQLite compatible
        $revenueData = [];
        $expenseData = [];
        for ($i = 1; $i <= 12; $i++) {
            $revenueData[] = (float) Payment::whereYear('payment_date', Carbon::now()->year)
                ->whereMonth('payment_date', $i)
                ->sum('amount');
            $expenseData[] = (float) Expense::whereYear('date', Carbon::now()->year)
                ->whereMonth('date', $i)
                ->sum('amount');
        }

        // Recent activity (last 5 attendances)
        $recentAttendances = Attendance::with('member')
            ->latest('check_in')
            ->limit(5)
            ->get();

        return view('dashboard', compact(
            'totalMembers', 'activeMembers', 'expiredMembers',
            'todayRevenue', 'monthRevenue', 'monthExpenses', 'monthProfit',
            'todayStoreSales', 'monthStoreSales',
            'todayAttendance', 'activeNow', 'activeTrainers', 'equipmentAlert',
            'lowStockProducts', 'expiredProducts', 'nearExpiryProducts', 'totalProducts',
            'recentPayments', 'expiringMembers',
            'revenueData', 'expenseData', 'recentAttendances'
        ));
    }
}
