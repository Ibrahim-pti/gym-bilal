@extends('layouts.app')
@section('title', __('messages.backups'))
@section('page-title', __('messages.backups'))

@section('content')
<div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="mb-0 fw-semibold">{{ __('messages.backups') }}</h5>
    <form method="POST" action="{{ route('backups.store') }}">
        @csrf
        <button type="submit" class="btn btn-primary">
            <i class="bi bi-cloud-arrow-up me-1"></i>{{ __('messages.create_backup') }}
        </button>
    </form>
</div>

<div class="card table-card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table mb-0">
                <thead>
                    <tr>
                        <th>{{ __('messages.file') }}</th>
                        <th>{{ __('messages.date') }}</th>
                        <th>{{ __('messages.size') }}</th>
                        <th>{{ __('messages.actions') }}</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($files as $file)
                    <tr>
                        <td>
                            <i class="bi bi-file-earmark-zip text-success me-2"></i>
                            <span class="small">{{ $file['name'] }}</span>
                        </td>
                        <td class="small text-muted">{{ $file['date'] }}</td>
                        <td class="small text-muted">{{ number_format($file['size'] / 1024, 1) }} KB</td>
                        <td>
                            <a href="{{ route('backups.download', $file['name']) }}"
                               class="btn btn-sm btn-outline-success me-1">
                                <i class="bi bi-download"></i>
                            </a>
                            <form method="POST" action="{{ route('backups.destroy', $file['name']) }}"
                                  class="d-inline"
                                  onsubmit="return confirm('{{ __('messages.confirm_delete') }}')">
                                @csrf @method('DELETE')
                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="4" class="text-center text-muted py-5">
                            <i class="bi bi-database-slash fs-2 d-block mb-2 opacity-50"></i>
                            {{ __('messages.no_records') }}
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
</div>
@endsection
