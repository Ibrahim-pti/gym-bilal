@extends('layouts.app')
@section('title', __('messages.trainers'))
@section('page-title', __('messages.trainers'))

@section('content')
<div class="row g-3 mb-3">
    <div class="col-md-4 animate-in">
        <div class="card stat-card" style="background: linear-gradient(135deg,#8B5CF6,#A78BFA); color:#fff;">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon"><i class="bi bi-person-badge-fill text-white"></i></div>
                <div>
                    <div class="fs-3 fw-bold">{{ $trainers->total() }}</div>
                    <div class="small opacity-85">{{ __('messages.total_trainers') }}</div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4 animate-in">
        <div class="card stat-card" style="background: linear-gradient(135deg,#0EA5E9,#38BDF8); color:#fff;">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon"><i class="bi bi-cash-stack text-white"></i></div>
                <div>
                    <div class="fs-3 fw-bold">{{ number_format($totalSalaries) }}</div>
                    <div class="small opacity-85">{{ __('messages.total_salaries') }}</div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="card animate-in">
    <div class="card-header d-flex flex-wrap justify-content-between align-items-center gap-2">
        <h6 class="mb-0 fw-bold" style="font-size:.88rem">{{ __('messages.trainers') }}</h6>
        <div class="d-flex gap-2">
            <form class="d-flex gap-2">
                <input type="text" name="search" class="form-control form-control-sm" placeholder="{{ __('messages.search') }}..." value="{{ request('search') }}" style="width: 160px">
                <select name="status" class="form-select form-select-sm" style="width:120px" onchange="this.form.submit()">
                    <option value="">{{ __('messages.all') }}</option>
                    <option value="active" {{ request('status') === 'active' ? 'selected' : '' }}>{{ __('messages.active') }}</option>
                    <option value="inactive" {{ request('status') === 'inactive' ? 'selected' : '' }}>{{ __('messages.inactive') }}</option>
                </select>
                <button class="btn btn-sm btn-light"><i class="bi bi-search"></i></button>
            </form>
            <a href="{{ route('trainers.create') }}" class="btn btn-sm btn-primary"><i class="bi bi-plus-lg me-1"></i>{{ __('messages.add_trainer') }}</a>
        </div>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead>
                    <tr>
                        <th>{{ __('messages.trainer_name') }}</th>
                        <th>{{ __('messages.phone') }}</th>
                        <th>{{ __('messages.specialization') }}</th>
                        <th>{{ __('messages.salary') }}</th>
                        <th>{{ __('messages.status') }}</th>
                        <th class="text-end">{{ __('messages.actions') }}</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($trainers as $trainer)
                    <tr>
                        <td>
                            <div class="d-flex align-items-center gap-2">
                                @if($trainer->photo)
                                <img src="{{ asset('storage/' . $trainer->photo) }}" class="rounded-circle" width="34" height="34" style="object-fit:cover">
                                @else
                                <div class="rounded-circle d-flex align-items-center justify-content-center" style="width:34px;height:34px;background:var(--accent-light);color:var(--accent)">
                                    <i class="bi bi-person-badge" style="font-size:.85rem"></i>
                                </div>
                                @endif
                                <span class="fw-semibold" style="font-size:.85rem">{{ $trainer->name }}</span>
                            </div>
                        </td>
                        <td style="font-size:.85rem">{{ $trainer->phone ?? '—' }}</td>
                        <td><span class="badge" style="background:var(--sky-light);color:var(--sky)">{{ $trainer->specialization ?? '—' }}</span></td>
                        <td class="fw-bold" style="font-size:.85rem">{{ number_format($trainer->salary) }}</td>
                        <td><span class="badge {{ $trainer->status === 'active' ? 'badge-active' : 'badge-expired' }}">{{ __('messages.' . $trainer->status) }}</span></td>
                        <td class="text-end">
                            <a href="{{ route('trainers.show', $trainer) }}" class="btn btn-sm btn-light"><i class="bi bi-eye"></i></a>
                            <a href="{{ route('trainers.edit', $trainer) }}" class="btn btn-sm btn-light"><i class="bi bi-pencil" style="color:var(--accent)"></i></a>
                            <form action="{{ route('trainers.destroy', $trainer) }}" method="POST" class="d-inline" onsubmit="return confirm('{{ __('messages.confirm_delete') }}')">
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
    @if($trainers->hasPages())
    <div class="card-body border-top py-2">{{ $trainers->links() }}</div>
    @endif
</div>
@endsection
