@extends('layouts.app')
@section('title', __('messages.settings'))
@section('page-title', __('messages.settings'))

@section('content')
<div class="row justify-content-center">
<div class="col-lg-7">
<div class="card table-card">
    <div class="card-header bg-white border-0 py-3">
        <h6 class="mb-0 fw-semibold"><i class="bi bi-gear-fill text-secondary me-2"></i>{{ __('messages.settings') }}</h6>
    </div>
    <div class="card-body">
        @if($errors->any())
        <div class="alert alert-danger"><ul class="mb-0">@foreach($errors->all() as $e)<li>{{ $e }}</li>@endforeach</ul></div>
        @endif

        <form method="POST" action="{{ route('settings.update') }}">
            @csrf
            <div class="row g-3">
                <div class="col-12">
                    <label class="form-label fw-semibold">{{ __('messages.gym_name') }} <span class="text-danger">*</span></label>
                    <input type="text" name="gym_name" class="form-control @error('gym_name') is-invalid @enderror"
                           value="{{ old('gym_name', $settings['gym_name']) }}" required>
                    @error('gym_name')<div class="invalid-feedback">{{ $message }}</div>@enderror
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">{{ __('messages.gym_phone') }}</label>
                    <input type="text" name="gym_phone" class="form-control"
                           value="{{ old('gym_phone', $settings['gym_phone']) }}">
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">{{ __('messages.currency') }}</label>
                    <select name="currency" class="form-select">
                        <option value="IQD" {{ $settings['currency'] === 'IQD' ? 'selected' : '' }}>IQD — Iraqi Dinar</option>
                        <option value="USD" {{ $settings['currency'] === 'USD' ? 'selected' : '' }}>USD — US Dollar</option>
                        <option value="EUR" {{ $settings['currency'] === 'EUR' ? 'selected' : '' }}>EUR — Euro</option>
                        <option value="TRY" {{ $settings['currency'] === 'TRY' ? 'selected' : '' }}>TRY — Turkish Lira</option>
                    </select>
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold">{{ __('messages.gym_address') }}</label>
                    <textarea name="gym_address" class="form-control" rows="2">{{ old('gym_address', $settings['gym_address']) }}</textarea>
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold">{{ __('messages.language') }}</label>
                    <select name="language" class="form-select">
                        <option value="en" {{ $settings['language'] === 'en' ? 'selected' : '' }}> English</option>
                        <option value="ku" {{ $settings['language'] === 'ku' ? 'selected' : '' }}> کوردی</option>
                    </select>
                </div>
            </div>
            <div class="mt-4">
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check-lg me-1"></i>{{ __('messages.save') }}
                </button>
            </div>
        </form>
    </div>
</div>
</div>
</div>
@endsection
