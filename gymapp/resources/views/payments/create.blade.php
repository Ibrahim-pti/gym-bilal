@extends('layouts.app')
@section('title', __('messages.add_payment'))
@section('page-title', __('messages.add_payment'))

@section('content')
<div class="row justify-content-center">
<div class="col-lg-7">
<div class="card table-card">
    <div class="card-header bg-white border-0 py-3">
        <h6 class="mb-0 fw-semibold"><i class="bi bi-cash-coin text-success me-2"></i>{{ __('messages.add_payment') }}</h6>
    </div>
    <div class="card-body">
        @if($errors->any())
        <div class="alert alert-danger"><ul class="mb-0">@foreach($errors->all() as $e)<li>{{ $e }}</li>@endforeach</ul></div>
        @endif

        <form method="POST" action="{{ route('payments.store') }}">
            @csrf
            <div class="row g-3">
                <div class="col-12">
                    <label class="form-label fw-semibold">{{ __('messages.member') }} <span class="text-danger">*</span></label>
                    <select name="member_id" class="form-select @error('member_id') is-invalid @enderror"
                            required id="memberSelect">
                        <option value="">— {{ __('messages.member') }} —</option>
                        @foreach($members as $m)
                        <option value="{{ $m->id }}" {{ old('member_id', $selectedMember?->id) == $m->id ? 'selected' : '' }}>
                            {{ $m->name }} {{ $m->phone ? "($m->phone)" : '' }}
                        </option>
                        @endforeach
                    </select>
                    @error('member_id')<div class="invalid-feedback">{{ $message }}</div>@enderror
                </div>

                @if($selectedMember && $selectedMember->subscriptions->isNotEmpty())
                <div class="col-12">
                    <label class="form-label fw-semibold">{{ __('messages.subscription') }}</label>
                    <select name="subscription_id" class="form-select">
                        <option value="">— {{ __('messages.all') }} —</option>
                        @foreach($selectedMember->subscriptions as $sub)
                        <option value="{{ $sub->id }}" {{ old('subscription_id') == $sub->id ? 'selected' : '' }}>
                            {{ $sub->plan?->name }} ({{ $sub->start_date->format('Y-m-d') }} → {{ $sub->end_date->format('Y-m-d') }})
                        </option>
                        @endforeach
                    </select>
                </div>
                @else
                <input type="hidden" name="subscription_id" value="">
                @endif

                <div class="col-md-6">
                    <label class="form-label fw-semibold">{{ __('messages.amount') }} <span class="text-danger">*</span></label>
                    <input type="number" name="amount" class="form-control @error('amount') is-invalid @enderror"
                           value="{{ old('amount') }}" min="0.01" step="0.01" required>
                    @error('amount')<div class="invalid-feedback">{{ $message }}</div>@enderror
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">{{ __('messages.payment_method') }}</label>
                    <select name="payment_method" class="form-select">
                        <option value="cash"     {{ old('payment_method','cash') === 'cash'     ? 'selected' : '' }}>{{ __('messages.cash') }}</option>
                        <option value="card"     {{ old('payment_method') === 'card'     ? 'selected' : '' }}>{{ __('messages.card') }}</option>
                        <option value="transfer" {{ old('payment_method') === 'transfer' ? 'selected' : '' }}>{{ __('messages.transfer') }}</option>
                    </select>
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold">{{ __('messages.payment_date') }} <span class="text-danger">*</span></label>
                    <input type="date" name="payment_date" class="form-control"
                           value="{{ old('payment_date', date('Y-m-d')) }}" required>
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold">{{ __('messages.notes') }}</label>
                    <textarea name="notes" class="form-control" rows="2">{{ old('notes') }}</textarea>
                </div>
            </div>
            <div class="mt-4 d-flex gap-2">
                <button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i>{{ __('messages.save') }}</button>
                <a href="{{ route('payments.index') }}" class="btn btn-outline-secondary">{{ __('messages.cancel') }}</a>
            </div>
        </form>
    </div>
</div>
</div>
</div>
@endsection
