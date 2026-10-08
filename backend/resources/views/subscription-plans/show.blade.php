@extends('layouts.app')
@section('title', $subscriptionPlan->name)
@section('page-title', __('messages.plan_details'))

@section('content')
<div class="d-flex justify-content-between align-items-center mb-3">
    <a href="{{ route('subscription-plans.index') }}" class="btn btn-sm btn-outline-secondary">
        <i class="bi bi-arrow-left me-1"></i>{{ __('messages.back') }}
    </a>
    <div class="d-flex gap-2">
        <a href="{{ route('subscription-plans.edit', $subscriptionPlan) }}" class="btn btn-sm btn-warning">
            <i class="bi bi-pencil me-1"></i>{{ __('messages.edit') }}
        </a>
        <form method="POST" action="{{ route('subscription-plans.destroy', $subscriptionPlan) }}"
              onsubmit="return confirm('{{ __('messages.confirm_delete') }}')">
            @csrf @method('DELETE')
            <button type="submit" class="btn btn-sm btn-danger"><i class="bi bi-trash me-1"></i>{{ __('messages.delete') }}</button>
        </form>
    </div>
</div>

<div class="row g-3">
    <div class="col-md-4">
        <div class="card table-card">
            <div class="card-body">
                <h5 class="fw-bold mb-1">{{ $subscriptionPlan->name }}</h5>
                @if($subscriptionPlan->is_active)
                    <span class="badge badge-active mb-3">{{ __('messages.active') }}</span>
                @else
                    <span class="badge badge-expired mb-3">{{ __('messages.no') }}</span>
                @endif
                <table class="table table-sm">
                    <tr><th class="text-muted">{{ __('messages.price') }}</th><td class="fw-bold text-primary fs-5">{{ number_format($subscriptionPlan->price) }}</td></tr>
                    <tr><th class="text-muted">{{ __('messages.duration') }}</th><td>{{ $subscriptionPlan->duration_days }} {{ __('messages.duration') }}</td></tr>
                    <tr><th class="text-muted">{{ __('messages.type') }}</th><td>{{ __('messages.' . $subscriptionPlan->type) }}</td></tr>
                    <tr><th class="text-muted">{{ __('messages.total_subscriptions') }}</th><td>{{ $subscriptionPlan->subscriptions->count() }}</td></tr>
                </table>
                @if($subscriptionPlan->description)
                <p class="text-muted small border-top pt-2">{{ $subscriptionPlan->description }}</p>
                @endif
            </div>
        </div>
    </div>

    <div class="col-md-8">
        <div class="card table-card">
            <div class="card-header bg-white border-0 py-3">
                <h6 class="mb-0 fw-semibold">{{ __('messages.subscription_history') }}</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table mb-0">
                        <thead>
                            <tr>
                                <th>{{ __('messages.member') }}</th>
                                <th>{{ __('messages.start_date') }}</th>
                                <th>{{ __('messages.end_date') }}</th>
                                <th>{{ __('messages.status') }}</th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse($subscriptionPlan->subscriptions as $sub)
                            <tr>
                                <td><a href="{{ route('members.show', $sub->member_id) }}" class="text-decoration-none fw-semibold">{{ $sub->member?->name }}</a></td>
                                <td class="small">{{ $sub->start_date->format('Y-m-d') }}</td>
                                <td class="small">{{ $sub->end_date->format('Y-m-d') }}</td>
                                <td>
                                    @if($sub->status === 'active' && !$sub->is_expired)
                                        <span class="badge badge-active">{{ __('messages.active') }}</span>
                                    @else
                                        <span class="badge badge-expired">{{ __('messages.expired') }}</span>
                                    @endif
                                </td>
                            </tr>
                            @empty
                            <tr><td colspan="4" class="text-center text-muted py-3">{{ __('messages.no_records') }}</td></tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
