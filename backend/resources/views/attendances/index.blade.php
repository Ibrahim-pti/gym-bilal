@extends('layouts.app')
@section('title', __('messages.attendance'))
@section('page-title', __('messages.attendance'))

@section('content')
<div class="row g-3">
    {{-- Check-in Panel --}}
    <div class="col-md-4 animate-in">
        <div class="card h-100">
            <div class="card-header">
                <h6 class="mb-0 fw-bold" style="font-size:.88rem"><i class="bi bi-fingerprint me-2" style="color:var(--accent)"></i>{{ __('messages.check_in') }}</h6>
            </div>
            <div class="card-body">
                <form action="{{ route('attendances.store') }}" method="POST" id="attendanceForm">
                    @csrf
                    <div class="mb-3">
                        <label class="form-label">{{ __('messages.barcode') }}</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-upc-scan"></i></span>
                            <input type="text" name="barcode" id="barcodeInput" class="form-control bg-light" placeholder="Scan Barcode..." autofocus autocomplete="off">
                        </div>
                        <div class="form-text extra-small">Auto-submits when scanned.</div>
                    </div>

                    <div class="nav-divider my-3"></div>

                    <div class="mb-3">
                        <label class="form-label">{{ __('messages.member') }} (Manual Selection)</label>
                        <select name="member_id" class="form-select @error('member_id') is-invalid @enderror">
                            <option value="">{{ __('messages.select_member') }}</option>
                            @foreach($members as $member)
                            <option value="{{ $member->id }}">{{ $member->name }} — {{ $member->phone }}</option>
                            @endforeach
                        </select>
                        @error('member_id')<div class="invalid-feedback">{{ $message }}</div>@enderror
                    </div>
                    <button type="submit" class="btn btn-primary w-100"><i class="bi bi-box-arrow-in-right me-1"></i> {{ __('messages.check_in') }}</button>
                </form>

                <script>
                    document.getElementById('barcodeInput')?.addEventListener('keypress', function(e) {
                        if (e.key === 'Enter') {
                            e.preventDefault();
                            document.getElementById('attendanceForm').submit();
                        }
                    });
                </script>

                <div class="mt-3 pt-3 border-top d-flex justify-content-between">
                    <span class="text-muted" style="font-size:.8rem">{{ __('messages.today_attendance') }}</span>
                    <span class="fw-bold">{{ $attendances->total() }}</span>
                </div>
            </div>
        </div>
    </div>

    {{-- Table --}}
    <div class="col-md-8 animate-in">
        <div class="card h-100">
            <div class="card-header">
                <h6 class="mb-0 fw-bold" style="font-size:.88rem"><i class="bi bi-clock-history me-2" style="color:var(--accent)"></i>{{ __('messages.recent_attendance') }}</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table align-middle mb-0">
                        <thead>
                            <tr>
                                <th>{{ __('messages.member') }}</th>
                                <th>{{ __('messages.check_in') }}</th>
                                <th>{{ __('messages.check_out') }}</th>
                                <th class="text-end">{{ __('messages.actions') }}</th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse($attendances as $att)
                            <tr>
                                <td class="fw-semibold" style="font-size:.85rem">{{ $att->member->name }}</td>
                                <td>
                                    <span class="badge badge-active"><i class="bi bi-arrow-down-right me-1"></i>{{ $att->check_in->format('h:i A') }}</span>
                                    <div class="text-muted" style="font-size:.65rem">{{ $att->check_in->format('d M Y') }}</div>
                                </td>
                                <td>
                                    @if($att->check_out)
                                    <span class="badge badge-expired"><i class="bi bi-arrow-up-right me-1"></i>{{ $att->check_out->format('h:i A') }}</span>
                                    @else
                                    <span class="badge badge-pending"><i class="bi bi-circle-fill me-1" style="font-size:.3rem;vertical-align:middle"></i>{{ __('messages.active') }}</span>
                                    @endif
                                </td>
                                <td class="text-end">
                                    @if(!$att->check_out)
                                    <form action="{{ route('attendances.update', $att) }}" method="POST" class="d-inline">@csrf @method('PUT')
                                        <button type="submit" class="btn btn-sm btn-light" title="{{ __('messages.check_out') }}"><i class="bi bi-box-arrow-right" style="color:var(--rose)"></i></button>
                                    </form>
                                    @endif
                                    <form action="{{ route('attendances.destroy', $att) }}" method="POST" class="d-inline" onsubmit="return confirm('{{ __('messages.confirm_delete') }}')">@csrf @method('DELETE')
                                        <button class="btn btn-sm btn-light"><i class="bi bi-trash" style="color:var(--rose)"></i></button>
                                    </form>
                                </td>
                            </tr>
                            @empty
                            <tr><td colspan="4" class="text-center py-5 text-muted"><i class="bi bi-inbox fs-1 d-block mb-2"></i>{{ __('messages.no_records') }}</td></tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
            @if($attendances->hasPages())
            <div class="card-body border-top py-2">{{ $attendances->links() }}</div>
            @endif
        </div>
    </div>
</div>
@endsection
