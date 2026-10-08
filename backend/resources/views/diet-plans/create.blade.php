@extends('layouts.app')

@section('title', 'زیادکردنی بەرنامەی خواردن')
@section('page-title', 'بەرنامەی خواردن')

@push('styles')
<style>
    .form-card { background: #fff; border-radius: 24px; border: 1px solid #f1f5f9; box-shadow: 0 10px 40px rgba(0,0,0,0.03); }
    .form-label { font-weight: 800; font-size: 0.8rem; color: #64748b; text-transform: uppercase; margin-bottom: 0.6rem; }
    .form-control, .form-select { border-radius: 12px; padding: 0.75rem 1rem; border: 1px solid #e2e8f0; font-weight: 600; }
    .form-control:focus, .form-select:focus { border-color: var(--accent); box-shadow: 0 0 0 4px rgba(var(--accent-rgb), 0.1); }
    
    .meal-row { background: #f8fafc; border-radius: 16px; padding: 1.5rem; margin-bottom: 1rem; border: 1px solid transparent; transition: all 0.2s; }
    .meal-row:hover { background: #fff; border-color: #e2e8f0; box-shadow: 0 4px 15px rgba(0,0,0,0.02); }
    
    .btn-add-meal { background: #f0fdf4; color: #16a34a; border: 1px dashed #22c55e; border-radius: 12px; width: 100%; padding: 1rem; font-weight: 800; transition: all 0.2s; }
    .btn-add-meal:hover { background: #22c55e; color: #fff; border-style: solid; }
</style>
@endpush

@section('content')
<div class="animate-in" style="max-width: 1000px; margin: 0 auto;">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div class="d-flex align-items-center">
            <a href="{{ route('diet-plans.index') }}" class="btn btn-light rounded-circle p-2 me-3 border">
                <i class="bi bi-arrow-right fs-5"></i>
            </a>
            <h3 class="mb-0 fw-900">زیادکردنی بەرنامەی خواردن</h3>
        </div>
    </div>

    <form action="{{ route('diet-plans.store') }}" method="POST">
        @csrf
        <div class="row g-4">
            <div class="col-lg-8">
                <div class="form-card p-4 mb-4">
                    <h6 class="fw-900 text-dark mb-4"><i class="bi bi-info-circle text-success me-2"></i>زانیارییە سەرەکییەکان</h6>
                    <div class="row g-3">
                        <div class="col-12">
                            <input type="text" name="title" class="form-control" value="{{ old('title') }}" placeholder="" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">بەرواری دەستپێکردن</label>
                            <input type="date" name="start_date" class="form-control" value="{{ old('start_date', date('Y-m-d')) }}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">بەرواری کۆتایی</label>
                            <input type="date" name="end_date" class="form-control" value="{{ old('end_date') }}">
                        </div>
                        <div class="col-12">
                            <label class="form-label">وەسف و ڕێنمایی گشتی</label>
                            <textarea name="description" class="form-control" rows="3" placeholder=""></textarea>
                        </div>
                    </div>
                </div>

                <div class="form-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h6 class="fw-900 text-dark mb-0"><i class="bi bi-egg-fried text-success me-2"></i>ژەمەکان و کاتی خواردن</h6>
                    </div>
                    
                    <div id="mealsContainer">
                        <!-- Starts empty as requested -->
                    </div>

                    <button type="button" class="btn btn-add-meal mt-2" onclick="addMeal()">
                        <i class="bi bi-plus-circle me-2"></i>زیادکردنی ژەمی تر
                    </button>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="form-card p-4 sticky-top" style="top: 100px;">
                    <div class="mb-4">
                        <label class="form-label">یاریزان <span class="text-danger">*</span></label>
                        <select name="member_id" class="form-select" required>
                            <option value="">-- یاریزانێک هەڵبژێرە... --</option>
                            @foreach($members as $member)
                            <option value="{{ $member->id }}">{{ $member->name }}</option>
                            @endforeach
                        </select>
                    </div>
                    <div class="mb-4">
                        <label class="form-label">ڕاهێنەری بەرپرس</label>
                        <select name="trainer_id" class="form-select">
                            <option value="">-- ڕاهێنەر هەڵبژێرە --</option>
                            @foreach($trainers as $trainer)
                            <option value="{{ $trainer->id }}">{{ $trainer->name }}</option>
                            @endforeach
                        </select>
                    </div>
                    
                    <hr class="my-4 opacity-50">
                    
                    <button type="submit" class="btn btn-success w-100 py-3 fw-900 rounded-pill shadow-sm mb-2">
                        <i class="bi bi-check-all me-2"></i>خەزنکردنی بەرنامە
                    </button>
                    <a href="{{ route('diet-plans.index') }}" class="btn btn-light w-100 py-2 fw-bold rounded-pill border">پەشیمانبوونەوە</a>
                </div>
            </div>
        </div>
    </form>
</div>

<script>
    let mealCount = 0;
    function addMeal() {
        const div = document.createElement('div');
        div.className = 'meal-row';
        div.innerHTML = `
            <div class="row g-2">
                <div class="col-md-3">
                    <label class="form-label small">کاتی خواردن</label>
                    <input type="text" name="meals[${mealCount}][time]" class="form-control" placeholder="">
                </div>
                <div class="col-md-8">
                    <label class="form-label small">جۆری خواردنەکان</label>
                    <input type="text" name="meals[${mealCount}][food]" class="form-control" placeholder="">
                </div>
                <div class="col-md-1 d-flex align-items-end justify-content-center">
                    <button type="button" class="btn btn-link text-danger p-0 mb-2" onclick="this.closest('.meal-row').remove()"><i class="bi bi-trash fs-5"></i></button>
                </div>
            </div>
        `;
        document.getElementById('mealsContainer').appendChild(div);
        mealCount++;
    }
</script>
@endsection
