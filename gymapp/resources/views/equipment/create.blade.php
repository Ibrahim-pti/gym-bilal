@extends('layouts.app')
@section('title', __('messages.add_equipment'))
@section('page-title', __('messages.add_equipment'))

@section('content')
<div class="row">
    <div class="col-lg-8 mx-auto">
        <div class="card animate-in">
            <div class="card-body p-4">
                <form action="{{ route('equipment.store') }}" method="POST">
                    @csrf

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">{{ __('messages.equipment_name') }} <span class="text-danger">*</span></label>
                            <input type="text" name="name" class="form-control @error('name') is-invalid @enderror" value="{{ old('name') }}" required>
                            @error('name') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">{{ __('messages.category') }}</label>
                            <select name="category" class="form-select @error('category') is-invalid @enderror">
                                <option value="">—</option>
                                <option value="cardio" {{ old('category') === 'cardio' ? 'selected' : '' }}>{{ __('messages.cardio') }}</option>
                                <option value="weights" {{ old('category') === 'weights' ? 'selected' : '' }}>{{ __('messages.weights') }}</option>
                                <option value="machines" {{ old('category') === 'machines' ? 'selected' : '' }}>{{ __('messages.machines') }}</option>
                                <option value="accessories" {{ old('category') === 'accessories' ? 'selected' : '' }}>{{ __('messages.accessories') }}</option>
                                <option value="other" {{ old('category') === 'other' ? 'selected' : '' }}>{{ __('messages.other') }}</option>
                            </select>
                            @error('category') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label class="form-label">{{ __('messages.quantity') }} <span class="text-danger">*</span></label>
                            <input type="number" name="quantity" class="form-control @error('quantity') is-invalid @enderror" value="{{ old('quantity', 1) }}" min="1" required>
                            @error('quantity') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">{{ __('messages.purchase_price') }}</label>
                            <input type="number" step="0.01" name="purchase_price" class="form-control @error('purchase_price') is-invalid @enderror" value="{{ old('purchase_price', 0) }}">
                            @error('purchase_price') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">{{ __('messages.purchase_date') }}</label>
                            <input type="date" name="purchase_date" class="form-control @error('purchase_date') is-invalid @enderror" value="{{ old('purchase_date') }}">
                            @error('purchase_date') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label class="form-label">{{ __('messages.condition') }} <span class="text-danger">*</span></label>
                            <select name="condition" class="form-select @error('condition') is-invalid @enderror" required>
                                <option value="new" {{ old('condition') === 'new' ? 'selected' : '' }}>{{ __('messages.condition_new') }}</option>
                                <option value="good" {{ old('condition', 'good') === 'good' ? 'selected' : '' }}>{{ __('messages.condition_good') }}</option>
                                <option value="fair" {{ old('condition') === 'fair' ? 'selected' : '' }}>{{ __('messages.condition_fair') }}</option>
                                <option value="needs_repair" {{ old('condition') === 'needs_repair' ? 'selected' : '' }}>{{ __('messages.condition_needs_repair') }}</option>
                                <option value="broken" {{ old('condition') === 'broken' ? 'selected' : '' }}>{{ __('messages.condition_broken') }}</option>
                            </select>
                            @error('condition') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">{{ __('messages.last_maintenance') }}</label>
                            <input type="date" name="last_maintenance" class="form-control @error('last_maintenance') is-invalid @enderror" value="{{ old('last_maintenance') }}">
                            @error('last_maintenance') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">{{ __('messages.next_maintenance') }}</label>
                            <input type="date" name="next_maintenance" class="form-control @error('next_maintenance') is-invalid @enderror" value="{{ old('next_maintenance') }}">
                            @error('next_maintenance') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">{{ __('messages.notes') }}</label>
                        <textarea name="notes" class="form-control @error('notes') is-invalid @enderror" rows="3">{{ old('notes') }}</textarea>
                        @error('notes') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <a href="{{ route('equipment.index') }}" class="btn btn-light">{{ __('messages.cancel') }}</a>
                        <button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i>{{ __('messages.save') }}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection
