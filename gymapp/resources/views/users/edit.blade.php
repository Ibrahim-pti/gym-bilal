@extends('layouts.app')

@section('title', 'Edit User')

@section('content')
<div class="animate-in" style="max-width: 600px; margin: 0 auto;">
    <div class="d-flex align-items-center mb-4">
        <a href="{{ route('users.index') }}" class="btn btn-light me-3">
            <i class="bi bi-arrow-left"></i>
        </a>
        <h4 class="mb-0 fw-bold">Edit User: {{ $user->name }}</h4>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-body p-4">
            <form action="{{ route('users.update', $user) }}" method="POST">
                @csrf
                @method('PUT')
                <div class="mb-3">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="name" class="form-control" value="{{ $user->name }}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="email" class="form-control" value="{{ $user->email }}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Role</label>
                    <select name="role" class="form-select" required>
                        <option value="admin" {{ $user->role === 'admin' ? 'selected' : '' }}>Admin (Full Access)</option>
                        <option value="store_keeper" {{ $user->role === 'store_keeper' ? 'selected' : '' }}>Store Keeper (POS & Inventory Only)</option>
                        <option value="trainer" {{ $user->role === 'trainer' ? 'selected' : '' }}>Trainer</option>
                    </select>
                </div>
                <hr>
                <div class="mb-3">
                    <label class="form-label">New Password (Leave blank to keep current)</label>
                    <input type="password" name="password" class="form-control">
                </div>
                <div class="mb-4">
                    <label class="form-label">Confirm New Password</label>
                    <input type="password" name="password_confirmation" class="form-control">
                </div>

                <div class="pt-3 border-top d-flex justify-content-end gap-2">
                    <a href="{{ route('users.index') }}" class="btn btn-light px-4">Cancel</a>
                    <button type="submit" class="btn btn-primary px-4">Update User</button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection
