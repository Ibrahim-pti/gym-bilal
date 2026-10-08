@extends('layouts.app')
@section('title', $trainer->name)
@section('page-title', __('messages.trainer_details'))

@section('content')
<div class="row">
    <div class="col-lg-8 mx-auto">
        <div class="card animate-in">
            <div class="card-body p-4">
                <div class="d-flex align-items-center gap-3 mb-4 pb-3 border-bottom">
                    @if($trainer->photo)
                    <img src="{{ asset('storage/' . $trainer->photo) }}" class="rounded-circle" width="80" height="80" style="object-fit:cover">
                    @else
                    <div class="rounded-circle bg-primary bg-opacity-10 d-flex align-items-center justify-content-center" style="width:80px;height:80px">
                        <i class="bi bi-person-badge-fill text-primary fs-2"></i>
                    </div>
                    @endif
                    <div>
                        <h4 class="fw-bold mb-1">{{ $trainer->name }}</h4>
                        <span class="badge {{ $trainer->status === 'active' ? 'badge-active' : 'badge-expired' }}" style="border-radius:6px">{{ __('messages.' . $trainer->status) }}</span>
                    </div>
                    <div class="ms-auto d-flex gap-2">
                        <a href="{{ route('trainers.edit', $trainer) }}" class="btn btn-sm btn-primary"><i class="bi bi-pencil me-1"></i>{{ __('messages.edit') }}</a>
                    </div>
                </div>

                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <div class="text-muted small mb-1">{{ __('messages.phone') }}</div>
                            <div class="fw-semibold">{{ $trainer->phone ?? '—' }}</div>
                        </div>
                        <div class="mb-3">
                            <div class="text-muted small mb-1">{{ __('messages.specialization') }}</div>
                            <div class="fw-semibold">{{ $trainer->specialization ?? '—' }}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <div class="text-muted small mb-1">{{ __('messages.salary') }}</div>
                            <div class="fw-bold text-success fs-5">{{ number_format($trainer->salary) }}</div>
                        </div>
                        <div class="mb-3">
                            <div class="text-muted small mb-1">{{ __('messages.hire_date') }}</div>
                            <div class="fw-semibold">{{ $trainer->hire_date?->format('Y-m-d') ?? '—' }}</div>
                        </div>
                    </div>
                </div>

                @if($trainer->notes)
                <div class="mt-3 p-3 rounded" style="background: var(--background)">
                    <div class="text-muted small mb-1">{{ __('messages.notes') }}</div>
                    <div>{{ $trainer->notes }}</div>
                </div>
                @endif
            </div>
        </div>
    </div>
</div>
@endsection
