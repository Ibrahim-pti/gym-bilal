@extends('layouts.app')

@section('title', __('messages.edit') . ' ' . __('messages.inventory'))
@section('page-title', __('messages.inventory'))

@section('content')
<div class="animate-in" style="max-width: 800px; margin: 0 auto;">
    <div class="d-flex align-items-center mb-4">
        <a href="{{ route('products.index') }}" class="btn btn-light me-3">
            <i class="bi bi-arrow-{{ app()->getLocale() === 'ku' ? 'right' : 'left' }}"></i>
        </a>
        <h4 class="mb-0 fw-bold">{{ __('messages.edit') }} {{ __('messages.inventory') }}</h4>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-body p-4">
            <form action="{{ route('products.update', $product) }}" method="POST">
                @csrf
                @method('PUT')
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">{{ __('messages.title') }}*</label>
                        <input type="text" name="name" class="form-control @error('name') is-invalid @enderror" value="{{ old('name', $product->name) }}" required>
                        @error('name') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">{{ __('messages.category') }}</label>
                        <input type="text" name="category" class="form-control @error('category') is-invalid @enderror" value="{{ old('category', $product->category) }}">
                        @error('category') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">{{ __('messages.price') }}*</label>
                        <div class="input-group">
                            <input type="number" name="price" step="0.01" class="form-control @error('price') is-invalid @enderror" value="{{ old('price', $product->price) }}" required>
                            <span class="input-group-text">{{ \App\Models\Setting::get('currency', 'IQD') }}</span>
                        </div>
                        @error('price') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">{{ __('messages.purchase_price') }} (Cost)</label>
                        <div class="input-group">
                            <input type="number" name="cost" step="0.01" class="form-control @error('cost') is-invalid @enderror" value="{{ old('cost', $product->cost) }}">
                            <span class="input-group-text">{{ \App\Models\Setting::get('currency', 'IQD') }}</span>
                        </div>
                        @error('cost') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">{{ __('messages.quantity') }}*</label>
                        <input type="number" name="stock_quantity" class="form-control @error('stock_quantity') is-invalid @enderror" value="{{ old('stock_quantity', $product->stock_quantity) }}" required>
                        @error('stock_quantity') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">{{ __('messages.barcode') }}</label>
                        <input type="text" name="barcode" class="form-control @error('barcode') is-invalid @enderror" value="{{ old('barcode', $product->barcode) }}">
                        @error('barcode') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>
                    <div class="col-12">
                        <label class="form-label">{{ __('messages.description') }}</label>
                        <textarea name="description" class="form-control @error('description') is-invalid @enderror" rows="3">{{ old('description', $product->description) }}</textarea>
                        @error('description') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">{{ __('messages.status') }}</label>
                        <select name="status" class="form-select @error('status') is-invalid @enderror">
                            <option value="1" {{ old('status', $product->status) == '1' ? 'selected' : '' }}>{{ __('messages.active') }}</option>
                            <option value="0" {{ old('status', $product->status) == '0' ? 'selected' : '' }}>{{ __('messages.inactive') }}</option>
                        </select>
                        @error('status') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>
                </div>

                <div class="mt-4 pt-3 border-top d-flex justify-content-end gap-2">
                    <a href="{{ route('products.index') }}" class="btn btn-light px-4">{{ __('messages.cancel') }}</a>
                    <button type="submit" class="btn btn-primary px-4">{{ __('messages.update') }}</button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection
