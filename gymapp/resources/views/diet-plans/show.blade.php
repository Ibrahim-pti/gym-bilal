@extends('layouts.app')

@section('title', 'Diet Plan - ' . $dietPlan->member->name)

@section('content')
<div class="animate-in" style="max-width: 800px; margin: 0 auto;">
    <div class="d-flex justify-content-between align-items-center mb-4 d-print-none">
        <a href="{{ route('diet-plans.index') }}" class="btn btn-light">
            <i class="bi bi-arrow-left"></i>
        </a>
        <button onclick="window.print()" class="btn btn-primary">
            <i class="bi bi-printer me-2"></i> PRINT PLAN
        </button>
    </div>

    <div class="card border-0 shadow-sm overflow-hidden">
        <div class="p-5 bg-white">
            <div class="text-center mb-5 border-bottom pb-4">
                <h2 class="fw-bold mb-1">{{ \App\Models\Setting::get('gym_name', 'GYM') }}</h2>
                <h5 class="text-accent fw-bold text-uppercase tracking-widest">NUTRITION & DIET PLAN</h5>
            </div>

            <div class="row mb-5 g-4">
                <div class="col-6">
                    <label class="text-muted small text-uppercase fw-bold">Member Name</label>
                    <div class="fw-bold fs-5">{{ $dietPlan->member->name }}</div>
                </div>
                <div class="col-6 text-end">
                    <label class="text-muted small text-uppercase fw-bold">Trainer</label>
                    <div class="fw-bold fs-5">{{ $dietPlan->trainer->name ?? 'House Plan' }}</div>
                </div>
                <div class="col-6">
                    <label class="text-muted small text-uppercase fw-bold">Plan Title</label>
                    <div class="fw-bold">{{ $dietPlan->title }}</div>
                </div>
                <div class="col-6 text-end">
                    <label class="text-muted small text-uppercase fw-bold">Validity</label>
                    <div class="fw-bold">
                        @if($dietPlan->start_date && $dietPlan->end_date)
                            {{ $dietPlan->start_date->format('M d') }} - {{ $dietPlan->end_date->format('M d, Y') }}
                        @else
                            Ongoing
                        @endif
                    </div>
                </div>
            </div>

            @if($dietPlan->description)
            <div class="mb-5 p-3 bg-light rounded">
                <label class="text-muted small text-uppercase fw-bold mb-2 d-block">Plan Overview</label>
                <p class="mb-0">{{ $dietPlan->description }}</p>
            </div>
            @endif

            <h6 class="fw-bold border-bottom pb-2 mb-4 text-accent text-uppercase"><i class="bi bi-clock-history me-2"></i> Meal Schedule</h6>
            
            <div class="table-responsive">
                <table class="table table-bordered">
                    <thead class="bg-light">
                        <tr>
                            <th width="120" class="text-center">Time</th>
                            <th>Food Items & Instructions</th>
                        </tr>
                    </thead>
                    <tbody>
                        @if($dietPlan->meals)
                            @foreach($dietPlan->meals as $meal)
                            <tr>
                                <td class="text-center fw-bold">{{ $meal['time'] ?? '-' }}</td>
                                <td>{{ $meal['food'] ?? '-' }}</td>
                            </tr>
                            @endforeach
                        @else
                            <tr>
                                <td colspan="2" class="text-center py-4 text-muted">No meal details provided.</td>
                            </tr>
                        @endif
                    </tbody>
                </table>
            </div>

            <div class="mt-5 pt-5 border-top text-center text-muted small">
                <p>This plan is tailored for your specific goals. Consistency is key to success!</p>
                <div class="fw-bold">{{ \App\Models\Setting::get('gym_address', '') }}</div>
                <div>{{ \App\Models\Setting::get('gym_phone', '') }}</div>
            </div>
        </div>
    </div>
</div>

<style>
@media print {
    .sidebar, .topbar, .d-print-none { display: none !important; }
    .main-wrapper { margin: 0 !important; padding: 0 !important; }
    .content-area { padding: 0 !important; }
    .card { border: none !important; box-shadow: none !important; }
    body { background: white !important; }
}
</style>
@endsection
