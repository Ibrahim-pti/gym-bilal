@extends('layouts.app')
@section('title', 'لیستی یاریزانەکان')
@section('page-title', 'یاریزانەکان')

@section('content')
<style>
    @keyframes pulse-red {
        0% { transform: scale(1); }
        50% { transform: scale(1.05); background-color: #ef4444; }
        100% { transform: scale(1); }
    }
    .animate-pulse { animation: pulse-red 2s infinite; }
</style>
<div class="animate-in">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="mb-1 fw-bold text-dark">لیستی یاریزانەکان</h4>
            <p class="text-muted small mb-0">بەڕێوەبردن و چاودێریکردنی یاریزانانی هۆڵ.</p>
        </div>
        <a href="{{ route('members.create') }}" class="btn btn-primary px-4 py-2 fw-bold rounded-pill shadow-sm">
            <i class="bi bi-person-plus-fill me-2"></i>زیادکردنی یاریزانی نوێ
        </a>
    </div>

    {{-- Filters & Search --}}
    <div class="card border-0 shadow-sm mb-4" style="border-radius: 15px;">
        <div class="card-body py-3">
            <form method="GET" class="row g-3 align-items-center">
                <div class="col-md-5">
                    <div class="input-group bg-light rounded-3 overflow-hidden border-0">
                        <span class="input-group-text bg-light border-0"><i class="bi bi-search text-muted"></i></span>
                        <input type="text" name="search" class="form-control bg-light border-0"
                               placeholder="بگەڕێ بۆ ناوی یاریزان..." value="{{ request('search') }}">
                    </div>
                </div>
                <div class="col-md-2">
                    <select name="status" class="form-select bg-light border-0">
                        <option value="">هەموو دۆخەکان</option>
                        <option value="active"  {{ request('status')=='active'  ? 'selected' : '' }}>چالاکەکان</option>
                        <option value="expired" {{ request('status')=='expired' ? 'selected' : '' }}>بەسەرچووەکان</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <select name="gender" class="form-select bg-light border-0">
                        <option value="">هەموو ڕەگەزەکان</option>
                        <option value="male"   {{ request('gender')=='male'   ? 'selected' : '' }}>نێر</option>
                        <option value="female" {{ request('gender')=='female' ? 'selected' : '' }}>مێ</option>
                    </select>
                </div>
                <div class="col-md-3 d-flex gap-2">
                    <button type="submit" class="btn btn-dark w-100 fw-bold rounded-3">فلتەر</button>
                    <a href="{{ route('members.index') }}" class="btn btn-light w-100 border fw-bold rounded-3">پاککردنەوە</a>
                </div>
            </form>
        </div>
    </div>

    <div class="card border-0 shadow-sm" style="border-radius: 20px; overflow: hidden;">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light">
                    <tr>
                        <th class="ps-4">ID</th>
                        <th>ناوی یاریزان</th>
                        <th>ڕەگەز</th>
                        <th>دۆخ</th>
                        <th>بەرواری دەستپێکردن</th>
                        <th>بەرواری کۆتایی</th>
                        <th class="text-end pe-4">کردارەکان</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($members as $member)
                    <tr>
                        <td class="ps-4 text-muted small">#{{ $member->id }}</td>
                        <td>
                            <a href="{{ route('members.show', $member) }}" class="fw-bold text-dark text-decoration-none d-block">
                                {{ $member->name }}
                            </a>
                            @if($member->notes)
                            <small class="text-muted d-block" style="font-size: 0.7rem;">{{ Str::limit($member->notes, 30) }}</small>
                            @endif
                        </td>
                        <td>
                            @if($member->gender === 'male')
                                <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill">نێر</span>
                            @else
                                <span class="badge bg-danger bg-opacity-10 text-danger px-3 py-2 rounded-pill">مێ</span>
                            @endif
                        </td>
                        <td>
                            @if($member->status === 'active')
                                <span class="badge bg-success px-3 py-2 rounded-pill shadow-sm"><i class="bi bi-check-circle me-1"></i>چالاک</span>
                            @else
                                <span class="badge bg-danger px-3 py-2 rounded-pill shadow-sm animate-pulse"><i class="bi bi-exclamation-triangle me-1"></i>بەسەرچوو</span>
                            @endif
                        </td>
                        <td class="text-muted small fw-bold">
                            {{ $member->active_from ? Carbon\Carbon::parse($member->active_from)->format('Y-m-d') : '—' }}
                        </td>
                        <td class="small fw-bold {{ $member->status === 'expired' ? 'text-danger fs-6' : 'text-primary' }}">
                            @if($member->status === 'expired')
                                <i class="bi bi-calendar-x me-1"></i>
                            @endif
                            {{ $member->active_until ? Carbon\Carbon::parse($member->active_until)->format('Y-m-d') : '—' }}
                        </td>
                        <td class="text-end pe-4">
                            <div class="d-flex justify-content-end gap-2">
                                @if($member->status === 'expired')
                                <a href="{{ route('members.show', $member) }}#renew" class="btn btn-sm btn-danger rounded-3 fw-bold px-3">
                                    <i class="bi bi-arrow-repeat me-1"></i>نوێکردنەوە
                                </a>
                                @endif
                                <a href="{{ route('members.show', $member) }}" class="btn btn-sm btn-light border-0 rounded-3" title="بینین"><i class="bi bi-eye"></i></a>
                                <a href="{{ route('members.edit', $member) }}" class="btn btn-sm btn-light border-0 rounded-3 text-warning" title="دەستکاری"><i class="bi bi-pencil-square"></i></a>
                                <form method="POST" action="{{ route('members.destroy', $member) }}" 
                                      onsubmit="return confirm('ئایا دڵنیای لە سڕینەوەی ئەم یاریزانە؟')" class="d-inline">
                                    @csrf @method('DELETE')
                                    <button type="submit" class="btn btn-sm btn-light border-0 rounded-3 text-danger" title="سڕینەوە"><i class="bi bi-trash"></i></button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    @empty
                    <tr><td colspan="7" class="text-center text-muted py-5">هیچ یاریزانێک نەدۆزرایەوە</td></tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        @if($members->hasPages())
        <div class="card-footer bg-white p-4 border-top">
            {{ $members->links() }}
        </div>
        @endif
    </div>
</div>
@endsection
