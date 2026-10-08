@extends('layouts.app')
@section('title', 'دەستکاریکردنی یاریزان')
@section('page-title', 'دەستکاریکردنی یاریزان')

@section('content')
<div class="row justify-content-center">
<div class="col-lg-8">
<div class="card table-card border-0 shadow-sm" style="border-radius: 20px;">
    <div class="card-header bg-white border-0 py-4">
        <h5 class="mb-0 fw-bold"><i class="bi bi-pencil-square text-warning me-2"></i>دەستکاریکردنی یاریزان: {{ $member->name }}</h5>
    </div>
    <div class="card-body p-4">
        @if($errors->any())
        <div class="alert alert-danger"><ul class="mb-0">@foreach($errors->all() as $e)<li>{{ $e }}</li>@endforeach</ul></div>
        @endif

        <form method="POST" action="{{ route('members.update', $member) }}">
            @csrf @method('PUT')
            <div class="row g-4">
                <div class="col-md-8">
                    <label class="form-label fw-bold small text-muted text-uppercase">ناوی یاریزان <span class="text-danger">*</span></label>
                    <input type="text" name="name" class="form-control form-control-lg bg-light border-0 @error('name') is-invalid @enderror"
                           value="{{ old('name', $member->name) }}" required>
                    @error('name')<div class="invalid-feedback">{{ $message }}</div>@enderror
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold small text-muted text-uppercase">ڕەگەز <span class="text-danger">*</span></label>
                    <select name="gender" class="form-select form-select-lg bg-light border-0" required>
                        <option value="male"   {{ old('gender', $member->gender) === 'male'   ? 'selected' : '' }}>نێر</option>
                        <option value="female" {{ old('gender', $member->gender) === 'female' ? 'selected' : '' }}>مێ</option>
                    </select>
                </div>
                <div class="col-12">
                    <label class="form-label fw-bold small text-muted text-uppercase">تێبینی</label>
                    <input type="text" name="notes" class="form-control form-control-lg bg-light border-0" value="{{ old('notes', $member->notes) }}">
                </div>
            </div>

            <div class="mt-5 d-flex gap-3">
                <button type="submit" class="btn btn-primary px-5 py-2 fw-bold rounded-pill">تۆمارکردن</button>
                <a href="{{ route('members.index') }}" class="btn btn-light px-5 py-2 fw-bold rounded-pill">گەڕانەوە</a>
            </div>
        </form>
    </div>
</div>
</div>
</div>
@endsection
