@extends('layouts.app')
@section('title', __('messages.edit_equipment'))
@section('page-title', __('messages.edit_equipment'))

@section('content')
<div class="row">
    <div class="col-lg-8 mx-auto">
        <div class="card animate-in">
            <div class="card-body p-4">
                <form action="{{ route('equipment.update', $equipment) }}" method="POST">
                    @csrf @method('PUT')

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">{{ __('messages.equipment_name') }} <span class="text-danger">*</span></label>
                            <input type="text" name="name" class="form-control @error('name') is-invalid @enderror" value="{{ old('name', $equipment->name) }}" required>
                            @error('name') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">{{ __('messages.category') }}</label>
                            <select name="category" class="form-select @error('category') is-invalid @enderror">
                                <option value="">—</option>
                                @foreach(['cardio','weights','machines','accessories','other'] as $cat)
                                <option value="{{ $cat }}" {{ old('category', $equipment->category) === $cat ? 'selected' : '' }}>{{ __('messages.' . $cat) }}</option>
                                @endforeach
                            </select>
                            @error('category') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label class="form-label">{{ __('messages.quantity') }} <span class="text-danger">*</span></label>
                            <input type="number" name="quantity" class="form-control @error('quantity') is-invalid @enderror" value="{{ old('quantity', $equipment->quantity) }}" min="1" required>
                            @error('quantity') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">{{ __('messages.purchase_price') }}</label>
                            <input type="number" step="0.01" name="purchase_price" class="form-control @error('purchase_price') is-invalid @enderror" value="{{ old('purchase_price', $equipment->purchase_price) }}">
                            @error('purchase_price') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">{{ __('messages.purchase_date') }}</label>
                            <input type="date" name="purchase_date" class="form-control @error('purchase_date') is-invalid @enderror" value="{{ old('purchase_date', $equipment->purchase_date?->format('Y-m-d')) }}">
                            @error('purchase_date') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label class="form-label">{{ __('messages.condition') }} <span class="text-danger">*</span></label>
                            <select name="condition" class="form-select @error('condition') is-invalid @enderror" required>
                                @foreach(['new','good','fair','needs_repair','broken'] as $cond)
                                <option value="{{ $cond }}" {{ old('condition', $equipment->condition) === $cond ? 'selected' : '' }}>{{ __('messages.condition_' . $cond) }}</option>
                                @endforeach
                            </select>
                            @error('condition') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">{{ __('messages.last_maintenance') }}</label>
                            <input type="date" name="last_maintenance" class="form-control @error('last_maintenance') is-invalid @enderror" value="{{ old('last_maintenance', $equipment->last_maintenance?->format('Y-m-d')) }}">
                            @error('last_maintenance') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">{{ __('messages.next_maintenance') }}</label>
                            <input type="date" name="next_maintenance" class="form-control @error('next_maintenance') is-invalid @enderror" value="{{ old('next_maintenance', $equipment->next_maintenance?->format('Y-m-d')) }}">
                            @error('next_maintenance') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">{{ __('messages.notes') }}</label>
                        <textarea name="notes" class="form-control @error('notes') is-invalid @enderror" rows="3">{{ old('notes', $equipment->notes) }}</textarea>
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
