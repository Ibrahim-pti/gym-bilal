@extends('layouts.app')
@section('title', __('messages.edit_plan'))
@section('page-title', __('messages.edit_plan'))

@section('content')
<div class="row justify-content-center">
<div class="col-lg-6">
<div class="card table-card">
    <div class="card-header bg-white border-0 py-3">
        <h6 class="mb-0 fw-semibold"><i class="bi bi-pencil-fill text-warning me-2"></i>{{ __('messages.edit_plan') }}: {{ $subscriptionPlan->name }}</h6>
    </div>
    <div class="card-body">
        @if($errors->any())
        <div class="alert alert-danger"><ul class="mb-0">@foreach($errors->all() as $e)<li>{{ $e }}</li>@endforeach</ul></div>
        @endif

        <form method="POST" action="{{ route('subscription-plans.update', $subscriptionPlan) }}">
            @csrf @method('PUT')
            <div class="row g-3">
                <div class="col-12">
                    <label class="form-label fw-semibold">{{ __('messages.plan_name') }} <span class="text-danger">*</span></label>
                    <input type="text" name="name" class="form-control"
                           value="{{ old('name', $subscriptionPlan->name) }}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">{{ __('messages.price') }}</label>
                    <input type="number" name="price" class="form-control"
                           value="{{ old('price', $subscriptionPlan->price) }}" min="0" step="0.01" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">{{ __('messages.duration') }}</label>
                    <input type="number" name="duration_days" class="form-control"
                           value="{{ old('duration_days', $subscriptionPlan->duration_days) }}" min="1" required>
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold">{{ __('messages.type') }}</label>
                    <select name="type" class="form-select">
                        <option value="monthly" {{ old('type', $subscriptionPlan->type) === 'monthly' ? 'selected' : '' }}>{{ __('messages.monthly') }}</option>
                        <option value="yearly"  {{ old('type', $subscriptionPlan->type) === 'yearly'  ? 'selected' : '' }}>{{ __('messages.yearly') }}</option>
                        <option value="custom"  {{ old('type', $subscriptionPlan->type) === 'custom'  ? 'selected' : '' }}>{{ __('messages.custom') }}</option>
                    </select>
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold">{{ __('messages.description') }}</label>
                    <textarea name="description" class="form-control" rows="2">{{ old('description', $subscriptionPlan->description) }}</textarea>
                </div>
                <div class="col-12">
                    <div class="form-check">
                        <input type="checkbox" name="is_active" class="form-check-input" id="isActive"
                               {{ old('is_active', $subscriptionPlan->is_active) ? 'checked' : '' }}>
                        <label class="form-check-label" for="isActive">{{ __('messages.is_active') }}</label>
                    </div>
                </div>
            </div>
            <div class="mt-4 d-flex gap-2">
                <button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i>{{ __('messages.save') }}</button>
                <a href="{{ route('subscription-plans.show', $subscriptionPlan) }}" class="btn btn-outline-secondary">{{ __('messages.cancel') }}</a>
            </div>
        </form>
    </div>
</div>
</div>
</div>
@endsection
