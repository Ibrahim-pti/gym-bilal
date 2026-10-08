<?php

namespace App\Http\Controllers;

use App\Models\Expense;
use Illuminate\Http\Request;

class ExpenseController extends Controller
{
    public function index()
    {
        $expenses = Expense::latest('date')->paginate(15);
        $totalExpenses = Expense::sum('amount');
        return view('expenses.index', compact('expenses', 'totalExpenses'));
    }

    public function create()
    {
        return view('expenses.create');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'amount' => 'required|numeric|min:0',
            'date' => 'required|date',
            'description' => 'nullable|string'
        ]);

        Expense::create($validated);

        return redirect()->route('expenses.index')->with('success', __('messages.expense_added', ['default' => 'Expense added successfully']));
    }

    public function edit(Expense $expense)
    {
        return view('expenses.edit', compact('expense'));
    }

    public function update(Request $request, Expense $expense)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'amount' => 'required|numeric|min:0',
            'date' => 'required|date',
            'description' => 'nullable|string'
        ]);

        $expense->update($validated);

        return redirect()->route('expenses.index')->with('success', __('messages.expense_updated', ['default' => 'Expense updated successfully']));
    }

    public function destroy(Expense $expense)
    {
        $expense->delete();
        return redirect()->route('expenses.index')->with('success', __('messages.expense_deleted', ['default' => 'Expense deleted successfully']));
    }
}
