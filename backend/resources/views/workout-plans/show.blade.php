@extends('layouts.app')

@section('title', 'بەرنامەی ڕاهێنانی ' . $workoutPlan->member->name)

@section('content')
<div class="animate-in" style="max-width: 850px; margin: 0 auto;">
    {{-- Action Bar --}}
    <div class="d-flex justify-content-between align-items-center mb-4 d-print-none">
        <a href="{{ route('workout-plans.index') }}" class="btn btn-light rounded-pill px-4 border">
            <i class="bi bi-arrow-right me-2"></i>گەڕانەوە
        </a>
        <button onclick="window.print()" class="btn btn-dark rounded-pill px-4 shadow-sm">
            <i class="bi bi-printer me-2"></i>چاپکردنی بەرنامە
        </button>
    </div>

    {{-- Program Receipt Card --}}
    <div class="card border-0 shadow-sm overflow-hidden" style="border-radius: 30px;">
        <div class="p-5 bg-white">
            {{-- Header --}}
            <div class="text-center mb-5 border-bottom pb-4">
                <h1 class="fw-900 mb-1 text-dark" style="letter-spacing: -1px;">{{ \App\Models\Setting::get('gym_name', 'GYM') }}</h1>
                <h5 class="text-primary fw-900 text-uppercase" style="letter-spacing: 2px;">بەرنامەی ڕاهێنانی یاریزان</h5>
            </div>

            {{-- Info Section --}}
            <div class="row mb-5 g-4">
                <div class="col-6">
                    <label class="text-muted small text-uppercase fw-800 mb-1 d-block">ناوی یاریزان</label>
                    <div class="fw-900 fs-4 text-dark">{{ $workoutPlan->member->name }}</div>
                </div>
                <div class="col-6 text-end">
                    <label class="text-muted small text-uppercase fw-800 mb-1 d-block">ڕاهێنەر</label>
                    <div class="fw-900 fs-4 text-dark">{{ $workoutPlan->trainer->name ?? 'ڕاهێنەری گشتی' }}</div>
                </div>
                <div class="col-6">
                    <label class="text-muted small text-uppercase fw-800 mb-1 d-block">ناونیشانی بەرنامە</label>
                    <div class="fw-bold text-muted">{{ $workoutPlan->title ?: 'بەرنامەی گشتی' }}</div>
                </div>
                <div class="col-6 text-end">
                    <label class="text-muted small text-uppercase fw-800 mb-1 d-block">ماوەی کارپێکردن</label>
                    <div class="fw-bold text-muted">
                        @if($workoutPlan->start_date && $workoutPlan->end_date)
                            {{ $workoutPlan->start_date->format('Y-m-d') }} - {{ $workoutPlan->end_date->format('Y-m-d') }}
                        @else
                            بەردەوام
                        @endif
                    </div>
                </div>
            </div>

            {{-- Notes Section --}}
            @if($workoutPlan->description)
            <div class="mb-5 p-4 bg-light" style="border-radius: 20px; border-right: 5px solid var(--accent);">
                <label class="text-muted small text-uppercase fw-800 mb-2 d-block">تێبینی و ڕێنمایی</label>
                <p class="mb-0 fw-bold text-dark" style="line-height: 1.6;">{{ $workoutPlan->description }}</p>
            </div>
            @endif

            {{-- Exercise Table --}}
            <h6 class="fw-900 border-bottom pb-2 mb-4 text-dark text-uppercase"><i class="bi bi-activity me-2 text-primary"></i> خشتەی ڕاهێنانەکان</h6>
            
            <div class="table-responsive">
                <table class="table table-bordered border-light" style="border-radius: 15px; overflow: hidden;">
                    <thead class="bg-dark text-white">
                        <tr>
                            <th class="py-3 px-4">ناوی ڕاهێنان</th>
                            <th width="120" class="text-center py-3">سێت (Sets)</th>
                            <th width="200" class="text-center py-3">دووبارە (Reps)</th>
                        </tr>
                    </thead>
                    <tbody>
                        @if($workoutPlan->exercises)
                            @foreach($workoutPlan->exercises as $ex)
                            <tr>
                                <td class="fw-900 py-3 px-4 fs-5 text-dark align-middle">{{ $ex['name'] ?? '-' }}</td>
                                <td class="text-center py-3 fw-bold fs-5 align-middle">{{ $ex['sets'] ?? '-' }}</td>
                                <td class="py-3 px-3 align-middle text-center">
                                    <div class="fw-900 text-primary fs-5">
                                        @php
                                            $repValues = explode(' ', ($ex['reps'] ?? ''));
                                            $repValues = array_filter($repValues);
                                        @endphp
                                        @if(count($repValues) > 1)
                                            {{ implode(' • ', $repValues) }}
                                        @else
                                            {{ $ex['reps'] ?? '-' }}
                                        @endif
                                    </div>
                                    @if(count($repValues) > 1)
                                        <div class="extra-small text-muted fw-bold mt-1 text-uppercase" style="font-size: 0.6rem;">تکراری سێتەکان</div>
                                    @endif
                                </td>
                            </tr>
                            @endforeach
                        @else
                            <tr>
                                <td colspan="3" class="text-center py-5 text-muted">هیچ ڕاهێنانێک تۆمار نەکراوە.</td>
                            </tr>
                        @endif
                    </tbody>
                </table>
            </div>

            {{-- Footer --}}
            <div class="mt-5 pt-5 border-top text-center text-muted">
                <p class="fw-bold mb-3" style="font-size: 1.1rem; color: #1e293b;">بە هیوای تەندروستییەکی باش بۆ تۆی وەرزشەوان!</p>
                <div class="fw-bold text-dark">{{ \App\Models\Setting::get('gym_address', '') }}</div>
                <div class="fw-bold text-primary">{{ \App\Models\Setting::get('gym_phone', '') }}</div>
            </div>
        </div>
    </div>
</div>

<style>
@media print {
    .sidebar, .topbar, .d-print-none, #sidebarToggle { display: none !important; }
    .main-wrapper { margin: 0 !important; padding: 0 !important; width: 100% !important; }
    .content-area { padding: 0 !important; }
    .card { border: none !important; box-shadow: none !important; }
    body { background: white !important; margin: 0; padding: 0; }
    .table-responsive { overflow: visible !important; }
}
.fw-900 { font-weight: 900; }
.fw-800 { font-weight: 800; }
</style>
@endsection
