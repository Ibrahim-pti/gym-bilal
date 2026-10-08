@extends('layouts.app')

@section('title', __('messages.edit_expense', ['default' => 'Edit Expense']))
@section('page-title', __('messages.edit_expense', ['default' => 'Edit Expense']))

@section('content')
<div class="row">
    <div class="col-md-8 mx-auto">
        <div class="card table-card">
            <div class="card-body p-4">
                <form action="{{ route('expenses.update', $expense) }}" method="POST">
                    @csrf
                    @method('PUT')
                    
                    <div class="mb-3">
                        <label class="form-label">{{ __('messages.title', ['default' => 'Title']) }} <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control @error('title') is-invalid @enderror" value="{{ old('title', $expense->title) }}" required>
                        @error('title') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">{{ __('messages.amount', ['default' => 'Amount']) }} <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text">$</span>
                                <input type="number" step="0.01" name="amount" class="form-control @error('amount') is-invalid @enderror" value="{{ old('amount', $expense->amount) }}" required>
                                @error('amount') <div class="invalid-feedback">{{ $message }}</div> @enderror
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">{{ __('messages.date', ['default' => 'Date']) }} <span class="text-danger">*</span></label>
                            <input type="date" name="date" class="form-control @error('date') is-invalid @enderror" value="{{ old('date', $expense->date) }}" required>
                            @error('date') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label">{{ __('messages.description', ['default' => 'Description']) }}</label>
                        <textarea name="description" class="form-control @error('description') is-invalid @enderror" rows="4">{{ old('description', $expense->description) }}</textarea>
                        @error('description') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>
                    
                    <div class="d-flex justify-content-end gap-2">
                        <a href="{{ route('expenses.index') }}" class="btn btn-light">{{ __('messages.cancel', ['default' => 'Cancel']) }}</a>
                        <button type="submit" class="btn btn-primary">{{ __('messages.update', ['default' => 'Update Expense']) }}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection
