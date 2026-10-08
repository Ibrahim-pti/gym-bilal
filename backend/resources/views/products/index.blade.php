@extends('layouts.app')

@section('title', __('messages.inventory'))

@push('styles')
<style>
    .inventory-card { border: none; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.04); background: #fff; overflow: hidden; }
    .search-area { background: #f8fafc; border-bottom: 1px solid #f1f5f9; padding: 1.5rem; }
    .product-row { transition: all 0.2s; border-bottom: 1px solid #f8fafc; }
    .product-row:hover { background: #fcfdfe; transform: scale(1.002); }
    .stock-badge { padding: 0.5rem 1rem; border-radius: 12px; font-weight: 700; font-size: 0.8rem; }
    .low-stock { background: #fff1f2; color: #e11d48; }
    .good-stock { background: #f0fdf4; color: #16a34a; }
    .price-text { font-weight: 800; color: var(--accent); }
    .btn-add-premium { background: var(--accent); color: #fff; border-radius: 12px; padding: 0.75rem 1.5rem; font-weight: 700; border: none; transition: all 0.2s; }
    .btn-add-premium:hover { background: var(--accent-soft); transform: translateY(-2px); box-shadow: 0 8px 20px rgba(108, 99, 255, 0.2); color: #fff; }
</style>
@endpush

@section('content')
<div class="animate-in">
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <h3 class="fw-bold mb-1">کۆگا و بەرهەمەکان</h3>
            <p class="text-muted small mb-0">بەڕێوەبردنی بەرهەمەکان، نرخەکان، و بڕی بەردەست لە کۆگادا.</p>
        </div>
        <a href="{{ route('products.create') }}" class="btn btn-add-premium">
            <i class="bi bi-plus-lg me-2"></i> زیادکردنی بەرهەم
        </a>
    </div>

    <div class="inventory-card">
        <div class="search-area">
            <form action="{{ route('products.index') }}" method="GET" class="row g-3">
                <div class="col-md-5">
                    <div class="input-group bg-white rounded-3 shadow-sm overflow-hidden border">
                        <span class="input-group-text border-0 bg-white"><i class="bi bi-search text-muted"></i></span>
                        <input type="text" name="search" class="form-control border-0 py-2" placeholder="بگەڕێ بۆ ناو، بارکۆد، یان هاوپۆل..." value="{{ request('search') }}">
                    </div>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-light w-100 border fw-bold">فلتەرکردن</button>
                </div>
            </form>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light">
                    <tr>
                        <th class="ps-4 py-3 text-muted text-uppercase small fw-bold">ناوی بەرهەم</th>
                        <th class="py-3 text-muted text-uppercase small fw-bold">هاوپۆل</th>
                        <th class="py-3 text-muted text-uppercase small fw-bold">نرخ</th>
                        <th class="py-3 text-muted text-uppercase small fw-bold">بڕی ماوە</th>
                        <th class="py-3 text-muted text-uppercase small fw-bold">بەسەرچوون</th>
                        <th class="py-3 text-muted text-uppercase small fw-bold">بارکۆد</th>
                        <th class="py-3 text-muted text-uppercase small fw-bold">دۆخ</th>
                        <th class="text-end pe-4 py-3 text-muted text-uppercase small fw-bold">کردارەکان</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($products as $product)
                    <tr class="product-row">
                        <td class="ps-4">
                            <div class="d-flex align-items-center gap-3">
                                <div class="bg-light p-2 rounded-3 text-accent"><i class="bi bi-box-seam fs-5"></i></div>
                                <div>
                                    <div class="fw-bold text-dark">{{ $product->name }}</div>
                                    @if($product->description)
                                    <div class="text-muted extra-small text-truncate" style="max-width: 150px;">{{ $product->description }}</div>
                                    @endif
                                </div>
                            </div>
                        </td>
                        <td><span class="badge bg-light text-dark px-3 py-2 rounded-pill">{{ $product->category ?? '-' }}</span></td>
                        <td><span class="price-text">{{ number_format($product->price) }} {{ \App\Models\Setting::get('currency', 'IQD') }}</span></td>
                        <td>
                            <span class="stock-badge {{ $product->stock_quantity <= 5 ? 'low-stock' : 'good-stock' }}">
                                <i class="bi bi-{{ $product->stock_quantity <= 5 ? 'exclamation-triangle' : 'check-circle' }} me-1"></i>
                                {{ $product->stock_quantity }} دانە
                            </span>
                        </td>
                        <td>
                            @if($product->expiry_date)
                            <div class="small {{ $product->expiry_date->isPast() ? 'text-danger fw-bold' : ($product->expiry_date->diffInDays(now()) < 30 ? 'text-warning' : 'text-dark') }}">
                                {{ $product->expiry_date->format('Y-m-d') }}
                                @if($product->expiry_date->isPast())
                                    <div class="extra-small text-danger">بەسەرچووە!</div>
                                @endif
                            </div>
                            @else
                            -
                            @endif
                        </td>
                        <td><code class="bg-light px-2 py-1 rounded text-dark">{{ $product->barcode ?? '-' }}</code></td>
                        <td>
                            @if($product->status)
                            <span class="badge badge-active">چالاک</span>
                            @else
                            <span class="badge badge-expired">ناچالاک</span>
                            @endif
                        </td>
                        <td class="text-end pe-4">
                            <div class="d-flex justify-content-end gap-2">
                                <a href="{{ route('products.edit', $product) }}" class="btn btn-sm btn-light-primary p-2 rounded-3" title="دەستکاری"><i class="bi bi-pencil-square"></i></a>
                                <form action="{{ route('products.destroy', $product) }}" method="POST" onsubmit="return confirm('ئایا دڵنیای لە سڕینەوە؟')" class="d-inline">
                                    @csrf @method('DELETE')
                                    <button type="submit" class="btn btn-sm btn-light-danger p-2 rounded-3" title="سڕینەوە"><i class="bi bi-trash"></i></button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="7" class="text-center py-5 text-muted">
                            <div class="py-4">
                                <i class="bi bi-box-seam fs-1 d-block mb-3 opacity-25"></i>
                                <h6 class="fw-bold">هیچ بەرهەمێک نەدۆزرایەوە</h6>
                                <p class="small">دەتوانیت بەرهەمی نوێ بۆ کۆگا زیاد بکەیت لە ڕێگەی دوگمەی سەرەوە.</p>
                            </div>
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        
        @if($products->hasPages())
        <div class="p-4 border-top">
            {{ $products->links() }}
        </div>
        @endif
    </div>
</div>
@endsection
