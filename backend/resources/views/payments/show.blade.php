@extends('layouts.app')
@section('title', __('messages.payment_details'))
@section('page-title', __('messages.payment_details'))

@section('content')
<div class="d-flex justify-content-between align-items-center mb-3">
    <a href="{{ route('payments.index') }}" class="btn btn-sm btn-outline-secondary">
        <i class="bi bi-arrow-left me-1"></i>{{ __('messages.back') }}
    </a>
    <form method="POST" action="{{ route('payments.destroy', $payment) }}"
          onsubmit="return confirm('{{ __('messages.confirm_delete') }}')">
        @csrf @method('DELETE')
        <button type="submit" class="btn btn-sm btn-danger"><i class="bi bi-trash me-1"></i>{{ __('messages.delete') }}</button>
    </form>
</div>

<div class="row justify-content-center">
<div class="col-md-6">
<div class="card table-card">
    <div class="card-header bg-white border-0 py-3 d-flex justify-content-between align-items-center">
        <h6 class="mb-0 fw-semibold"><i class="bi bi-receipt text-success me-2"></i>{{ __('messages.payment_details') }}</h6>
        <span class="badge bg-success fs-6">{{ number_format($payment->amount) }}</span>
    </div>
    <div class="card-body">
        <table class="table table-sm">
            <tr><th class="text-muted">{{ __('messages.receipt_number') }}</th><td class="fw-mono">{{ $payment->receipt_number }}</td></tr>
            <tr><th class="text-muted">{{ __('messages.member') }}</th>
                <td><a href="{{ route('members.show', $payment->member_id) }}" class="fw-semibold text-decoration-none">{{ $payment->member?->name }}</a></td></tr>
            @if($payment->subscription)
            <tr><th class="text-muted">{{ __('messages.plan') }}</th><td>{{ $payment->subscription->plan?->name }}</td></tr>
            <tr><th class="text-muted">{{ __('messages.subscription') }}</th>
                <td>{{ $payment->subscription->start_date->format('Y-m-d') }} → {{ $payment->subscription->end_date->format('Y-m-d') }}</td></tr>
            @endif
            <tr><th class="text-muted">{{ __('messages.amount') }}</th><td class="fw-bold text-success fs-5">{{ number_format($payment->amount) }}</td></tr>
            <tr><th class="text-muted">{{ __('messages.payment_method') }}</th>
                <td><span class="badge bg-light text-dark">{{ __('messages.' . $payment->payment_method) }}</span></td></tr>
            <tr><th class="text-muted">{{ __('messages.payment_date') }}</th><td>{{ $payment->payment_date }}</td></tr>
            @if($payment->notes)
            <tr><th class="text-muted">{{ __('messages.notes') }}</th><td>{{ $payment->notes }}</td></tr>
            @endif
        </table>
    </div>
</div>
</div>
</div>
@endsection
