@extends('layouts.app')
@section('title', __('messages.add_subscription_title'))
@section('page-title', __('messages.add_subscription_title'))

@section('content')
<div class="row justify-content-center">
<div class="col-lg-7">
<div class="card table-card">
    <div class="card-header bg-white border-0 py-3">
        <h6 class="mb-0 fw-semibold"><i class="bi bi-plus-circle-fill text-primary me-2"></i>{{ __('messages.add_subscription_title') }}</h6>
    </div>
    <div class="card-body">
        @if($errors->any())
        <div class="alert alert-danger"><ul class="mb-0">@foreach($errors->all() as $e)<li>{{ $e }}</li>@endforeach</ul></div>
        @endif

        <form method="POST" action="{{ route('subscriptions.store') }}">
            @csrf
            <div class="row g-3">
                <div class="col-12">
                    <label class="form-label fw-semibold">{{ __('messages.member') }} <span class="text-danger">*</span></label>
                    <select name="member_id" class="form-select @error('member_id') is-invalid @enderror" required>
                        <option value="">— {{ __('messages.member') }} —</option>
                        @foreach($members as $m)
                        <option value="{{ $m->id }}"
                            {{ old('member_id', $selectedMember?->id) == $m->id ? 'selected' : '' }}>
                            {{ $m->name }} {{ $m->phone ? "($m->phone)" : '' }}
                        </option>
                        @endforeach
                    </select>
                    @error('member_id')<div class="invalid-feedback">{{ $message }}</div>@enderror
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold">{{ __('messages.plan') }} <span class="text-danger">*</span></label>
                    <select name="subscription_plan_id" class="form-select @error('subscription_plan_id') is-invalid @enderror" required id="planSelect">
                        <option value="">— {{ __('messages.plan') }} —</option>
                        @foreach($plans as $plan)
                        <option value="{{ $plan->id }}" data-price="{{ $plan->price }}"
                            {{ old('subscription_plan_id') == $plan->id ? 'selected' : '' }}>
                            {{ $plan->name }} — {{ number_format($plan->price) }} ({{ $plan->duration_days }} {{ __('messages.duration') }})
                        </option>
                        @endforeach
                    </select>
                    @error('subscription_plan_id')<div class="invalid-feedback">{{ $message }}</div>@enderror
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">{{ __('messages.start_date') }} <span class="text-danger">*</span></label>
                    <input type="date" name="start_date" class="form-control @error('start_date') is-invalid @enderror"
                           value="{{ old('start_date', date('Y-m-d')) }}" required>
                    @error('start_date')<div class="invalid-feedback">{{ $message }}</div>@enderror
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">{{ __('messages.amount_paid') }} <span class="text-danger">*</span></label>
                    <input type="number" name="amount_paid" id="amountPaid" class="form-control @error('amount_paid') is-invalid @enderror"
                           value="{{ old('amount_paid', 0) }}" min="0" step="0.01" required>
                    @error('amount_paid')<div class="invalid-feedback">{{ $message }}</div>@enderror
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold">{{ __('messages.notes') }}</label>
                    <textarea name="notes" class="form-control" rows="2">{{ old('notes') }}</textarea>
                </div>
            </div>
            <div class="mt-4 d-flex gap-2">
                <button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i>{{ __('messages.save') }}</button>
                <a href="{{ route('subscriptions.index') }}" class="btn btn-outline-secondary">{{ __('messages.cancel') }}</a>
            </div>
        </form>
    </div>
</div>
</div>
</div>
@endsection

@push('scripts')
<script>
document.getElementById('planSelect').addEventListener('change', function () {
    const opt = this.selectedOptions[0];
    if (opt && opt.dataset.price) {
        document.getElementById('amountPaid').value = opt.dataset.price;
    }
});
</script>
@endpush
