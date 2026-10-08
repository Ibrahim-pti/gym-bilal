@extends('layouts.app')
@section('title', __('messages.equipment'))
@section('page-title', __('messages.equipment'))

@section('content')
<div class="row g-3 mb-3">
    <div class="col-md-4 animate-in">
        <div class="card stat-card" style="background: linear-gradient(135deg,#14B8A6,#5EEAD4); color:#fff;">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon"><i class="bi bi-tools text-white"></i></div>
                <div>
                    <div class="fs-3 fw-bold">{{ $equipment->total() }}</div>
                    <div class="small opacity-85">{{ __('messages.total_equipment') }}</div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4 animate-in">
        <div class="card stat-card" style="background: linear-gradient(135deg,#6C63FF,#A78BFA); color:#fff;">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon"><i class="bi bi-cash-stack text-white"></i></div>
                <div>
                    <div class="fs-3 fw-bold">{{ number_format($totalValue) }}</div>
                    <div class="small opacity-85">{{ __('messages.total_value') }}</div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4 animate-in">
        <div class="card stat-card" style="background: linear-gradient(135deg,{{ $needsMaintenance > 0 ? '#F43F5E,#FB7185' : '#10B981,#34D399' }}); color:#fff;">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon"><i class="bi bi-wrench-adjustable text-white"></i></div>
                <div>
                    <div class="fs-3 fw-bold">{{ $needsMaintenance }}</div>
                    <div class="small opacity-85">{{ __('messages.needs_maintenance') }}</div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="card animate-in">
    <div class="card-header d-flex flex-wrap justify-content-between align-items-center gap-2">
        <h6 class="mb-0 fw-bold" style="font-size:.88rem">{{ __('messages.equipment_list') }}</h6>
        <div class="d-flex gap-2 flex-wrap">
            <form class="d-flex gap-2">
                <input type="text" name="search" class="form-control form-control-sm" placeholder="{{ __('messages.search') }}..." value="{{ request('search') }}" style="width: 140px">
                <select name="category" class="form-select form-select-sm" style="width:120px" onchange="this.form.submit()">
                    <option value="">{{ __('messages.all') }}</option>
                    @foreach(['cardio','weights','machines','accessories','other'] as $cat)
                    <option value="{{ $cat }}" {{ request('category') === $cat ? 'selected' : '' }}>{{ __('messages.' . $cat) }}</option>
                    @endforeach
                </select>
                <select name="condition" class="form-select form-select-sm" style="width:130px" onchange="this.form.submit()">
                    <option value="">{{ __('messages.all_conditions') }}</option>
                    @foreach(['new','good','fair','needs_repair','broken'] as $cond)
                    <option value="{{ $cond }}" {{ request('condition') === $cond ? 'selected' : '' }}>{{ __('messages.condition_' . $cond) }}</option>
                    @endforeach
                </select>
                <button class="btn btn-sm btn-light"><i class="bi bi-search"></i></button>
            </form>
            <a href="{{ route('equipment.create') }}" class="btn btn-sm btn-primary"><i class="bi bi-plus-lg me-1"></i>{{ __('messages.add_equipment') }}</a>
        </div>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead>
                    <tr>
                        <th>{{ __('messages.equipment_name') }}</th>
                        <th>{{ __('messages.category') }}</th>
                        <th>{{ __('messages.quantity') }}</th>
                        <th>{{ __('messages.condition') }}</th>
                        <th>{{ __('messages.next_maintenance') }}</th>
                        <th class="text-end">{{ __('messages.actions') }}</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($equipment as $item)
                    <tr>
                        <td class="fw-semibold" style="font-size:.85rem">{{ $item->name }}</td>
                        <td>
                            @if($item->category)
                            <span class="badge" style="background:var(--sky-light);color:var(--sky)">{{ __('messages.' . $item->category) }}</span>
                            @else — @endif
                        </td>
                        <td style="font-size:.85rem">{{ $item->quantity }}</td>
                        <td>
                            @php
                                $cc = ['new'=>['emerald-light','#065F46'],'good'=>['accent-light','accent'],'fair'=>['amber-light','#92400E'],'needs_repair'=>['rose-light','rose'],'broken'=>['#F3F4F6','text']];
                                $s = $cc[$item->condition] ?? $cc['good'];
                            @endphp
                            <span class="badge" style="background:var(--{{ $s[0] }});color:var(--{{ $s[1] }})">{{ __('messages.condition_' . $item->condition) }}</span>
                        </td>
                        <td style="font-size:.85rem">
                            @if($item->next_maintenance)
                                @if($item->next_maintenance <= now())
                                <span style="color:var(--rose)" class="fw-bold"><i class="bi bi-exclamation-triangle me-1"></i>{{ $item->next_maintenance->format('Y-m-d') }}</span>
                                @else {{ $item->next_maintenance->format('Y-m-d') }} @endif
                            @else — @endif
                        </td>
                        <td class="text-end">
                            <a href="{{ route('equipment.edit', $item) }}" class="btn btn-sm btn-light"><i class="bi bi-pencil" style="color:var(--accent)"></i></a>
                            <form action="{{ route('equipment.destroy', $item) }}" method="POST" class="d-inline" onsubmit="return confirm('{{ __('messages.confirm_delete') }}')">
                                @csrf @method('DELETE')
                                <button class="btn btn-sm btn-light"><i class="bi bi-trash" style="color:var(--rose)"></i></button>
                            </form>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="6" class="text-center py-5 text-muted">
                            <i class="bi bi-inbox fs-1 d-block mb-2"></i>{{ __('messages.no_records') }}
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
    @if($equipment->hasPages())
    <div class="card-body border-top py-2">{{ $equipment->links() }}</div>
    @endif
</div>
@endsection
