@extends('layouts.app')
@section('title', __('messages.edit_subscription'))
@section('page-title', __('messages.edit_subscription'))

@section('content')
<div class="row justify-content-center">
<div class="col-lg-7">
<div class="card table-card">
    <div class="card-header bg-white border-0 py-3">
        <h6 class="mb-0 fw-semibold"><i class="bi bi-pencil-fill text-warning me-2"></i>{{ __('messages.edit_subscription') }}</h6>
    </div>
    <div class="card-body">
        @if($errors->any())
        <div class="alert alert-danger"><ul class="mb-0">@foreach($errors->all() as $e)<li>{{ $e }}</li>@endforeach</ul></div>
        @endif

        <form method="POST" action="{{ route('subscriptions.update', $subscription) }}">
            @csrf @method('PUT')
            <div class="row g-3">
                <div class="col-12">
                    <label class="form-label fw-semibold">{{ __('messages.member') }}</label>
                    <input type="text" class="form-control" value="{{ $subscription->member?->name }}" disabled>
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold">{{ __('messages.plan') }}</label>
                    <input type="text" class="form-control" value="{{ $subscription->plan?->name }}" disabled>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">{{ __('messages.start_date') }} <span class="text-danger">*</span></label>
                    <input type="date" name="start_date" class="form-control"
                           value="{{ old('start_date', $subscription->start_date->format('Y-m-d')) }}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">{{ __('messages.end_date') }} <span class="text-danger">*</span></label>
                    <input type="date" name="end_date" class="form-control"
                           value="{{ old('end_date', $subscription->end_date->format('Y-m-d')) }}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">{{ __('messages.status') }}</label>
                    <select name="status" class="form-select" required>
                        <option value="active"  {{ old('status', $subscription->status) === 'active'  ? 'selected' : '' }}>{{ __('messages.active') }}</option>
                        <option value="expired" {{ old('status', $subscription->status) === 'expired' ? 'selected' : '' }}>{{ __('messages.expired') }}</option>
                        <option value="pending" {{ old('status', $subscription->status) === 'pending' ? 'selected' : '' }}>{{ __('messages.pending') }}</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">{{ __('messages.amount_paid') }}</label>
                    <input type="number" name="amount_paid" class="form-control"
                           value="{{ old('amount_paid', $subscription->amount_paid) }}" min="0" step="0.01" required>
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold">{{ __('messages.notes') }}</label>
                    <textarea name="notes" class="form-control" rows="2">{{ old('notes', $subscription->notes) }}</textarea>
                </div>
            </div>
            <div class="mt-4 d-flex gap-2">
                <button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i>{{ __('messages.save') }}</button>
                <a href="{{ route('subscriptions.show', $subscription) }}" class="btn btn-outline-secondary">{{ __('messages.cancel') }}</a>
            </div>
        </form>
    </div>
</div>
</div>
</div>
@endsection
