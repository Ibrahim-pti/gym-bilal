@extends('layouts.app')
@section('title', 'زیادکردنی یاریزان')
@section('page-title', 'زیادکردنی یاریزان')

@section('content')
<div class="row justify-content-center">
<div class="col-lg-8">
<div class="card table-card border-0 shadow-sm" style="border-radius: 20px;">
    <div class="card-header bg-white border-0 py-4">
        <h5 class="mb-0 fw-bold"><i class="bi bi-person-plus-fill text-primary me-2"></i>زیادکردنی یاریزانی نوێ</h5>
    </div>
    <div class="card-body p-4">
        @if($errors->any())
        <div class="alert alert-danger"><ul class="mb-0">@foreach($errors->all() as $e)<li>{{ $e }}</li>@endforeach</ul></div>
        @endif

        <form method="POST" action="{{ route('members.store') }}">
            @csrf
            <div class="row g-4">
                <div class="col-md-8">
                    <label class="form-label fw-bold small text-muted text-uppercase">ناوی یاریزان <span class="text-danger">*</span></label>
                    <input type="text" name="name" class="form-control form-control-lg bg-light border-0 @error('name') is-invalid @enderror"
                           placeholder="ناوی سیانی بنووسە..." value="{{ old('name') }}" required>
                    @error('name')<div class="invalid-feedback">{{ $message }}</div>@enderror
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold small text-muted text-uppercase">ڕەگەز <span class="text-danger">*</span></label>
                    <select name="gender" class="form-select form-select-lg bg-light border-0" required>
                        <option value="male"   {{ old('gender','male') === 'male'   ? 'selected' : '' }}>نێر</option>
                        <option value="female" {{ old('gender') === 'female' ? 'selected' : '' }}>مێ</option>
                    </select>
                </div>
                <div class="col-12">
                    <label class="form-label fw-bold small text-muted text-uppercase">تێبینی یان زانیاری زیاتر</label>
                    <input type="text" name="notes" class="form-control form-control-lg bg-light border-0" value="{{ old('notes') }}" placeholder="...">
                </div>

                <div class="col-12"><hr class="my-3 opacity-50"></div>
                
                {{-- Subscription Section --}}
                <div class="col-12">
                    <h6 class="fw-bold mb-3 text-primary"><i class="bi bi-card-checklist me-2"></i>دیاریکردنی بەشداری</h6>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold small text-muted text-uppercase">جۆری بەشداری</label>
                    <select name="subscription_plan_id" class="form-select form-select-lg bg-light border-0">
                        <option value="">— هەڵبژێرە —</option>
                        @foreach($plans as $plan)
                        <option value="{{ $plan->id }}" {{ old('subscription_plan_id') == $plan->id ? 'selected' : '' }}>
                            {{ $plan->name }} ({{ number_format($plan->price) }} IQD)
                        </option>
                        @endforeach
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold small text-muted text-uppercase">بەرواری دەستپێکردن</label>
                    <input type="date" name="start_date" class="form-control form-control-lg bg-light border-0" value="{{ old('start_date', date('Y-m-d')) }}">
                </div>
            </div>

            <div class="mt-5 d-flex gap-3">
                <button type="submit" class="btn btn-primary px-5 py-2 fw-bold rounded-pill">تۆمارکردن</button>
                <a href="{{ route('members.index') }}" class="btn btn-light px-5 py-2 fw-bold rounded-pill">هەڵوەشاندنەوە</a>
            </div>
        </form>
    </div>
</div>
</div>
</div>
@endsection
