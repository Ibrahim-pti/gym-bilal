<?php

namespace App\Http\Controllers;

use App\Models\WorkoutPlan;
use App\Models\Member;
use App\Models\Trainer;
use Illuminate\Http\Request;

class WorkoutPlanController extends Controller
{
    public function index()
    {
        $workoutPlans = WorkoutPlan::with(['member', 'trainer'])->latest()->paginate(10);
        return view('workout-plans.index', compact('workoutPlans'));
    }

    public function create()
    {
        $members = Member::all();
        $trainers = Trainer::all();
        return view('workout-plans.create', compact('members', 'trainers'));
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
            'exercises' => 'nullable|array',
        ]);

        $validated['title'] = $validated['title'] ?? 'بەرنامەی ڕاهێنان';
        WorkoutPlan::create($validated);

        return redirect()->route('workout-plans.index')->with('success', 'Workout plan created successfully.');
    }

    public function edit(WorkoutPlan $workoutPlan)
    {
        $members = Member::all();
        $trainers = Trainer::all();
        return view('workout-plans.edit', compact('workoutPlan', 'members', 'trainers'));
    }

    public function update(Request $request, WorkoutPlan $workoutPlan)
    {
        $validated = $request->validate([
            'member_id' => 'required|exists:members,id',
            'trainer_id' => 'nullable|exists:trainers,id',
            'title' => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'start_date' => 'nullable|date',
            'end_date' => 'nullable|date',
            'exercises' => 'nullable|array',
        ]);

        $validated['title'] = $validated['title'] ?? $workoutPlan->title;
        $workoutPlan->update($validated);

        return redirect()->route('workout-plans.index')->with('success', 'Workout plan updated successfully.');
    }

    public function show(WorkoutPlan $workoutPlan)
    {
        $workoutPlan->load(['member', 'trainer']);
        return view('workout-plans.show', compact('workoutPlan'));
    }

    public function destroy(WorkoutPlan $workoutPlan)
    {
        $workoutPlan->delete();
        return redirect()->route('workout-plans.index')->with('success', 'Workout plan deleted successfully.');
    }
}
