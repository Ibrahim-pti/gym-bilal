@extends('layouts.app')
@section('title', 'ڕاپۆرتەکان')
@section('page-title', 'ڕاپۆرتە گشتییەکان')

@push('styles')
<style>
/* Gradient stat cards — theme aware */
.stat-1 { background: linear-gradient(135deg, var(--stat-1-from), var(--stat-1-to)); color: #fff; }
.stat-2 { background: linear-gradient(135deg, var(--stat-2-from), var(--stat-2-to)); color: #fff; }
.stat-3 { background: linear-gradient(135deg, var(--stat-3-from), var(--stat-3-to)); color: #fff; }
.stat-4 { background: linear-gradient(135deg, var(--stat-4-from), var(--stat-4-to)); color: #fff; }
.stat-success { background: linear-gradient(135deg, var(--success), #34D399); color: #fff; }
.stat-danger  { background: linear-gradient(135deg, var(--danger), #FB7185); color: #fff; }

/* Mini stat */
.mini-stat {
    border: 1px solid var(--border);
    border-radius: var(--radius);
    background: var(--surface);
    padding: .9rem 1.1rem;
    display: flex; align-items: center; gap: .65rem;
    transition: border-color .2s, transform .2s;
}
.mini-stat:hover { border-color: #D1D5DB; transform: translateY(-2px); }
.mini-icon {
    width: 2.5rem; height: 2.5rem;
    border-radius: var(--radius-xs);
    display: flex; align-items: center; justify-content: center;
    font-size: 1rem;
}
.mini-value { font-size: 1.1rem; font-weight: 700; line-height: 1.2; }
.mini-label { font-size: .68rem; color: var(--text-muted); font-weight: 500; }

/* Quick Action */
.quick-action {
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: .9rem .6rem;
    text-align: center;
    background: var(--surface);
    transition: all .2s;
    text-decoration: none; color: var(--text);
    display: block;
}
.quick-action:hover { border-color: var(--accent); transform: translateY(-2px); color: var(--accent); }
.quick-action i { font-size: 1.35rem; margin-bottom: .35rem; display: block; }
.quick-action span { font-size: .72rem; font-weight: 600; }

/* Activity item */
.activity-item {
    padding: .65rem 1rem;
    border-bottom: 1px solid #F3F4F6;
    display: flex; justify-content: space-between; align-items: center;
    transition: background .15s;
}
.activity-item:last-child { border-bottom: none; }
.activity-item:hover { background: #FAFBFC; }
</style>
@endpush

@section('content')
{{-- Main Stats --}}
<div class="row g-3 mb-4">
    <div class="col-sm-6 col-xl-3 animate-in">
        <div class="card stat-card stat-1">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon"><i class="bi bi-people-fill text-white"></i></div>
                <div>
                    <div class="fs-3 fw-bold">{{ $totalMembers }}</div>
                    <div class="small opacity-85">{{ __('messages.total_members') }}</div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-3 animate-in">
        <div class="card stat-card stat-2">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon"><i class="bi bi-person-check-fill text-white"></i></div>
                <div>
                    <div class="fs-3 fw-bold">{{ $activeMembers }}</div>
                    <div class="small opacity-85">{{ __('messages.active_members') }}</div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-3 animate-in">
        <div class="card stat-card stat-3">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon"><i class="bi bi-cash-stack text-white"></i></div>
                <div>
                    <div class="fs-3 fw-bold">{{ number_format($monthRevenue) }}</div>
                    <div class="small opacity-85">{{ __('messages.monthly_revenue') }}</div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-3 animate-in">
        <div class="card stat-card {{ $monthProfit >= 0 ? 'stat-4' : 'stat-danger' }}">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon"><i class="bi bi-graph-{{ $monthProfit >= 0 ? 'up' : 'down' }}-arrow text-white"></i></div>
                <div>
                    <div class="fs-3 fw-bold">{{ number_format($monthProfit) }}</div>
                    <div class="small opacity-85">{{ __('messages.monthly_profit') }}</div>
                </div>
            </div>
        </div>
    </div>
</div>

<h6 class="fw-bold mb-3"><i class="bi bi-box-seam text-accent me-2"></i>ڕاپۆرتی کۆگا و فرۆشتن</h6>
<div class="row g-3 mb-4">
    <div class="col-6 col-md-4 col-xl-2 animate-in">
        <div class="mini-stat">
            <div class="mini-icon" style="background: #f1f5f9; color: #475569"><i class="bi bi-box-seam"></i></div>
            <div>
                <div class="mini-value">{{ $totalProducts }}</div>
                <div class="mini-label">کۆی مەوادەکان</div>
            </div>
        </div>
    </div>
    <div class="col-6 col-md-4 col-xl-2 animate-in">
        <div class="mini-stat">
            <div class="mini-icon" style="background: #fff1f2; color: #e11d48"><i class="bi bi-exclamation-triangle"></i></div>
            <div>
                <div class="mini-value">{{ $lowStockProducts }}</div>
                <div class="mini-label">کەمی مەواد</div>
            </div>
        </div>
    </div>
    <div class="col-6 col-md-4 col-xl-2 animate-in">
        <div class="mini-stat">
            <div class="mini-icon" style="background: #fefce8; color: #a16207"><i class="bi bi-clock-history"></i></div>
            <div>
                <div class="mini-value">{{ $nearExpiryProducts }}</div>
                <div class="mini-label">نزیک بەسەرچوون</div>
            </div>
        </div>
    </div>
    <div class="col-6 col-md-4 col-xl-2 animate-in">
        <div class="mini-stat border-danger">
            <div class="mini-icon" style="background: #fecaca; color: #dc2626"><i class="bi bi-x-octagon"></i></div>
            <div>
                <div class="mini-value text-danger">{{ $expiredProducts }}</div>
                <div class="mini-label">بەسەرچووە</div>
            </div>
        </div>
    </div>
    <div class="col-6 col-md-4 col-xl-2 animate-in">
        <div class="mini-stat">
            <div class="mini-icon" style="background: var(--info-light); color: var(--info)"><i class="bi bi-cart-check-fill"></i></div>
            <div>
                <div class="mini-value">{{ number_format($todayStoreSales) }}</div>
                <div class="mini-label">فرۆشی ئەمڕۆ</div>
            </div>
        </div>
    </div>
    <div class="col-6 col-md-4 col-xl-2 animate-in">
        <div class="mini-stat">
            <div class="mini-icon" style="background: var(--accent-light); color: var(--accent)"><i class="bi bi-shop"></i></div>
            <div>
                <div class="mini-value">{{ number_format($monthStoreSales) }}</div>
                <div class="mini-label">فرۆشی مانگ</div>
            </div>
        </div>
    </div>
</div>

<h6 class="fw-bold mb-3"><i class="bi bi-people text-info me-2"></i>ڕاپۆرتی ئەندامان و چالاکییەکان</h6>
<div class="row g-3 mb-4">
    <div class="col-6 col-md-4 col-xl-2 animate-in">
        <div class="mini-stat">
            <div class="mini-icon" style="background: var(--accent-light); color: var(--accent)"><i class="bi bi-cash-coin"></i></div>
            <div>
                <div class="mini-value">{{ number_format($todayRevenue) }}</div>
                <div class="mini-label">{{ __('messages.today_revenue') }}</div>
            </div>
        </div>
    </div>
    <div class="col-6 col-md-4 col-xl-2 animate-in">
        <div class="mini-stat">
            <div class="mini-icon" style="background: var(--danger-light); color: var(--danger)"><i class="bi bi-wallet2"></i></div>
            <div>
                <div class="mini-value">{{ number_format($monthExpenses) }}</div>
                <div class="mini-label">{{ __('messages.monthly_expenses') }}</div>
            </div>
        </div>
    </div>
    <div class="col-6 col-md-4 col-xl-2 animate-in">
        <div class="mini-stat">
            <div class="mini-icon" style="background: var(--warning-light); color: var(--warning)"><i class="bi bi-person-x-fill"></i></div>
            <div>
                <div class="mini-value">{{ $expiredMembers }}</div>
                <div class="mini-label">{{ __('messages.expired_members') }}</div>
            </div>
        </div>
    </div>
    <div class="col-6 col-md-4 col-xl-2 animate-in">
        <div class="mini-stat">
            <div class="mini-icon" style="background: var(--success-light); color: var(--success)"><i class="bi bi-fingerprint"></i></div>
            <div>
                <div class="mini-value">{{ $todayAttendance }}</div>
                <div class="mini-label">{{ __('messages.today_attendance') }}</div>
            </div>
        </div>
    </div>
    <div class="col-6 col-md-4 col-xl-2 animate-in">
        <div class="mini-stat">
            <div class="mini-icon" style="background: var(--info-light); color: var(--info)"><i class="bi bi-person-badge"></i></div>
            <div>
                <div class="mini-value">{{ $activeTrainers }}</div>
                <div class="mini-label">{{ __('messages.active_trainers') }}</div>
            </div>
        </div>
    </div>
    <div class="col-6 col-md-4 col-xl-2 animate-in">
        <div class="mini-stat">
            <div class="mini-icon" style="background: {{ $equipmentAlert > 0 ? 'var(--danger-light)' : '#F3F4F6' }}; color: {{ $equipmentAlert > 0 ? 'var(--danger)' : 'var(--text-muted)' }}"><i class="bi bi-tools"></i></div>
            <div>
                <div class="mini-value">{{ $equipmentAlert }}</div>
                <div class="mini-label">{{ __('messages.needs_maintenance') }}</div>
            </div>
        </div>
    </div>
</div>

{{-- Chart + Expiring --}}
<div class="row g-3 mb-4">
    <div class="col-lg-8 animate-in">
        <div class="card h-100">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h6 class="mb-0 fw-bold" style="font-size:.88rem"><i class="bi bi-bar-chart-fill me-2" style="color:var(--accent)"></i>{{ __('messages.revenue_vs_expenses') }}</h6>
            </div>
            <div class="card-body">
                <canvas id="revenueChart" height="115"></canvas>
            </div>
        </div>
    </div>
    <div class="col-lg-4 animate-in">
        <div class="card h-100">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h6 class="mb-0 fw-bold" style="font-size:.88rem"><i class="bi bi-clock-history me-2" style="color:var(--warning)"></i>{{ __('messages.expiring_soon') }}</h6>
                <span class="badge" style="background: var(--warning-light); color: #92400E;">{{ $expiringMembers->count() }}</span>
            </div>
            <div class="card-body p-0" style="max-height: 310px; overflow-y:auto">
                @forelse($expiringMembers as $sub)
                <div class="activity-item">
                    <div>
                        <div class="fw-semibold" style="font-size:.82rem">{{ $sub->member->name }}</div>
                        <div class="text-muted" style="font-size:.68rem">{{ $sub->end_date->format('Y-m-d') }}</div>
                    </div>
                    <span class="badge" style="background:var(--warning-light);color:#92400E">{{ $sub->days_remaining }}{{ __('messages.days_short') }}</span>
                </div>
                @empty
                <div class="p-4 text-center text-muted">
                    <i class="bi bi-check-circle fs-2 d-block mb-2" style="color: var(--success)"></i>
                    <small>{{ __('messages.no_expiring') }}</small>
                </div>
                @endforelse
            </div>
        </div>
    </div>
</div>

@endsection

@push('scripts')
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
<script>
const months = ['١','٢','٣','٤','٥','٦','٧','٨','٩','١٠','١١','١٢'];
const revData = @json($revenueData);
const expData = @json($expenseData);
const cs = getComputedStyle(document.documentElement);
const accentColor = cs.getPropertyValue('--accent').trim() || '#6C63FF';
const accentSoft  = cs.getPropertyValue('--accent-soft').trim() || '#818CF8';

new Chart(document.getElementById('revenueChart'), {
    type: 'bar',
    data: {
        labels: months,
        datasets: [
            { label: '{{ __("messages.revenue") }}', data: revData, backgroundColor: accentColor, borderRadius: 6, borderSkipped: false, barPercentage: .6 },
            { label: '{{ __("messages.expenses") }}', data: expData, backgroundColor: accentSoft + '55', borderRadius: 6, borderSkipped: false, barPercentage: .6 }
        ]
    },
    options: {
        responsive: true,
        plugins: {
            legend: { position: 'top', labels: { usePointStyle: true, padding: 16, font: { size: 11, family: "'Noto Sans Arabic', Inter" } } }
        },
        scales: {
            y: { beginAtZero: true, grid: { color: '#F3F4F6', drawBorder: false }, ticks: { callback: v => v.toLocaleString(), font: { size: 10 } }, border: { display: false } },
            x: { grid: { display: false }, border: { display: false }, ticks: { font: { size: 11, family: "'Noto Sans Arabic', Inter" } } }
        }
    }
});
</script>
@endpush
