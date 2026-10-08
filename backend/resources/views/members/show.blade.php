@extends('layouts.app')
@section('title', 'پڕۆفایلی یاریزان')

@push('styles')
<style>
    .player-header { background: #fff; border-radius: 24px; padding: 2.5rem; box-shadow: 0 10px 40px rgba(0,0,0,0.03); border: 1px solid #f1f5f9; position: relative; overflow: hidden; }
    .player-header::before { content: ''; position: absolute; top: 0; left: 0; width: 8px; height: 100%; background: #0ea5e9; }
    .player-avatar-large { width: 110px; height: 110px; border-radius: 30px; background: #f0f9ff; display: flex; align-items: center; justify-content: center; font-size: 3rem; font-weight: 900; color: #0369a1; border: 4px solid #fff; box-shadow: 0 8px 25px rgba(14, 165, 233, 0.15); }
    
    .info-card { background: #fff; border-radius: 20px; border: 1px solid #f1f5f9; padding: 1.5rem; height: 100%; transition: all 0.3s; }
    .info-label { font-size: 0.75rem; font-weight: 800; color: #94a3b8; text-transform: uppercase; margin-bottom: 0.5rem; }
    .info-value { font-size: 1.15rem; font-weight: 700; color: #0f172a; }

    .history-section { background: #fff; border-radius: 24px; border: 1px solid #f1f5f9; padding: 2rem; margin-top: 2rem; }
    .section-title { font-size: 1.1rem; font-weight: 900; color: #1e293b; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 10px; }
    
    .timeline-item { padding: 1.2rem; border-radius: 16px; background: #f8fafc; margin-bottom: 1rem; display: flex; justify-content: space-between; align-items: center; border: 1px solid transparent; transition: all 0.2s; }
    .timeline-item:hover { background: #fff; border-color: #e2e8f0; transform: translateX(-5px); }
    
    .badge-status { padding: 0.5rem 1.2rem; border-radius: 50px; font-weight: 800; font-size: 0.75rem; border: none; }
    .status-active { background: #dcfce7; color: #15803d; }
    .status-expired { background: #fee2e2; color: #b91c1c; }

    .btn-edit-new { background: #f0f9ff; color: #0284c7; border: 1px solid #e0f2fe; }
    .btn-edit-new:hover { background: #0ea5e9; color: #fff; }
</style>
@endpush

@section('content')
<div class="animate-in">
    {{-- Back Button & Actions --}}
    <div class="d-flex justify-content-between align-items-center mb-4">
        <a href="{{ route('members.index') }}" class="btn btn-light rounded-pill px-4 fw-bold border">
            <i class="bi bi-arrow-right me-2"></i>گەڕانەوە
        </a>
        <div class="d-flex gap-2">
            <a href="{{ route('members.edit', $member) }}" class="btn btn-edit-new rounded-pill px-4 fw-bold">
                <i class="bi bi-pencil-square me-2"></i>دەستکاری زانیاری
            </a>
            <form method="POST" action="{{ route('members.destroy', $member) }}" onsubmit="return confirm('ئایا دڵنیای لە سڕینەوە؟')">
                @csrf @method('DELETE')
                <button type="submit" class="btn btn-light border rounded-pill px-4 fw-bold text-danger">
                    <i class="bi bi-trash me-2"></i>سڕینەوە
                </button>
            </form>
        </div>
    </div>

    {{-- Main Profile Card --}}
    <div class="player-header mb-4 d-flex align-items-center gap-4">
        <div class="player-avatar-large">{{ substr($member->name, 0, 1) }}</div>
        <div class="flex-grow-1">
            <div class="d-flex align-items-center gap-3 mb-2">
                <h1 class="fw-900 mb-0" style="font-size: 2.2rem;">{{ $member->name }}</h1>
                @if($member->status === 'active')
                    <span class="badge-status status-active">چالاک</span>
                @else
                    <span class="badge-status status-expired">بەسەرچووە</span>
                @endif
            </div>
            <div class="d-flex gap-4">
                <span class="text-muted fw-bold"><i class="bi bi-hash text-info me-1"></i> ناسنامە: #{{ $member->id }}</span>
                <span class="text-muted fw-bold"><i class="bi bi-gender-ambiguous text-info me-1"></i> ڕەگەز: {{ $member->gender === 'male' ? 'نێر' : 'مێ' }}</span>
            </div>
        </div>
    </div>

    {{-- Info Cards Grid --}}
    <div class="row g-4 mb-2">
        <div class="col-md-4">
            <div class="info-card">
                <div class="info-label">بەرواری کۆتایی هاتن</div>
                <div class="info-value {{ $member->status === 'expired' ? 'text-danger' : 'text-primary' }}">
                    <i class="bi bi-calendar-event me-2"></i>{{ $member->active_until ? \Carbon\Carbon::parse($member->active_until)->format('Y-m-d') : 'دیاری نەکراوە' }}
                </div>
            </div>
        </div>
        <div class="col-md-8">
            <div class="info-card">
                <div class="info-label">تێبینییەکان</div>
                <div class="info-value text-muted" style="font-size: 1rem;">{{ $member->notes ?: 'هیچ تێبینییەکی تایبەت تۆمار نەکراوە بۆ ئەم یاریزانە.' }}</div>
            </div>
        </div>
    </div>

    {{-- Combined History Sections with Cleaner Look --}}
    <div class="row g-4">
        {{-- Subscriptions Timeline --}}
        <div class="col-lg-6">
            <div class="history-section">
                <div class="section-title">
                    <i class="bi bi-clock-history text-primary"></i> مێژووی ئیشتراکەکان
                </div>
                @forelse($member->subscriptions as $sub)
                <div class="timeline-item">
                    <div>
                        <div class="fw-900 text-dark">{{ $sub->plan?->name }}</div>
                        <div class="text-muted small fw-bold mt-1">لە {{ $sub->start_date->format('Y-m-d') }} تا {{ $sub->end_date->format('Y-m-d') }}</div>
                    </div>
                    <div class="text-end">
                        <div class="fw-900 text-primary mb-1">{{ number_format($sub->amount_paid) }} <small>IQD</small></div>
                        @if($sub->status === 'active' && !$sub->is_expired)
                            <span class="badge-status status-active" style="font-size: 0.65rem;">چالاک</span>
                        @else
                            <span class="badge-status status-expired" style="font-size: 0.65rem;">بەسەرچوو</span>
                        @endif
                    </div>
                </div>
                @empty
                <div class="text-center py-4 text-muted small">هیچ مێژوویەکی ئیشتراک نییە</div>
                @endforelse
            </div>
        </div>

        {{-- Payments --}}
        <div class="col-lg-6">
            <div class="history-section">
                <div class="section-title">
                    <i class="bi bi-wallet2 text-success"></i> مێژووی پارەدانەکان
                </div>
                @forelse($member->payments as $p)
                <div class="timeline-item">
                    <div>
                        <div class="fw-900 text-dark">پسوولەی ژمارە #{{ substr($p->receipt_number, -6) }}</div>
                        <div class="text-muted small fw-bold mt-1">{{ \Carbon\Carbon::parse($p->payment_date)->format('Y-m-d') }}</div>
                    </div>
                    <div class="text-end">
                        <div class="fw-900 text-success">{{ number_format($p->amount) }} <small>IQD</small></div>
                        <div class="text-muted extra-small" style="font-size: 0.6rem;">شێواز: {{ $p->payment_method === 'cash' ? 'نەختینە' : 'کارت' }}</div>
                    </div>
                </div>
                @empty
                <div class="text-center py-4 text-muted small">هیچ پارەدانێک تۆمار نەکراوە</div>
                @endforelse
            </div>
        </div>
    </div>
</div>
@endsection
