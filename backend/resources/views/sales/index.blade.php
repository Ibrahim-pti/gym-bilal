@extends('layouts.app')

@section('title', 'ڕاپۆرتی فرۆشتنەکان')
@section('page-title', 'ڕاپۆرتی فرۆشتنەکان')

@section('content')
<div class="animate-in">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="mb-1 fw-bold text-dark">ڕاپۆرتی فرۆشتنەکان</h4>
            <p class="text-muted small mb-0">چاودێری هەموو فرۆشتنەکان و مامەڵەکانی کۆگا بکە.</p>
        </div>
        @if(auth()->user()->role === 'store_keeper')
        <a href="{{ route('sales.create') }}" class="btn btn-primary rounded-pill px-4 fw-bold shadow-sm">
            <i class="bi bi-cart-plus me-1"></i> فرۆشتنی نوێ (POS)
        </a>
        @endif
    </div>

    <div class="card border-0 shadow-sm" style="border-radius: 20px; overflow: hidden;">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light">
                    <tr>
                        <th class="ps-4">ID</th>
                        <th>بەروار و کات</th>
                        <th>کڕیار / یاریزان</th>
                        <th>کاڵاکان</th>
                        <th>کۆی گشتی</th>
                        <th>شێوازی پارەدان</th>
                        <th class="text-end pe-4">کردارەکان</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($sales as $sale)
                    <tr>
                        <td class="ps-4"><code>#{{ $sale->id }}</code></td>
                        <td class="small">{{ $sale->created_at->format('Y-m-d H:i') }}</td>
                        <td>
                            @if($sale->member)
                                <div class="fw-bold text-dark">{{ $sale->member->name }}</div>
                            @else
                                <span class="text-muted">کڕیاری ئاسایی</span>
                            @endif
                        </td>
                        <td>
                            <span class="badge bg-light text-dark rounded-pill px-3">{{ $sale->items->sum('quantity') }} دانە</span>
                        </td>
                        <td><span class="fw-bold text-primary">{{ number_format($sale->total_amount) }} IQD</span></td>
                        <td>
                            @if($sale->payment_method === 'debt')
                                <span class="badge bg-danger bg-opacity-10 text-danger px-3 py-2 rounded-pill">قەرز</span>
                            @else
                                <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill">نەقد</span>
                            @endif
                        </td>
                        <td class="text-end pe-4">
                            <div class="d-flex justify-content-end gap-2">
                                <a href="{{ route('sales.print', $sale) }}" target="_blank" class="btn btn-sm btn-light rounded-3" title="چاپکردن"><i class="bi bi-printer"></i></a>
                                @if(auth()->user()->role === 'store_keeper')
                                <form action="{{ route('sales.destroy', $sale) }}" method="POST" onsubmit="return confirm('ئایا دڵنیای لە سڕینەوە؟')" class="d-inline">
                                    @csrf @method('DELETE')
                                    <button type="submit" class="btn btn-sm btn-light text-danger rounded-3" title="سڕینەوە"><i class="bi bi-trash"></i></button>
                                </form>
                                @endif
                            </div>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="7" class="text-center py-5 text-muted">
                            <i class="bi bi-receipt fs-1 d-block mb-2"></i>
                            هیچ تۆمارێکی فرۆشتن نەدۆزرایەوە
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        @if($sales->hasPages())
        <div class="card-footer bg-white py-3 border-top">
            {{ $sales->links() }}
        </div>
        @endif
    </div>
</div>
@endsection
