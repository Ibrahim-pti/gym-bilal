@extends('layouts.app')
@section('title', __('messages.plans'))
@section('page-title', __('messages.plans'))

@section('content')
<div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="mb-0 fw-semibold">{{ __('messages.plans') }}</h5>
    <a href="{{ route('subscription-plans.create') }}" class="btn btn-primary">
        <i class="bi bi-plus-lg me-1"></i>{{ __('messages.add_plan') }}
    </a>
</div>

<div class="row g-3">
    @forelse($plans as $plan)
    <div class="col-md-6 col-xl-4">
        <div class="card table-card h-100">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <h6 class="fw-bold mb-0">{{ $plan->name }}</h6>
                    @if($plan->is_active)
                        <span class="badge badge-active">{{ __('messages.active') }}</span>
                    @else
                        <span class="badge badge-expired">{{ __('messages.no') }}</span>
                    @endif
                </div>
                <div class="fs-4 fw-bold text-primary mb-1">{{ number_format($plan->price) }}</div>
                <div class="text-muted small mb-1">
                    <i class="bi bi-calendar3 me-1"></i>{{ $plan->duration_days }} {{ __('messages.duration') }}
                    &nbsp;·&nbsp;
                    <span class="badge bg-light text-dark">{{ __('messages.' . $plan->type) }}</span>
                </div>
                @if($plan->description)
                <div class="text-muted small border-top pt-2 mt-2">{{ $plan->description }}</div>
                @endif
                <div class="mt-2 text-muted small">
                    <i class="bi bi-people me-1"></i>{{ $plan->subscriptions_count }} {{ __('messages.total_subscriptions') }}
                </div>
            </div>
            <div class="card-footer bg-white border-top-0 d-flex gap-2">
                <a href="{{ route('subscription-plans.show', $plan) }}" class="btn btn-sm btn-outline-primary flex-fill"><i class="bi bi-eye"></i></a>
                <a href="{{ route('subscription-plans.edit', $plan) }}" class="btn btn-sm btn-outline-warning flex-fill"><i class="bi bi-pencil"></i></a>
                <form method="POST" action="{{ route('subscription-plans.destroy', $plan) }}" class="flex-fill"
                      onsubmit="return confirm('{{ __('messages.confirm_delete') }}')">
                    @csrf @method('DELETE')
                    <button type="submit" class="btn btn-sm btn-outline-danger w-100"><i class="bi bi-trash"></i></button>
                </form>
            </div>
        </div>
    </div>
    @empty
    <div class="col-12">
        <div class="alert alert-info text-center">{{ __('messages.no_records') }}</div>
    </div>
    @endforelse
</div>
@endsection
