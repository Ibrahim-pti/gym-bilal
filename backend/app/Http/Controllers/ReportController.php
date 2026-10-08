<?php

namespace App\Http\Controllers;

use App\Models\Member;
use App\Models\Payment;
use App\Models\Subscription;
use App\Models\Expense;
use App\Models\Trainer;
use Carbon\Carbon;
use Illuminate\Http\Request;

class ReportController extends Controller
{
    public function index(Request $request)
    {
        $year  = $request->get('year',  Carbon::now()->year);
        $month = $request->get('month', null);

        // Revenue & Expenses by month - SQLite compatible
        $revenueData = [];
        $expenseData = [];
        $profitData = [];
        for ($i = 1; $i <= 12; $i++) {
            $rev = (float) Payment::whereYear('payment_date', $year)
                ->whereMonth('payment_date', $i)
                ->sum('amount');
            $exp = (float) Expense::whereYear('date', $year)
                ->whereMonth('date', $i)
                ->sum('amount');
            $revenueData[] = $rev;
            $expenseData[] = $exp;
            $profitData[] = $rev - $exp;
        }

        // Revenue filtered by month if set
        $revenueQuery = Payment::whereYear('payment_date', $year);
        if ($month) {
            $revenueQuery->whereMonth('payment_date', $month);
        }
        $totalRevenue = $revenueQuery->sum('amount');

        // Expenses filtered
        $expenseQuery = Expense::whereYear('date', $year);
        if ($month) {
            $expenseQuery->whereMonth('date', $month);
        }
        $totalExpenses = $expenseQuery->sum('amount');

        // Trainer salaries (monthly cost)
        $trainerSalaries = Trainer::where('status', 'active')->sum('salary');

        // Net profit
        $netProfit = $totalRevenue - $totalExpenses;

        // New members
        $newMembersQuery = Member::whereYear('created_at', $year);
        if ($month) {
            $newMembersQuery->whereMonth('created_at', $month);
        }
        $newMembers = $newMembersQuery->count();

        // Active vs expired
        $activeCount  = Member::whereHas('subscriptions', fn($q) =>
            $q->where('status', 'active')->where('end_date', '>=', Carbon::today())
        )->count();
        $expiredCount = Member::count() - $activeCount;

        // Top paying members - SQLite compatible
        $topMembers = Payment::whereYear('payment_date', $year)
            ->with('member')
            ->get()
            ->groupBy('member_id')
            ->map(function ($payments, $memberId) {
                return (object) [
                    'member_id' => $memberId,
                    'total' => $payments->sum('amount'),
                    'member' => $payments->first()->member,
                ];
            })
            ->sortByDesc('total')
            ->take(10)
            ->values();

        $years = range(Carbon::now()->year, 2020);

        return view('reports.index', compact(
            'year', 'month', 'revenueData', 'expenseData', 'profitData',
            'totalRevenue', 'totalExpenses', 'trainerSalaries', 'netProfit',
            'newMembers', 'activeCount', 'expiredCount', 'topMembers', 'years'
        ));
    }

    public function export(Request $request)
    {
        $year  = $request->get('year',  Carbon::now()->year);
        $month = $request->get('month', null);

        $query = Payment::with(['member', 'subscription.plan'])
            ->whereYear('payment_date', $year);

        if ($month) {
            $query->whereMonth('payment_date', $month);
        }

        $payments = $query->orderByDesc('payment_date')->get();

        $filename = 'payments_' . $year . ($month ? '_' . str_pad($month, 2, '0', STR_PAD_LEFT) : '') . '.csv';

        $headers = [
            'Content-Type'        => 'text/csv',
            'Content-Disposition' => "attachment; filename=\"$filename\"",
        ];

        $callback = function () use ($payments) {
            $handle = fopen('php://output', 'w');
            fputcsv($handle, ['Receipt #', 'Member', 'Plan', 'Amount', 'Method', 'Date']);
            foreach ($payments as $p) {
                fputcsv($handle, [
                    $p->receipt_number,
                    $p->member?->name,
                    $p->subscription?->plan?->name,
                    $p->amount,
                    $p->payment_method,
                    $p->payment_date,
                ]);
            }
            fclose($handle);
        };

        return response()->stream($callback, 200, $headers);
    }
}
