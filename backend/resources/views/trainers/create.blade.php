@extends('layouts.app')
@section('title', __('messages.add_trainer'))
@section('page-title', __('messages.add_trainer'))

@section('content')
<div class="row">
    <div class="col-lg-8 mx-auto">
        <div class="card animate-in">
            <div class="card-body p-4">
                <form action="{{ route('trainers.store') }}" method="POST" enctype="multipart/form-data">
                    @csrf

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">{{ __('messages.trainer_name') }} <span class="text-danger">*</span></label>
                            <input type="text" name="name" class="form-control @error('name') is-invalid @enderror" value="{{ old('name') }}" required>
                            @error('name') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">{{ __('messages.phone') }}</label>
                            <input type="text" name="phone" class="form-control @error('phone') is-invalid @enderror" value="{{ old('phone') }}">
                            @error('phone') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">{{ __('messages.specialization') }}</label>
                            <input type="text" name="specialization" class="form-control @error('specialization') is-invalid @enderror" value="{{ old('specialization') }}" placeholder="{{ __('messages.specialization_placeholder') }}">
                            @error('specialization') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">{{ __('messages.salary') }}</label>
                            <input type="number" step="0.01" name="salary" class="form-control @error('salary') is-invalid @enderror" value="{{ old('salary', 0) }}">
                            @error('salary') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">{{ __('messages.hire_date') }}</label>
                            <input type="date" name="hire_date" class="form-control @error('hire_date') is-invalid @enderror" value="{{ old('hire_date', date('Y-m-d')) }}">
                            @error('hire_date') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">{{ __('messages.status') }} <span class="text-danger">*</span></label>
                            <select name="status" class="form-select @error('status') is-invalid @enderror" required>
                                <option value="active" {{ old('status') === 'active' ? 'selected' : '' }}>{{ __('messages.active') }}</option>
                                <option value="inactive" {{ old('status') === 'inactive' ? 'selected' : '' }}>{{ __('messages.inactive') }}</option>
                            </select>
                            @error('status') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">{{ __('messages.photo') }}</label>
                        <input type="file" name="photo" class="form-control @error('photo') is-invalid @enderror" accept="image/*">
                        @error('photo') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>

                    <div class="mb-4">
                        <label class="form-label">{{ __('messages.notes') }}</label>
                        <textarea name="notes" class="form-control @error('notes') is-invalid @enderror" rows="3">{{ old('notes') }}</textarea>
                        @error('notes') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <a href="{{ route('trainers.index') }}" class="btn btn-light">{{ __('messages.cancel') }}</a>
                        <button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i>{{ __('messages.save') }}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection
