@extends('layouts.app')
@section('title', __('messages.reports'))
@section('page-title', __('messages.reports'))

@section('content')
{{-- Filters --}}
<div class="card mb-3 animate-in">
    <div class="card-body py-2">
        <form class="d-flex flex-wrap gap-3 align-items-end">
            <div>
                <label class="form-label" style="font-size:.72rem;font-weight:600">{{ __('messages.year') }}</label>
                <select name="year" class="form-select form-select-sm" style="width:110px" onchange="this.form.submit()">
                    @foreach($years as $y)
                    <option value="{{ $y }}" {{ $year == $y ? 'selected' : '' }}>{{ $y }}</option>
                    @endforeach
                </select>
            </div>
            <div>
                <label class="form-label" style="font-size:.72rem;font-weight:600">{{ __('messages.month') }}</label>
                <select name="month" class="form-select form-select-sm" style="width:130px" onchange="this.form.submit()">
                    <option value="">{{ __('messages.all') }}</option>
                    @for($i = 1; $i <= 12; $i++)
                    <option value="{{ $i }}" {{ $month == $i ? 'selected' : '' }}>{{ $i }}</option>
                    @endfor
                </select>
            </div>
            <a href="{{ route('reports.export', ['year' => $year, 'month' => $month]) }}" class="btn btn-sm btn-light"><i class="bi bi-download me-1"></i>{{ __('messages.export') }}</a>
        </form>
    </div>
</div>

{{-- Summary --}}
<div class="row g-3 mb-3">
    <div class="col-sm-6 col-xl-3 animate-in">
        <div class="card stat-card" style="background: linear-gradient(135deg,#10B981,#34D399); color:#fff;">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon"><i class="bi bi-cash-stack text-white"></i></div>
                <div>
                    <div class="fs-3 fw-bold">{{ number_format($totalRevenue) }}</div>
                    <div class="small opacity-85">{{ __('messages.total_revenue') }}</div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-3 animate-in">
        <div class="card stat-card" style="background: linear-gradient(135deg,#F43F5E,#FB7185); color:#fff;">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon"><i class="bi bi-wallet2 text-white"></i></div>
                <div>
                    <div class="fs-3 fw-bold">{{ number_format($totalExpenses) }}</div>
                    <div class="small opacity-85">{{ __('messages.total_expenses') }}</div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-3 animate-in">
        <div class="card stat-card" style="background: linear-gradient(135deg,#8B5CF6,#A78BFA); color:#fff;">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon"><i class="bi bi-person-badge text-white"></i></div>
                <div>
                    <div class="fs-3 fw-bold">{{ number_format($trainerSalaries) }}</div>
                    <div class="small opacity-85">{{ __('messages.total_salaries') }}</div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-3 animate-in">
        <div class="card stat-card" style="background: linear-gradient(135deg,{{ $netProfit >= 0 ? '#14B8A6,#5EEAD4' : '#DC2626,#F87171' }}); color:#fff;">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon"><i class="bi bi-graph-{{ $netProfit >= 0 ? 'up' : 'down' }}-arrow text-white"></i></div>
                <div>
                    <div class="fs-3 fw-bold">{{ number_format($netProfit) }}</div>
                    <div class="small opacity-85">{{ __('messages.net_profit') }}</div>
                </div>
            </div>
        </div>
    </div>
</div>

{{-- Charts --}}
<div class="row g-3 mb-3">
    <div class="col-lg-8 animate-in">
        <div class="card h-100">
            <div class="card-header"><h6 class="mb-0 fw-bold" style="font-size:.88rem"><i class="bi bi-bar-chart-fill me-2" style="color:var(--accent)"></i>{{ __('messages.revenue_vs_expenses') }}</h6></div>
            <div class="card-body"><canvas id="mainChart" height="120"></canvas></div>
        </div>
    </div>
    <div class="col-lg-4 animate-in">
        <div class="card h-100">
            <div class="card-header"><h6 class="mb-0 fw-bold" style="font-size:.88rem"><i class="bi bi-pie-chart-fill me-2" style="color:var(--sky)"></i>{{ __('messages.member_report') }}</h6></div>
            <div class="card-body">
                <canvas id="memberChart" height="180"></canvas>
                <div class="d-flex justify-content-around mt-3 text-center">
                    <div>
                        <div class="fs-5 fw-bold" style="color:var(--emerald)">{{ $activeCount }}</div>
                        <div class="text-muted" style="font-size:.7rem">{{ __('messages.active') }}</div>
                    </div>
                    <div>
                        <div class="fs-5 fw-bold" style="color:var(--rose)">{{ $expiredCount }}</div>
                        <div class="text-muted" style="font-size:.7rem">{{ __('messages.expired') }}</div>
                    </div>
                    <div>
                        <div class="fs-5 fw-bold" style="color:var(--accent)">{{ $newMembers }}</div>
                        <div class="text-muted" style="font-size:.7rem">{{ __('messages.new_members') }}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{{-- Profit line --}}
<div class="row g-3 mb-3">
    <div class="col-12 animate-in">
        <div class="card">
            <div class="card-header"><h6 class="mb-0 fw-bold" style="font-size:.88rem"><i class="bi bi-graph-up me-2" style="color:var(--emerald)"></i>{{ __('messages.profit_loss') }}</h6></div>
            <div class="card-body"><canvas id="profitChart" height="65"></canvas></div>
        </div>
    </div>
</div>

{{-- Top Members --}}
<div class="card animate-in">
    <div class="card-header"><h6 class="mb-0 fw-bold" style="font-size:.88rem"><i class="bi bi-trophy-fill me-2" style="color:var(--amber)"></i>Top 10</h6></div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table mb-0">
                <thead><tr><th>#</th><th>{{ __('messages.member') }}</th><th>{{ __('messages.total_revenue') }}</th></tr></thead>
                <tbody>
                    @forelse($topMembers as $i => $tm)
                    <tr>
                        <td>
                            @if($i < 3)<span class="badge" style="background:var(--amber-light);color:#92400E;border-radius:50%;width:22px;height:22px;display:inline-flex;align-items:center;justify-content:center">{{ $i + 1 }}</span>@else {{ $i + 1 }} @endif
                        </td>
                        <td class="fw-semibold" style="font-size:.85rem">{{ $tm->member?->name }}</td>
                        <td class="fw-bold" style="color:var(--emerald)">{{ number_format($tm->total) }}</td>
                    </tr>
                    @empty
                    <tr><td colspan="3" class="text-center text-muted py-4">{{ __('messages.no_records') }}</td></tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
<script>
const m = ['١','٢','٣','٤','٥','٦','٧','٨','٩','١٠','١١','١٢'];
const rv = @json($revenueData), ex = @json($expenseData), pr = @json($profitData);
const fontFamily = "'Noto Sans Arabic', Inter";

new Chart(document.getElementById('mainChart'), {
    type: 'bar', data: { labels: m, datasets: [
        { label: '{{ __("messages.revenue") }}', data: rv, backgroundColor: '#6C63FF', borderRadius: 6, borderSkipped: false, barPercentage: .6 },
        { label: '{{ __("messages.expenses") }}', data: ex, backgroundColor: '#F43F5E', borderRadius: 6, borderSkipped: false, barPercentage: .6 }
    ]},
    options: { responsive: true, plugins: { legend: { position: 'top', labels: { usePointStyle: true, padding: 14, font: { size: 11, family: fontFamily } } } },
        scales: { y: { beginAtZero: true, grid: { color: '#F3F4F6', drawBorder: false }, ticks: { callback: v => v.toLocaleString(), font: { size: 10 } }, border: { display: false } }, x: { grid: { display: false }, border: { display: false }, ticks: { font: { size: 11, family: fontFamily } } } } }
});

new Chart(document.getElementById('memberChart'), {
    type: 'doughnut', data: { labels: ['{{ __("messages.active") }}', '{{ __("messages.expired") }}'], datasets: [{ data: [{{ $activeCount }}, {{ $expiredCount }}], backgroundColor: ['#10B981','#F43F5E'], borderWidth: 0, spacing: 2 }] },
    options: { cutout: '65%', plugins: { legend: { display: false } } }
});

new Chart(document.getElementById('profitChart'), {
    type: 'line', data: { labels: m, datasets: [{ label: '{{ __("messages.net_profit") }}', data: pr, borderColor: '#10B981', backgroundColor: 'rgba(16,185,129,.06)', fill: true, tension: .4, pointRadius: 3, pointBackgroundColor: pr.map(v => v >= 0 ? '#10B981' : '#F43F5E') }] },
    options: { responsive: true, plugins: { legend: { position: 'top', labels: { usePointStyle: true, font: { size: 11, family: fontFamily } } } },
        scales: { y: { grid: { color: '#F3F4F6', drawBorder: false }, ticks: { callback: v => v.toLocaleString(), font: { size: 10 } }, border: { display: false } }, x: { grid: { display: false }, border: { display: false }, ticks: { font: { size: 11, family: fontFamily } } } } }
});
</script>
@endpush
