@extends('layouts.app')

@section('title', __('messages.add') . ' ' . __('messages.inventory'))

@push('styles')
<style>
    .form-container { max-width: 900px; margin: 0 auto; padding-bottom: 3rem; }
    .card-header-premium { background: linear-gradient(45deg, var(--accent), var(--accent-soft)); color: #fff; border: none; padding: 1.5rem; border-radius: 16px 16px 0 0 !important; }
    .card-premium { border: none; border-radius: 16px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
    .form-label { font-weight: 700; color: #475569; font-size: 0.88rem; margin-bottom: 0.5rem; }
    .form-control, .form-select { border: 1.5px solid #e2e8f0; padding: 0.75rem 1rem; border-radius: 10px; transition: all 0.2s; background: #f8fafc; }
    .form-control:focus { border-color: var(--accent); background: #fff; box-shadow: 0 0 0 4px rgba(108, 99, 255, 0.1); }
    .input-group-text { border: 1.5px solid #e2e8f0; background: #fff; border-radius: 10px; padding: 0 1rem; font-weight: 700; color: var(--accent); }
    .btn-save { background: var(--accent); color: #fff; padding: 0.8rem 2.5rem; border-radius: 12px; font-weight: 700; border: none; transition: all 0.2s; }
    .btn-save:hover { background: var(--accent-soft); transform: translateY(-2px); box-shadow: 0 8px 20px rgba(108, 99, 255, 0.3); }
    .section-title { font-size: 1rem; font-weight: 800; color: var(--accent); border-bottom: 2px solid var(--accent-light); padding-bottom: 0.5rem; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.5rem; }
</style>
@endpush

@section('content')
<div class="form-container animate-in">
    <div class="d-flex align-items-center mb-4">
        <a href="{{ route('products.index') }}" class="btn btn-light rounded-circle p-2 me-3 shadow-sm">
            <i class="bi bi-arrow-{{ app()->getLocale() === 'ku' ? 'right' : 'left' }}"></i>
        </a>
        <h4 class="mb-0 fw-bold">زیادکردنی بەرهەمی نوێ بۆ کۆگا</h4>
    </div>

    <form action="{{ route('products.store') }}" method="POST" id="productForm">
        @csrf
        <div class="card card-premium overflow-hidden">
            <div class="card-header-premium">
                <div class="d-flex align-items-center gap-3">
                    <div class="bg-white bg-opacity-20 p-3 rounded-3">
                        <i class="bi bi-box-seam-fill fs-3"></i>
                    </div>
                    <div>
                        <h5 class="mb-0 fw-bold">زانیارییەکانی بەرهەم</h5>
                        <small class="opacity-75">تکایە هەموو کێڵگە پێویستەکان (*) پڕ بکەرەوە</small>
                    </div>
                </div>
            </div>
            <div class="card-body p-4 p-md-5">
                <div class="row g-4">
                    <!-- Basic Info -->
                    <div class="col-12">
                        <div class="section-title"><i class="bi bi-info-circle"></i> زانیاری سەرەتایی</div>
                    </div>
                    
                    <div class="col-md-8">
                        <label class="form-label">ناوی بەرهەم*</label>
                        <input type="text" name="name" class="form-control @error('name') is-invalid @enderror" value="{{ old('name') }}" placeholder="بۆ نموونە: ئاوی ژیان" required>
                        @error('name') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>
                    
                    <div class="col-md-4">
                        <label class="form-label">هاوپۆل (Category)</label>
                        <input type="text" name="category" class="form-control @error('category') is-invalid @enderror" value="{{ old('category') }}" list="categories" placeholder="هەڵبژێرە یان بنووسە">
                        <datalist id="categories">
                            <option value="ئاو">
                            <option value="خواردنەوە">
                            <option value="پرۆتین">
                            <option value="تەواوکەری خۆراکی">
                            <option value="جلوبەرگ">
                        </datalist>
                        @error('category') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>

                    <!-- Inventory & Pricing -->
                    <div class="col-12 mt-5">
                        <div class="section-title"><i class="bi bi-currency-dollar"></i> نرخ و بڕی بەرهەم</div>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">نرخی فرۆشتن*</label>
                        <div class="input-group">
                            <input type="number" name="price" step="0.01" class="form-control @error('price') is-invalid @enderror" value="{{ old('price') }}" required>
                            <span class="input-group-text">{{ \App\Models\Setting::get('currency', 'IQD') }}</span>
                        </div>
                        @error('price') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">نرخی کڕین (Cost)</label>
                        <div class="input-group">
                            <input type="number" name="cost" step="0.01" class="form-control @error('cost') is-invalid @enderror" value="{{ old('cost') }}">
                            <span class="input-group-text">{{ \App\Models\Setting::get('currency', 'IQD') }}</span>
                        </div>
                        @error('cost') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">بڕی بەردەست (Stock)*</label>
                        <input type="number" name="stock_quantity" class="form-control @error('stock_quantity') is-invalid @enderror" value="{{ old('stock_quantity', 0) }}" required>
                        @error('stock_quantity') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">بەسەرچوون (Expiry Date)</label>
                        <input type="date" name="expiry_date" class="form-control @error('expiry_date') is-invalid @enderror" value="{{ old('expiry_date') }}">
                        @error('expiry_date') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>

                    <!-- Additional Details -->
                    <div class="col-12 mt-5">
                        <div class="section-title"><i class="bi bi-plus-square"></i> وردەکاری زیاتر</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">بارکۆد</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-upc-scan"></i></span>
                            <input type="text" name="barcode" class="form-control @error('barcode') is-invalid @enderror" value="{{ old('barcode') }}" placeholder="سکان بکە یان بنووسە">
                        </div>
                        @error('barcode') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">دۆخی بەرهەم</label>
                        <select name="status" class="form-select @error('status') is-invalid @enderror">
                            <option value="1" {{ old('status') == '1' ? 'selected' : '' }}>چالاک (Active)</option>
                            <option value="0" {{ old('status') == '0' ? 'selected' : '' }}>ناچالاک (Inactive)</option>
                        </select>
                        @error('status') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>

                    <div class="col-12">
                        <label class="form-label">وەسفی بەرهەم</label>
                        <textarea name="description" class="form-control @error('description') is-invalid @enderror" rows="4" placeholder="تێبینی دەربارەی بەرهەمەکە بنووسە...">{{ old('description') }}</textarea>
                        @error('description') <div class="invalid-feedback">{{ $message }}</div> @enderror
                    </div>
                </div>

                <div class="mt-5 pt-4 border-top d-flex justify-content-end gap-3">
                    <a href="{{ route('products.index') }}" class="btn btn-light px-4 py-2 fw-bold text-muted">پەشیمانبوونەوە</a>
                    <button type="submit" class="btn btn-save px-5">
                        <i class="bi bi-cloud-check me-2"></i> پاشەکەوتکردنی بەرهەم
                    </button>
                </div>
            </div>
        </div>
    </form>
</div>
@endsection
