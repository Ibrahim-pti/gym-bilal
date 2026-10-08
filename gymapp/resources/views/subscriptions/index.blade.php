@extends('layouts.app')
@section('title', __('messages.subscriptions'))
@section('page-title', __('messages.subscriptions'))

@section('content')
<div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="mb-0 fw-semibold">{{ __('messages.subscriptions') }}</h5>
    <a href="{{ route('subscriptions.create') }}" class="btn btn-primary">
        <i class="bi bi-plus-lg me-1"></i>{{ __('messages.add_subscription_title') }}
    </a>
</div>

<div class="card table-card mb-3">
    <div class="card-body py-2">
        <form method="GET" class="row g-2 align-items-end">
            <div class="col-md-3">
                <select name="status" class="form-select form-select-sm">
                    <option value="">{{ __('messages.all') }}</option>
                    <option value="active"  {{ request('status')=='active'  ? 'selected' : '' }}>{{ __('messages.active') }}</option>
                    <option value="expired" {{ request('status')=='expired' ? 'selected' : '' }}>{{ __('messages.expired') }}</option>
                    <option value="pending" {{ request('status')=='pending' ? 'selected' : '' }}>{{ __('messages.pending') }}</option>
                </select>
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-sm btn-primary"><i class="bi bi-search me-1"></i>{{ __('messages.filter') }}</button>
                <a href="{{ route('subscriptions.index') }}" class="btn btn-sm btn-outline-secondary ms-1">{{ __('messages.reset') }}</a>
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
                        <th>#</th>
                        <th>{{ __('messages.member') }}</th>
                        <th>{{ __('messages.plan') }}</th>
                        <th>{{ __('messages.start_date') }}</th>
                        <th>{{ __('messages.end_date') }}</th>
                        <th>{{ __('messages.days_remaining') }}</th>
                        <th>{{ __('messages.amount_paid') }}</th>
                        <th>{{ __('messages.status') }}</th>
                        <th>{{ __('messages.actions') }}</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($subscriptions as $sub)
                    <tr>
                        <td class="text-muted small">{{ $sub->id }}</td>
                        <td>
                            <a href="{{ route('members.show', $sub->member_id) }}" class="fw-semibold text-decoration-none">
                                {{ $sub->member?->name }}
                            </a>
                        </td>
                        <td>{{ $sub->plan?->name }}</td>
                        <td class="small">{{ $sub->start_date->format('Y-m-d') }}</td>
                        <td class="small">{{ $sub->end_date->format('Y-m-d') }}</td>
                        <td>
                            @if($sub->days_remaining > 0)
                                <span class="badge {{ $sub->days_remaining <= 7 ? 'bg-warning text-dark' : 'bg-success' }}">
                                    {{ $sub->days_remaining }}
                                </span>
                            @else
                                <span class="text-muted">—</span>
                            @endif
                        </td>
                        <td>{{ number_format($sub->amount_paid) }}</td>
                        <td>
                            @if($sub->status === 'active' && !$sub->is_expired)
                                <span class="badge badge-active">{{ __('messages.active') }}</span>
                            @elseif($sub->status === 'pending')
                                <span class="badge badge-pending">{{ __('messages.pending') }}</span>
                            @else
                                <span class="badge badge-expired">{{ __('messages.expired') }}</span>
                            @endif
                        </td>
                        <td>
                            <a href="{{ route('subscriptions.show', $sub) }}" class="btn btn-sm btn-outline-primary"><i class="bi bi-eye"></i></a>
                            <a href="{{ route('subscriptions.edit', $sub) }}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-pencil"></i></a>
                            <form method="POST" action="{{ route('subscriptions.destroy', $sub) }}" class="d-inline"
                                  onsubmit="return confirm('{{ __('messages.confirm_delete') }}')">
                                @csrf @method('DELETE')
                                <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                            </form>
                        </td>
                    </tr>
                    @empty
                    <tr><td colspan="9" class="text-center text-muted py-4">{{ __('messages.no_records') }}</td></tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
    @if($subscriptions->hasPages())
    <div class="card-footer bg-white d-flex justify-content-between align-items-center">
        <small class="text-muted">{{ $subscriptions->total() }} {{ __('messages.subscriptions') }}</small>
        {{ $subscriptions->links() }}
    </div>
    @endif
</div>
@endsection
