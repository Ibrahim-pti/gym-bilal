@extends('layouts.app')

@section('title', 'بەڕێوەبردنی قەرزەکان')

@push('styles')
<style>
    .debt-card { border: none; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.04); background: #fff; overflow: hidden; }
    .search-area { background: #f8fafc; border-bottom: 1px solid #f1f5f9; padding: 1.5rem; }
    .debt-row { transition: all 0.2s; border-bottom: 1px solid #f8fafc; }
    .debt-row:hover { background: #fcfdfe; }
    .debt-badge-premium { padding: 0.6rem 1.2rem; border-radius: 12px; font-weight: 800; font-size: 1rem; background: #fff1f2; color: #e11d48; border: 1px solid #fee2e2; }
    .stat-box { background: #fff; padding: 20px; border-radius: 18px; border: 1px solid #f1f5f9; box-shadow: 0 4px 15px rgba(0,0,0,0.02); }
    .stat-label { font-size: 0.75rem; font-weight: 800; color: #64748b; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 5px; }
    .stat-value { font-size: 1.6rem; font-weight: 900; color: #e11d48; }
    .btn-pay { background: #10b981; color: #fff; border-radius: 10px; padding: 0.6rem 1.5rem; font-weight: 700; border: none; transition: all 0.2s; }
    .btn-pay:hover { background: #059669; transform: translateY(-2px); box-shadow: 0 8px 20px rgba(16, 185, 129, 0.2); color: #fff; }
</style>
@endpush

@section('content')
<div class="animate-in">
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <h3 class="fw-bold mb-1">بەڕێوەبردنی قەرزەکان</h3>
            <p class="text-muted small mb-0">بینین و وەرگرتنەوەی قەرزەکانی سەر ئەندامانی فرۆشگا.</p>
        </div>
        <div class="stat-box text-center">
            <div class="stat-label">کۆی گشتی قەرزەکان</div>
            <div class="stat-value">{{ number_format(\App\Models\Member::sum('balance')) }} <small style="font-size: 0.5em">IQD</small></div>
        </div>
    </div>

    <div class="debt-card">
        <div class="search-area">
            <form action="{{ route('debts.index') }}" method="GET" class="row g-3">
                <div class="col-md-5">
                    <div class="input-group bg-white rounded-3 shadow-sm overflow-hidden border">
                        <span class="input-group-text border-0 bg-white"><i class="bi bi-search text-muted"></i></span>
                        <input type="text" name="search" class="form-control border-0 py-2" placeholder="بگەڕێ بۆ ناوی ئەندام یان مۆبایل..." value="{{ request('search') }}">
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
                        <th class="ps-4 py-3 text-muted text-uppercase small fw-bold">ناوی ئەندام</th>
                        <th class="py-3 text-muted text-uppercase small fw-bold">ژمارەی مۆبایل</th>
                        <th class="py-3 text-muted text-uppercase small fw-bold">بڕی قەرز</th>
                        <th class="text-end pe-4 py-3 text-muted text-uppercase small fw-bold">کردارەکان</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($members as $member)
                    <tr class="debt-row">
                        <td class="ps-4">
                            <div class="d-flex align-items-center gap-3">
                                <div class="bg-light p-2 rounded-3 text-danger"><i class="bi bi-person-exclamation fs-5"></i></div>
                                <div class="fw-bold text-dark fs-6">{{ $member->name }}</div>
                            </div>
                        </td>
                        <td><span class="text-muted">{{ $member->phone }}</span></td>
                        <td>
                            <span class="debt-badge-premium">
                                {{ number_format($member->balance) }} <small style="font-size: 0.7em">IQD</small>
                            </span>
                        </td>
                        <td class="text-end pe-4">
                            @if(auth()->user()->role === 'store_keeper')
                            <button class="btn btn-pay" data-bs-toggle="modal" data-bs-target="#payModal{{ $member->id }}">
                                <i class="bi bi-cash-stack me-2"></i> دانەوەی قەرز
                            </button>
                            @else
                            <span class="text-muted small italic">تەنها بینین</span>
                            @endif
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="4" class="text-center py-5 text-muted">
                            <i class="bi bi-person-check fs-1 d-block mb-2 opacity-25"></i>
                            هیچ قەرزێک لەسەر ئەندامان نییە
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        
        @if($members->hasPages())
        <div class="p-4 border-top">
            {{ $members->links() }}
        </div>
        @endif
    </div>
</div>

{{-- Modals moved outside the table and container to prevent stacking context issues --}}
@foreach($members as $member)
<div class="modal fade" id="payModal{{ $member->id }}" tabindex="-1" aria-labelledby="payModalLabel{{ $member->id }}" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
            <div class="modal-header border-0 pb-0">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4 pt-0 text-center">
                <div class="mb-3">
                    <div class="bg-success bg-opacity-10 text-success rounded-circle d-flex align-items-center justify-content-center mx-auto" style="width: 60px; height: 60px;">
                        <i class="bi bi-currency-dollar fs-3"></i>
                    </div>
                </div>
                <h5 class="fw-bold mb-1" id="payModalLabel{{ $member->id }}">وەرگرتنی پارە</h5>
                <p class="text-muted small mb-4">ئەندام: {{ $member->name }}</p>
                
                <form action="{{ route('debts.pay', $member) }}" method="POST">
                    @csrf
                    <div class="mb-4">
                        <label class="form-label small fw-bold text-muted">بڕی پارەی وەرگیراو (IQD)</label>
                        <input type="number" name="amount" class="form-control form-control-lg text-center fw-bold border-0 bg-light" max="{{ $member->balance }}" value="{{ $member->balance }}" required>
                    </div>
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-success py-2 fw-bold">تۆمارکردن</button>
                        <button type="button" class="btn btn-light py-2 fw-bold" data-bs-dismiss="modal">پەشیمانبوونەوە</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
@endforeach

@endsection
