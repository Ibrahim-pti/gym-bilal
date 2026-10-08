<?php

namespace App\Http\Controllers;

use App\Models\Member;
use Illuminate\Http\Request;

class DebtController extends Controller
{
    public function index(Request $request)
    {
        $query = Member::where('balance', '>', 0);

        if ($request->search) {
            $query->where('name', 'like', "%{$request->search}%")
                  ->orWhere('phone', 'like', "%{$request->search}%");
        }

        $members = $query->latest()->paginate(10);
        return view('debts.index', compact('members'));
    }

    public function pay(Request $request, Member $member)
    {
        $request->validate([
            'amount' => 'required|numeric|min:1|max:' . $member->balance,
        ]);

        $member->decrement('balance', $request->amount);

        return redirect()->back()->with('success', 'Debt payment processed successfully.');
    }
}
