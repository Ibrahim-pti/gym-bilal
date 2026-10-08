<?php

namespace App\Http\Controllers;

use App\Models\DietPlan;
use App\Models\Member;
use App\Models\Trainer;
use Illuminate\Http\Request;

class DietPlanController extends Controller
{
    public function index()
    {
        $dietPlans = DietPlan::with(['member', 'trainer'])->latest()->paginate(10);
        return view('diet-plans.index', compact('dietPlans'));
    }

    public function create()
    {
        $members = Member::all();
        $trainers = Trainer::all();
        return view('diet-plans.create', compact('members', 'trainers'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'member_id' => 'required|exists:members,id',
            'trainer_id' => 'nullable|exists:trainers,id',
            'title' => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'start_date' => 'nullable|date',
            'end_date' => 'nullable|date',
            'meals' => 'nullable|array',
        ]);

        $validated['title'] = $validated['title'] ?? 'بەرنامەی خواردن';
        DietPlan::create($validated);

        return redirect()->route('diet-plans.index')->with('success', 'Diet plan created successfully.');
    }

    public function edit(DietPlan $dietPlan)
    {
        $members = Member::all();
        $trainers = Trainer::all();
        return view('diet-plans.edit', compact('dietPlan', 'members', 'trainers'));
    }

    public function update(Request $request, DietPlan $dietPlan)
    {
        $validated = $request->validate([
            'member_id' => 'required|exists:members,id',
            'trainer_id' => 'nullable|exists:trainers,id',
            'title' => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'start_date' => 'nullable|date',
            'end_date' => 'nullable|date',
            'meals' => 'nullable|array',
        ]);

        $validated['title'] = $validated['title'] ?? $dietPlan->title;
        $dietPlan->update($validated);

        return redirect()->route('diet-plans.index')->with('success', 'Diet plan updated successfully.');
    }

    public function show(DietPlan $dietPlan)
    {
        $dietPlan->load(['member', 'trainer']);
        return view('diet-plans.show', compact('dietPlan'));
    }

    public function destroy(DietPlan $dietPlan)
    {
        $dietPlan->delete();
        return redirect()->route('diet-plans.index')->with('success', 'Diet plan deleted successfully.');
    }
}
