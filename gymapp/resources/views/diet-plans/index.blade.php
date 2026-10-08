@extends('layouts.app')

@section('title', 'بەرنامەی خواردن')
@section('page-title', 'بەرنامەی خواردن')

@section('content')
<div class="animate-in">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="mb-1 fw-bold text-dark">بەرنامەی خواردن</h4>
            <p class="text-muted small mb-0">بەرنامەی خواردن بۆ یاریزانانی هۆڵ دیاری بکە.</p>
        </div>
        <a href="{{ route('diet-plans.create') }}" class="btn btn-primary rounded-pill px-4 fw-bold shadow-sm">
            <i class="bi bi-plus-lg me-1"></i> زیادکردنی بەرنامە
        </a>
    </div>

    <div class="card border-0 shadow-sm" style="border-radius: 20px; overflow: hidden;">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light">
                    <tr>
                        <th class="ps-4">ناونیشان</th>
                        <th>یاریزان</th>
                        <th>ڕاهێنەر</th>
                        <th>ماوە</th>
                        <th class="text-end pe-4">کردارەکان</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($dietPlans as $plan)
                    <tr>
                        <td class="ps-4">
                            <div class="fw-bold text-primary">{{ $plan->title }}</div>
                            @if($plan->description)
                            <div class="text-muted small text-truncate" style="max-width: 250px;">{{ $plan->description }}</div>
                            @endif
                        </td>
                        <td>
                            <div class="fw-bold">{{ $plan->member->name }}</div>
                        </td>
                        <td>
                            @if($plan->trainer)
                            <span class="badge bg-light text-dark rounded-pill px-3">{{ $plan->trainer->name }}</span>
                            @else
                            <span class="text-muted small">دیاری نەکراوە</span>
                            @endif
                        </td>
                        <td>
                            <div class="small fw-bold text-muted">
                                @if($plan->start_date && $plan->end_date)
                                    {{ $plan->start_date->format('Y-m-d') }} <i class="bi bi-arrow-left small mx-1"></i> {{ $plan->end_date->format('Y-m-d') }}
                                @else
                                    <span class="text-muted">بەردەوام</span>
                                @endif
                            </div>
                        </td>
                        <td class="text-end pe-4">
                            <div class="dropdown">
                                <button class="btn btn-sm btn-light rounded-3" type="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-three-dots-vertical"></i>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0" style="border-radius: 12px;">
                                    <li><a class="dropdown-item py-2" href="{{ route('diet-plans.show', $plan) }}"><i class="bi bi-eye me-2 text-primary"></i> بینین</a></li>
                                    <li><a class="dropdown-item py-2" href="{{ route('diet-plans.edit', $plan) }}"><i class="bi bi-pencil me-2 text-warning"></i> دەستکاری</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <form action="{{ route('diet-plans.destroy', $plan) }}" method="POST" onsubmit="return confirm('ئایا دڵنیای لە سڕینەوە؟')">
                                            @csrf @method('DELETE')
                                            <button type="submit" class="dropdown-item py-2 text-danger"><i class="bi bi-trash me-2"></i> سڕینەوە</button>
                                        </form>
                                    </li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="5" class="text-center py-5 text-muted">
                            <i class="bi bi-egg fs-1 d-block mb-2"></i>
                            هیچ بەرنامەیەکی خواردن تۆمار نەکراوە
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        @if($dietPlans->hasPages())
        <div class="card-footer bg-white py-3">
            {{ $dietPlans->links() }}
        </div>
        @endif
    </div>
</div>
@endsection
