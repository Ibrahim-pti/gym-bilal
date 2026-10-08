@extends('layouts.app')
@section('title', __('messages.payments'))
@section('page-title', __('messages.payments'))

@section('content')
<div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="mb-0 fw-semibold">{{ __('messages.payments') }}</h5>
    <a href="{{ route('payments.create') }}" class="btn btn-primary">
        <i class="bi bi-plus-lg me-1"></i>{{ __('messages.add_payment') }}
    </a>
</div>

{{-- Filters --}}
<div class="card table-card mb-3">
    <div class="card-body py-2">
        <form method="GET" class="row g-2 align-items-end">
            <div class="col-md-3">
                <input type="text" name="search" class="form-control form-control-sm"
                       placeholder="{{ __('messages.search') }}..."
                       value="{{ request('search') }}">
            </div>
            <div class="col-md-2">
                <select name="payment_method" class="form-select form-select-sm">
                    <option value="">{{ __('messages.all') }}</option>
                    <option value="cash"     {{ request('payment_method')=='cash'     ? 'selected' : '' }}>{{ __('messages.cash') }}</option>
                    <option value="card"     {{ request('payment_method')=='card'     ? 'selected' : '' }}>{{ __('messages.card') }}</option>
                    <option value="transfer" {{ request('payment_method')=='transfer' ? 'selected' : '' }}>{{ __('messages.transfer') }}</option>
                </select>
            </div>
            <div class="col-md-2">
                <input type="date" name="from" class="form-control form-control-sm"
                       value="{{ request('from') }}" placeholder="{{ __('messages.from_date') }}">
            </div>
            <div class="col-md-2">
                <input type="date" name="to" class="form-control form-control-sm"
                       value="{{ request('to') }}" placeholder="{{ __('messages.to_date') }}">
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-sm btn-primary"><i class="bi bi-search me-1"></i>{{ __('messages.filter') }}</button>
                <a href="{{ route('payments.index') }}" class="btn btn-sm btn-outline-secondary ms-1">{{ __('messages.reset') }}</a>
            </div>
        </form>
    </div>
</div>

<div class="card table-card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table mb-0">
                <thead>
                    <tr>
                        <th>{{ __('messages.receipt_number') }}</th>
                        <th>{{ __('messages.member') }}</th>
                        <th>{{ __('messages.plan') }}</th>
                        <th>{{ __('messages.amount') }}</th>
                        <th>{{ __('messages.payment_method') }}</th>
                        <th>{{ __('messages.payment_date') }}</th>
                        <th>{{ __('messages.actions') }}</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($payments as $p)
                    <tr>
                        <td class="text-muted small">{{ $p->receipt_number }}</td>
                        <td>
                            <a href="{{ route('members.show', $p->member_id) }}" class="fw-semibold text-decoration-none">
                                {{ $p->member?->name }}
                            </a>
                        </td>
                        <td class="small text-muted">{{ $p->subscription?->plan?->name ?: '—' }}</td>
                        <td class="fw-semibold text-success">{{ number_format($p->amount) }}</td>
                        <td><span class="badge bg-light text-dark">{{ __('messages.' . $p->payment_method) }}</span></td>
                        <td class="small">{{ $p->payment_date }}</td>
                        <td>
                            <a href="{{ route('payments.show', $p) }}" class="btn btn-sm btn-outline-primary"><i class="bi bi-eye"></i></a>
                            <form method="POST" action="{{ route('payments.destroy', $p) }}" class="d-inline"
                                  onsubmit="return confirm('{{ __('messages.confirm_delete') }}')">
                                @csrf @method('DELETE')
                                <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                            </form>
                        </td>
                    </tr>
                    @empty
                    <tr><td colspan="7" class="text-center text-muted py-4">{{ __('messages.no_records') }}</td></tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
    @if($payments->hasPages())
    <div class="card-footer bg-white d-flex justify-content-between align-items-center">
        <small class="text-muted">{{ $payments->total() }} {{ __('messages.payments') }}</small>
        {{ $payments->links() }}
    </div>
    @endif
</div>
@endsection
