@extends('layouts.app')
@section('title', __('messages.expenses'))
@section('page-title', __('messages.expenses'))

@section('content')
<div class="row g-3 mb-3">
    <div class="col-md-4 animate-in">
        <div class="card stat-card" style="background: linear-gradient(135deg,#F43F5E,#FB7185); color:#fff;">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon"><i class="bi bi-wallet2 text-white"></i></div>
                <div>
                    <div class="fs-3 fw-bold">{{ number_format($totalExpenses, 2) }}</div>
                    <div class="small opacity-85">{{ __('messages.total_expenses') }}</div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="card animate-in">
    <div class="card-header d-flex flex-wrap justify-content-between align-items-center gap-2">
        <h6 class="mb-0 fw-bold" style="font-size:.88rem">{{ __('messages.expenses_list') }}</h6>
        <a href="{{ route('expenses.create') }}" class="btn btn-sm btn-primary"><i class="bi bi-plus-lg me-1"></i>{{ __('messages.add_expense') }}</a>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead>
                    <tr>
                        <th>{{ __('messages.date') }}</th>
                        <th>{{ __('messages.title') }}</th>
                        <th>{{ __('messages.amount') }}</th>
                        <th>{{ __('messages.description') }}</th>
                        <th class="text-end">{{ __('messages.actions') }}</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($expenses as $expense)
                    <tr>
                        <td class="text-muted" style="font-size:.82rem">{{ $expense->date }}</td>
                        <td class="fw-semibold" style="font-size:.85rem">{{ $expense->title }}</td>
                        <td class="fw-bold" style="color:var(--rose)">-{{ number_format($expense->amount, 2) }}</td>
                        <td class="text-muted" style="font-size:.82rem">{{ Str::limit($expense->description, 50) }}</td>
                        <td class="text-end">
                            <a href="{{ route('expenses.edit', $expense) }}" class="btn btn-sm btn-light"><i class="bi bi-pencil" style="color:var(--accent)"></i></a>
                            <form action="{{ route('expenses.destroy', $expense) }}" method="POST" class="d-inline" onsubmit="return confirm('{{ __('messages.confirm_delete') }}')">
                                @csrf @method('DELETE')
                                <button class="btn btn-sm btn-light"><i class="bi bi-trash" style="color:var(--rose)"></i></button>
                            </form>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="5" class="text-center py-5 text-muted">
                            <i class="bi bi-inbox fs-1 d-block mb-2"></i>{{ __('messages.no_records') }}
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
    @if($expenses->hasPages())
    <div class="card-body border-top py-2">{{ $expenses->links() }}</div>
    @endif
</div>
@endsection
