@extends('layouts.app')
@section('title', __('messages.subscription_details'))
@section('page-title', __('messages.subscription_details'))

@section('content')
<div class="d-flex justify-content-between align-items-center mb-3">
    <a href="{{ route('subscriptions.index') }}" class="btn btn-sm btn-outline-secondary">
        <i class="bi bi-arrow-left me-1"></i>{{ __('messages.back') }}
    </a>
    <div class="d-flex gap-2">
        <a href="{{ route('subscriptions.edit', $subscription) }}" class="btn btn-sm btn-warning">
            <i class="bi bi-pencil me-1"></i>{{ __('messages.edit') }}
        </a>
        @if($subscription->is_expired || $subscription->status !== 'active')
        <form method="POST" action="{{ route('subscriptions.renew', $subscription) }}">
            @csrf
            <button type="submit" class="btn btn-sm btn-success">
                <i class="bi bi-arrow-clockwise me-1"></i>{{ __('messages.renew_subscription') }}
            </button>
        </form>
        @endif
        <form method="POST" action="{{ route('subscriptions.destroy', $subscription) }}"
              onsubmit="return confirm('{{ __('messages.confirm_delete') }}')">
            @csrf @method('DELETE')
            <button type="submit" class="btn btn-sm btn-danger"><i class="bi bi-trash me-1"></i>{{ __('messages.delete') }}</button>
        </form>
    </div>
</div>

<div class="row g-3">
    <div class="col-md-6">
        <div class="card table-card">
            <div class="card-header bg-white border-0 py-3">
                <h6 class="mb-0 fw-semibold">{{ __('messages.subscription_details') }}</h6>
            </div>
            <div class="card-body">
                <table class="table table-sm">
                    <tr><th class="text-muted">{{ __('messages.member') }}</th>
                        <td><a href="{{ route('members.show', $subscription->member_id) }}" class="fw-semibold text-decoration-none">{{ $subscription->member?->name }}</a></td></tr>
                    <tr><th class="text-muted">{{ __('messages.plan') }}</th><td>{{ $subscription->plan?->name }}</td></tr>
                    <tr><th class="text-muted">{{ __('messages.start_date') }}</th><td>{{ $subscription->start_date->format('Y-m-d') }}</td></tr>
                    <tr><th class="text-muted">{{ __('messages.end_date') }}</th><td>{{ $subscription->end_date->format('Y-m-d') }}</td></tr>
                    <tr><th class="text-muted">{{ __('messages.days_remaining') }}</th>
                        <td>
                            @if($subscription->days_remaining > 0)
                                <span class="badge bg-success">{{ $subscription->days_remaining }}</span>
                            @else
                                <span class="badge badge-expired">0</span>
                            @endif
                        </td>
                    </tr>
                    <tr><th class="text-muted">{{ __('messages.amount_paid') }}</th><td class="fw-semibold text-success">{{ number_format($subscription->amount_paid) }}</td></tr>
                    <tr><th class="text-muted">{{ __('messages.status') }}</th>
                        <td>
                            @if($subscription->status === 'active' && !$subscription->is_expired)
                                <span class="badge badge-active">{{ __('messages.active') }}</span>
                            @elseif($subscription->status === 'pending')
                                <span class="badge badge-pending">{{ __('messages.pending') }}</span>
                            @else
                                <span class="badge badge-expired">{{ __('messages.expired') }}</span>
                            @endif
                        </td>
                    </tr>
                    @if($subscription->notes)
                    <tr><th class="text-muted">{{ __('messages.notes') }}</th><td>{{ $subscription->notes }}</td></tr>
                    @endif
                </table>
            </div>
        </div>
    </div>

    <div class="col-md-6">
        <div class="card table-card">
            <div class="card-header bg-white border-0 py-3">
                <h6 class="mb-0 fw-semibold">{{ __('messages.payment_history') }}</h6>
            </div>
            <div class="card-body p-0">
                <table class="table mb-0">
                    <thead>
                        <tr>
                            <th>{{ __('messages.amount') }}</th>
                            <th>{{ __('messages.payment_method') }}</th>
                            <th>{{ __('messages.payment_date') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($subscription->payments as $p)
                        <tr>
                            <td class="fw-semibold text-success">{{ number_format($p->amount) }}</td>
                            <td><span class="badge bg-light text-dark">{{ __('messages.' . $p->payment_method) }}</span></td>
                            <td class="small">{{ $p->payment_date }}</td>
                        </tr>
                        @empty
                        <tr><td colspan="3" class="text-center text-muted py-3">{{ __('messages.no_payments_member') }}</td></tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
@endsection
