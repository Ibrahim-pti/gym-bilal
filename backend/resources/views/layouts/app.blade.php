<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}" dir="{{ app()->getLocale() === 'ku' ? 'rtl' : 'ltr' }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', __('messages.gym_management')) — {{ \App\Models\Setting::get('gym_name', config('app.name')) }}</title>

    {{-- Google Fonts - Noto Sans Arabic for Kurdish --}}
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Arabic:wght@300;400;500;600;700;800&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    {{-- Bootstrap 5 RTL/LTR --}}
    @if(app()->getLocale() === 'ku')
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.rtl.min.css">
    @else
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    @endif
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script>
        // Load theme before render to avoid flash
        (function(){var c=document.cookie.split(';').find(function(x){return x.trim().startsWith('app_theme=')});if(c){document.documentElement.setAttribute('data-theme',c.split('=')[1])}})();
    </script>

    <style>
        :root, [data-theme="indigo"] {
            --sidebar-width: 260px;
            /* Core accent */
            --accent: #6C63FF;
            --accent-soft: #818CF8;
            --accent-light: #EEF2FF;
            --accent-dark: #4F46E5;
            --accent-glow: rgba(108, 99, 255, .1);
            /* Sidebar */
            --sidebar-from: #0F172A;
            --sidebar-via: #1A1F3A;
            --sidebar-to: #1E1B4B;
            --brand-bg: rgba(108, 99, 255, .08);
            --brand-border: rgba(108, 99, 255, .12);
            --active-from: rgba(108,99,255,.25);
            --active-to: rgba(129,140,248,.15);
            --active-border: rgba(108,99,255,.2);
            --active-icon: #A5B4FC;
            --sidebar-text: rgba(255,255,255,.65);
            --sidebar-text-dim: rgba(255,255,255,.3);
            --brand-text: #E0E7FF;
            /* Stat card gradients */
            --stat-1-from: #6C63FF; --stat-1-to: #A78BFA;
            --stat-2-from: #818CF8; --stat-2-to: #C4B5FD;
            --stat-3-from: #4F46E5; --stat-3-to: #818CF8;
            --stat-4-from: #6366F1; --stat-4-to: #A5B4FC;
            /* Topbar */
            --topbar-bg: #FFFFFF;
            --topbar-border: #E8ECF1;
            /* Semantic */
            --success: #10B981; --success-light: #ECFDF5;
            --danger: #F43F5E;  --danger-light: #FFF1F2;
            --warning: #F59E0B; --warning-light: #FFFBEB;
            --info: #0EA5E9;    --info-light: #F0F9FF;
            /* Surface */
            --surface: #FFFFFF;
            --bg: #F8F9FC;
            --border: #E8ECF1;
            --text: #111827;
            --text-muted: #6B7280;
            --radius: 14px;
            --radius-sm: 10px;
            --radius-xs: 7px;
        }
        [data-theme="emerald"] {
            --accent: #059669; --accent-soft: #34D399; --accent-light: #ECFDF5; --accent-dark: #047857;
            --accent-glow: rgba(5,150,105,.1);
            --sidebar-from: #022C22; --sidebar-via: #064E3B; --sidebar-to: #065F46;
            --brand-bg: rgba(16,185,129,.1); --brand-border: rgba(16,185,129,.15);
            --active-from: rgba(16,185,129,.25); --active-to: rgba(52,211,153,.15);
            --active-border: rgba(16,185,129,.2); --active-icon: #6EE7B7;
            --sidebar-text: rgba(255,255,255,.7); --sidebar-text-dim: rgba(255,255,255,.3); --brand-text: #D1FAE5;
            --stat-1-from: #059669; --stat-1-to: #34D399;
            --stat-2-from: #10B981; --stat-2-to: #6EE7B7;
            --stat-3-from: #047857; --stat-3-to: #34D399;
            --stat-4-from: #059669; --stat-4-to: #A7F3D0;
            --bg: #F7FDF9;
        }
        [data-theme="rose"] {
            --accent: #E11D48; --accent-soft: #FB7185; --accent-light: #FFF1F2; --accent-dark: #BE123C;
            --accent-glow: rgba(225,29,72,.1);
            --sidebar-from: #1C1017; --sidebar-via: #2D1320; --sidebar-to: #3B1226;
            --brand-bg: rgba(244,63,94,.1); --brand-border: rgba(244,63,94,.15);
            --active-from: rgba(244,63,94,.25); --active-to: rgba(251,113,133,.15);
            --active-border: rgba(244,63,94,.2); --active-icon: #FDA4AF;
            --sidebar-text: rgba(255,255,255,.7); --sidebar-text-dim: rgba(255,255,255,.3); --brand-text: #FECDD3;
            --stat-1-from: #E11D48; --stat-1-to: #FB7185;
            --stat-2-from: #F43F5E; --stat-2-to: #FDA4AF;
            --stat-3-from: #BE123C; --stat-3-to: #FB7185;
            --stat-4-from: #E11D48; --stat-4-to: #FECDD3;
            --bg: #FFFBFB;
        }
        [data-theme="amber"] {
            --accent: #D97706; --accent-soft: #FBBF24; --accent-light: #FFFBEB; --accent-dark: #B45309;
            --accent-glow: rgba(217,119,6,.1);
            --sidebar-from: #1C1407; --sidebar-via: #2D1F09; --sidebar-to: #3D2A0A;
            --brand-bg: rgba(245,158,11,.1); --brand-border: rgba(245,158,11,.15);
            --active-from: rgba(245,158,11,.25); --active-to: rgba(251,191,36,.15);
            --active-border: rgba(245,158,11,.2); --active-icon: #FCD34D;
            --sidebar-text: rgba(255,255,255,.7); --sidebar-text-dim: rgba(255,255,255,.3); --brand-text: #FEF3C7;
            --stat-1-from: #D97706; --stat-1-to: #FBBF24;
            --stat-2-from: #F59E0B; --stat-2-to: #FCD34D;
            --stat-3-from: #B45309; --stat-3-to: #FBBF24;
            --stat-4-from: #D97706; --stat-4-to: #FDE68A;
            --bg: #FFFCF5;
        }
        [data-theme="sky"] {
            --accent: #0284C7; --accent-soft: #38BDF8; --accent-light: #F0F9FF; --accent-dark: #0369A1;
            --accent-glow: rgba(2,132,199,.1);
            --sidebar-from: #0C1929; --sidebar-via: #0C3547; --sidebar-to: #0C4A6E;
            --brand-bg: rgba(14,165,233,.1); --brand-border: rgba(14,165,233,.15);
            --active-from: rgba(14,165,233,.25); --active-to: rgba(56,189,248,.15);
            --active-border: rgba(14,165,233,.2); --active-icon: #7DD3FC;
            --sidebar-text: rgba(255,255,255,.7); --sidebar-text-dim: rgba(255,255,255,.3); --brand-text: #E0F2FE;
            --stat-1-from: #0284C7; --stat-1-to: #38BDF8;
            --stat-2-from: #0EA5E9; --stat-2-to: #7DD3FC;
            --stat-3-from: #0369A1; --stat-3-to: #38BDF8;
            --stat-4-from: #0284C7; --stat-4-to: #BAE6FD;
            --bg: #F5FBFF;
        }
        [data-theme="slate"] {
            --accent: #475569; --accent-soft: #94A3B8; --accent-light: #F1F5F9; --accent-dark: #334155;
            --accent-glow: rgba(71,85,105,.1);
            --sidebar-from: #0F172A; --sidebar-via: #1E293B; --sidebar-to: #1E293B;
            --brand-bg: rgba(148,163,184,.1); --brand-border: rgba(148,163,184,.15);
            --active-from: rgba(148,163,184,.2); --active-to: rgba(203,213,225,.1);
            --active-border: rgba(148,163,184,.15); --active-icon: #CBD5E1;
            --sidebar-text: rgba(255,255,255,.65); --sidebar-text-dim: rgba(255,255,255,.25); --brand-text: #E2E8F0;
            --stat-1-from: #475569; --stat-1-to: #94A3B8;
            --stat-2-from: #64748B; --stat-2-to: #CBD5E1;
            --stat-3-from: #334155; --stat-3-to: #94A3B8;
            --stat-4-from: #475569; --stat-4-to: #E2E8F0;
            --bg: #F8FAFC;
        }
        [data-theme="default"] {
            --accent: #374151; --accent-soft: #6B7280; --accent-light: #F3F4F6; --accent-dark: #1F2937;
            --accent-glow: rgba(55,65,81,.1);
            --sidebar-from: #111827; --sidebar-via: #1F2937; --sidebar-to: #1F2937;
            --brand-bg: rgba(255,255,255,.06); --brand-border: rgba(255,255,255,.08);
            --active-from: rgba(255,255,255,.1); --active-to: rgba(255,255,255,.05);
            --active-border: rgba(255,255,255,.1); --active-icon: #D1D5DB;
            --sidebar-text: rgba(255,255,255,.65); --sidebar-text-dim: rgba(255,255,255,.25); --brand-text: #F9FAFB;
            --stat-1-from: #1F2937; --stat-1-to: #4B5563;
            --stat-2-from: #374151; --stat-2-to: #6B7280;
            --stat-3-from: #111827; --stat-3-to: #374151;
            --stat-4-from: #1F2937; --stat-4-to: #9CA3AF;
            --bg: #F9FAFB;
        }

        * { box-sizing: border-box; margin: 0; }

        body {
            background: var(--bg);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            color: var(--text);
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }
        html[dir=rtl] body {
            font-family: 'Noto Sans Arabic', 'Inter', -apple-system, sans-serif;
        }

        /* ─── Custom Scrollbar ─── */
        ::-webkit-scrollbar { width: 5px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #D1D5DB; border-radius: 10px; }

        /* ═══════════════════════════════════════════
           SIDEBAR
        ═══════════════════════════════════════════ */
        .sidebar {
            position: fixed; top: 0; bottom: 0;
            width: var(--sidebar-width);
            background: linear-gradient(180deg, var(--sidebar-from) 0%, var(--sidebar-via) 50%, var(--sidebar-to) 100%);
            z-index: 1000;
            display: flex; flex-direction: column;
            overflow-y: auto;
            transition: transform .35s cubic-bezier(.4,0,.2,1);
        }
        html[dir=ltr] .sidebar { left: 0; }
        html[dir=rtl] .sidebar { right: 0; }

        /* Brand */
        .sidebar-brand {
            padding: 1.35rem 1.2rem;
            display: flex; align-items: center; gap: .7rem;
            margin: .6rem .6rem 0;
            background: var(--brand-bg);
            border: 1px solid var(--brand-border);
            border-radius: var(--radius-sm);
        }
        .brand-logo {
            width: 38px; height: 38px;
            background: linear-gradient(135deg, var(--accent), var(--active-icon));
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem; color: #fff;
            flex-shrink: 0;
        }
        .brand-name {
            color: var(--brand-text); font-weight: 700; font-size: .88rem;
            line-height: 1.3; white-space: nowrap;
            overflow: hidden; text-overflow: ellipsis;
        }

        /* Nav */
        .sidebar-nav { padding: .5rem 0; flex: 1; margin-top: .3rem; }
        .nav-section {
            color: var(--sidebar-text-dim);
            font-size: .6rem; font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .12em;
            padding: .9rem 1.2rem .3rem;
        }
        .nav-item { margin: 2px .6rem; }
        .nav-link {
            color: var(--sidebar-text);
            border-radius: 8px;
            padding: .5rem .85rem;
            font-size: .8rem; font-weight: 500;
            display: flex; align-items: center; gap: .65rem;
            transition: all .18s ease;
            text-decoration: none;
            position: relative;
        }
        .nav-link:hover {
            color: #fff;
            background: rgba(255,255,255,.07);
        }
        .nav-link.active {
            color: #fff;
            background: linear-gradient(135deg, var(--active-from), var(--active-to));
            border: 1px solid var(--active-border);
        }
        .nav-link:not(.active) { border: 1px solid transparent; }
        .nav-link i { width: 1.1rem; text-align: center; font-size: .9rem; opacity: .8; }
        .nav-link.active i { opacity: 1; color: var(--active-icon); }
        .nav-badge {
            margin-inline-start: auto;
            background: var(--rose);
            color: #fff; font-size: .58rem; font-weight: 700;
            padding: .1rem .4rem; border-radius: 10px;
            min-width: 1.1rem; text-align: center; line-height: 1.3;
        }

        /* Sidebar divider */
        .nav-divider {
            height: 1px;
            background: rgba(255,255,255,.04);
            margin: .5rem 1.2rem;
        }

        /* Footer */
        .sidebar-footer {
            padding: .7rem .8rem;
            margin: 0 .2rem .3rem;
        }
        .sidebar-footer .btn {
            border-radius: 8px; font-weight: 500; font-size: .76rem;
            border: 1px solid rgba(255,255,255,.1);
            color: var(--sidebar-text);
            background: rgba(255,255,255,.04);
            padding: .45rem;
        }
        .sidebar-footer .btn:hover {
            border-color: var(--active-border);
            color: var(--active-icon);
            background: rgba(255,255,255,.08);
        }

        /* ═══════════════════════════════════════════
           MAIN WRAPPER
        ═══════════════════════════════════════════ */
        .main-wrapper {
            min-height: 100vh; display: flex; flex-direction: column;
        }
        html[dir=ltr] .main-wrapper { margin-left: var(--sidebar-width); }
        html[dir=rtl] .main-wrapper { margin-right: var(--sidebar-width); }

        /* ═══════════════════════════════════════════
           TOPBAR
        ═══════════════════════════════════════════ */
        .topbar {
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            padding: .65rem 1.6rem;
            display: flex; align-items: center; justify-content: space-between;
            position: sticky; top: 0; z-index: 99;
        }
        .topbar-title { font-size: 1rem; font-weight: 700; color: var(--text); }
        .topbar-actions { display: flex; align-items: center; gap: .4rem; }
        .topbar-user {
            display: flex; align-items: center; gap: .45rem;
            padding: .3rem .7rem;
            border-radius: var(--radius-xs);
            background: var(--bg); font-size: .8rem; font-weight: 500;
        }
        .topbar-user i { color: var(--accent); font-size: .9rem; }

        /* ═══════════════════════════════════════════
           CONTENT
        ═══════════════════════════════════════════ */
        .content-area { padding: 1.4rem 1.6rem; flex: 1; }

        /* ═══════════════════════════════════════════
           CARDS  —  FLAT, NO SHADOW
        ═══════════════════════════════════════════ */
        .card {
            border: 1px solid var(--border);
            border-radius: var(--radius);
            background: var(--surface);
            box-shadow: none;
            transition: border-color .2s;
        }
        .card:hover { border-color: #D1D5DB; }
        .card-header {
            background: transparent;
            border-bottom: 1px solid var(--border);
            padding: .9rem 1.2rem;
        }

        /* Stat cards */
        .stat-card {
            border: none; border-radius: var(--radius);
            position: relative; overflow: hidden;
            box-shadow: none;
        }
        .stat-card .card-body { padding: 1.2rem 1.4rem; position: relative; z-index: 1; }
        .stat-icon {
            width: 2.8rem; height: 2.8rem;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.25rem;
            background: rgba(255,255,255,.2);
        }

        /* ═══════════════════════════════════════════
           TABLES  —  CLEAN
        ═══════════════════════════════════════════ */
        .table { margin-bottom: 0; }
        .table thead th {
            font-size: .72rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: .07em;
            color: var(--text-muted);
            border-bottom: 1px solid var(--border);
            background: #FAFBFC;
            padding: .7rem 1rem;
        }
        .table tbody td { padding: .7rem 1rem; vertical-align: middle; font-size: .85rem; }
        .table tbody tr { border-bottom: 1px solid #F3F4F6; transition: background .15s; }
        .table tbody tr:last-child { border-bottom: none; }
        .table tbody tr:hover { background: #FAFBFC; }

        /* ═══════════════════════════════════════════
           BADGES
        ═══════════════════════════════════════════ */
        .badge { font-weight: 600; border-radius: 6px; font-size: .72rem; padding: .25rem .55rem; }
        .badge-active { background: var(--success-light); color: #065F46; }
        .badge-expired { background: var(--danger-light); color: #9F1239; }
        .badge-pending { background: var(--warning-light); color: #92400E; }

        /* ═══════════════════════════════════════════
           BUTTONS
        ═══════════════════════════════════════════ */
        .btn {
            border-radius: var(--radius-xs); font-weight: 500;
            font-size: .85rem; box-shadow: none !important;
            transition: all .2s;
        }
        .btn-primary { background: var(--accent); border-color: var(--accent); }
        .btn-primary:hover { background: var(--accent-dark); border-color: var(--accent-dark); transform: translateY(-1px); }
        .btn-light { background: #F3F4F6; border-color: #F3F4F6; color: var(--text); }
        .btn-light:hover { background: #E5E7EB; border-color: #E5E7EB; }

        /* ═══════════════════════════════════════════
           FORMS
        ═══════════════════════════════════════════ */
        .form-control, .form-select {
            border-radius: var(--radius-xs);
            border: 1px solid var(--border);
            font-size: .85rem; padding: .5rem .8rem;
            box-shadow: none !important;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--accent);
            outline: 3px solid var(--accent-glow);
        }
        .form-label { font-weight: 500; font-size: .82rem; color: var(--text); margin-bottom: .3rem; }

        /* ═══════════════════════════════════════════
           ALERTS
        ═══════════════════════════════════════════ */
        .alert { border-radius: var(--radius-xs); border: none; font-size: .85rem; font-weight: 500; box-shadow: none; }
        .alert-success { background: var(--success-light); color: #065F46; }
        .alert-danger { background: var(--danger-light); color: #9F1239; }

        /* ═══════════════════════════════════════════
           THEME DOTS
        ═══════════════════════════════════════════ */
        .theme-dot {
            width: 28px; height: 28px;
            border-radius: 50%;
            border: 2px solid transparent;
            cursor: pointer;
            transition: all .2s;
            outline: none;
            position: relative;
        }
        .theme-dot:hover { transform: scale(1.15); }
        .theme-dot.active {
            border-color: var(--text);
            outline: 2px solid var(--surface);
            outline-offset: -3px;
        }

        /* ═══════════════════════════════════════════
           PAGINATION
        ═══════════════════════════════════════════ */
        .pagination { margin-bottom: 0; }
        .page-link { border-radius: var(--radius-xs) !important; margin: 0 2px; font-size: .82rem; box-shadow: none !important; }

        /* ═══════════════════════════════════════════
           ANIMATIONS
        ═══════════════════════════════════════════ */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-in { animation: fadeIn .35s ease forwards; }
        .animate-in:nth-child(2) { animation-delay: .04s; }
        .animate-in:nth-child(3) { animation-delay: .08s; }
        .animate-in:nth-child(4) { animation-delay: .12s; }
        .animate-in:nth-child(5) { animation-delay: .16s; }
        .animate-in:nth-child(6) { animation-delay: .2s; }
        .animate-in:nth-child(7) { animation-delay: .24s; }
        .animate-in:nth-child(8) { animation-delay: .28s; }

        /* ═══════════════════════════════════════════
           DROPDOWN
        ═══════════════════════════════════════════ */
        .dropdown-menu {
            border: 1px solid var(--border);
            border-radius: var(--radius-xs);
            box-shadow: none;
            padding: .3rem;
        }
        .dropdown-item {
            border-radius: 6px; font-size: .82rem; padding: .4rem .8rem;
        }
        .dropdown-item:hover { background: var(--bg); }

        /* ═══════════════════════════════════════════
           RESPONSIVE
        ═══════════════════════════════════════════ */
        @media (max-width: 991px) {
            .sidebar { transform: translateX(-100%); }
            html[dir=rtl] .sidebar { transform: translateX(100%); }
            .sidebar.show { transform: translateX(0); }
            html[dir=ltr] .main-wrapper { margin-left: 0; }
            html[dir=rtl] .main-wrapper { margin-right: 0; }
            .content-area { padding: 1rem; }
        }
        .sidebar-backdrop {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,.4); z-index: 999;
        }
        .sidebar-backdrop.show { display: block; }
    </style>
    @stack('styles')
</head>
<body>

{{-- Backdrop --}}
<div class="sidebar-backdrop" id="sidebarBackdrop"></div>

{{-- Sidebar --}}
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="brand-logo"><i class="bi bi-lightning-charge-fill"></i></div>
        <div class="brand-name">{{ \App\Models\Setting::get('gym_name', config('app.name')) }}</div>
    </div>

    <nav class="sidebar-nav">
        {{-- 1. یاریزانان و ئامادەبوون --}}
        @if(auth()->user()->role === 'admin')
        <div class="nav-section">یاریزانان و ئامادەبوون</div>
        <div class="nav-item">
            <a href="{{ route('members.index') }}" class="nav-link {{ request()->routeIs('members.*') ? 'active' : '' }}">
                <i class="bi bi-people-fill"></i> یاریزانەکان
            </a>
        </div>
        <div class="nav-item">
            <a href="{{ route('attendances.index') }}" class="nav-link {{ request()->routeIs('attendances.*') ? 'active' : '' }}">
                <i class="bi bi-fingerprint"></i> ئامادەبوونی یاریزانان
            </a>
        </div>
        <div class="nav-divider"></div>
        @endif

        {{-- 2. کۆگا و فرۆشتن --}}
        <div class="nav-section">کۆگا و فرۆشتن</div>
        @if(auth()->user()->role === 'store_keeper')
        <div class="nav-item">
            <a href="{{ route('sales.create') }}" class="nav-link {{ request()->routeIs('sales.create') ? 'active' : '' }}">
                <i class="bi bi-cart-fill"></i> خاڵی فرۆشتن (POS)
            </a>
        </div>
        <div class="nav-item">
            <a href="{{ route('products.index') }}" class="nav-link {{ request()->routeIs('products.*') ? 'active' : '' }}">
                <i class="bi bi-box-seam-fill"></i> کۆگای بەرهەمەکان
            </a>
        </div>
        @endif
        @if(auth()->user()->role === 'admin')
        <div class="nav-item">
            <a href="{{ route('sales.index') }}" class="nav-link {{ request()->routeIs('sales.index') ? 'active' : '' }}">
                <i class="bi bi-receipt"></i> ڕاپۆرتی فرۆشتنەکان
            </a>
        </div>
        @endif
        <div class="nav-divider"></div>

        {{-- 3. بەرنامەکانی ڕاهێنان --}}
        @if(auth()->user()->role === 'admin')
        <div class="nav-section">بەرنامەکانی ڕاهێنان</div>
        <div class="nav-item">
            <a href="{{ route('diet-plans.index') }}" class="nav-link {{ request()->routeIs('diet-plans.*') ? 'active' : '' }}">
                <i class="bi bi-egg-fill"></i> بەرنامەی خواردن
            </a>
        </div>
        <div class="nav-item">
            <a href="{{ route('workout-plans.index') }}" class="nav-link {{ request()->routeIs('workout-plans.*') ? 'active' : '' }}">
                <i class="bi bi-fire"></i> بەرنامەی ڕاهێنان
            </a>
        </div>
        <div class="nav-divider"></div>

        {{-- 4. دارایی و ڕاپۆرتەکان --}}
        <div class="nav-section">دارایی و ڕاپۆرتەکان</div>
        <div class="nav-item">
            <a href="{{ route('payments.index') }}" class="nav-link {{ request()->routeIs('payments.*') ? 'active' : '' }}">
                <i class="bi bi-cash-coin"></i> پارەدانەکان
            </a>
        </div>
        <div class="nav-item">
            <a href="{{ route('expenses.index') }}" class="nav-link {{ request()->routeIs('expenses.*') ? 'active' : '' }}">
                <i class="bi bi-wallet2"></i> خەرجییەکان
            </a>
        </div>
        <div class="nav-item">
            <a href="{{ route('dashboard') }}" class="nav-link {{ request()->routeIs('dashboard') ? 'active' : '' }}">
                <i class="bi bi-bar-chart-line-fill"></i> ڕاپۆرتە گشتییەکان (Dashboard)
            </a>
        </div>
        <div class="nav-divider"></div>

        {{-- 5. بەڕێوەبردنی ستاف و ئامێر --}}
        <div class="nav-section">بەڕێوەبردنی ستاف و ئامێر</div>
        <div class="nav-item">
            <a href="{{ route('trainers.index') }}" class="nav-link {{ request()->routeIs('trainers.*') ? 'active' : '' }}">
                <i class="bi bi-person-badge-fill"></i> ڕاهێنەرەکان
            </a>
        </div>
        <div class="nav-item">
            <a href="{{ route('equipment.index') }}" class="nav-link {{ request()->routeIs('equipment.*') ? 'active' : '' }}">
                <i class="bi bi-tools"></i> ئامێرەکان
            </a>
        </div>
        <div class="nav-divider"></div>

        {{-- 6. ڕێکخستنەکانی سیستەم --}}
        <div class="nav-section">ڕێکخستنەکانی سیستەم</div>
        <div class="nav-item">
            <a href="{{ route('users.index') }}" class="nav-link {{ request()->routeIs('users.*') ? 'active' : '' }}">
                <i class="bi bi-person-gear"></i> بەکارهێنەرانی سیستەم
            </a>
        </div>
        <div class="nav-item">
            <a href="{{ route('settings.index') }}" class="nav-link {{ request()->routeIs('settings.*') ? 'active' : '' }}">
                <i class="bi bi-gear-fill"></i> ڕێکخستنی گشتی
            </a>
        </div>
        @endif
    </nav>

    <div class="sidebar-footer">
        <form method="POST" action="{{ route('logout') }}">
            @csrf
            <button type="submit" class="btn btn-sm btn-outline-light w-100">
                <i class="bi bi-box-arrow-right me-1"></i> {{ __('messages.logout') }}
            </button>
        </form>
    </div>
</aside>

{{-- Main --}}
<div class="main-wrapper">
    <div class="topbar">
        <div class="d-flex align-items-center gap-2">
            <button class="btn btn-sm btn-light d-lg-none" id="sidebarToggle"><i class="bi bi-list fs-5"></i></button>
            <span class="topbar-title">@yield('page-title', __('messages.dashboard'))</span>
        </div>
        <div class="topbar-actions">
            {{-- Theme Picker --}}
            <div class="dropdown">
                <button class="btn btn-sm btn-light" type="button" data-bs-toggle="dropdown" title="{{ __('messages.theme') }}">
                    <i class="bi bi-palette-fill" style="color: var(--accent)"></i>
                </button>
                <ul class="dropdown-menu dropdown-menu-end p-2" style="min-width:180px">
                    <li class="px-2 pb-1"><small class="text-muted fw-bold" style="font-size:.68rem">{{ __('messages.choose_theme') }}</small></li>
                    <li>
                        <div class="d-flex flex-wrap gap-2 px-1">
                            <button class="theme-dot" data-theme="default" title="سەرەکی" style="background:linear-gradient(135deg,#1F2937,#6B7280)"></button>
                            <button class="theme-dot" data-theme="indigo" title="نێلی" style="background:linear-gradient(135deg,#6C63FF,#818CF8)"></button>
                            <button class="theme-dot" data-theme="emerald" title="زمروود" style="background:linear-gradient(135deg,#059669,#34D399)"></button>
                            <button class="theme-dot" data-theme="rose" title="گوڵی" style="background:linear-gradient(135deg,#E11D48,#FB7185)"></button>
                            <button class="theme-dot" data-theme="amber" title="کەهرەبا" style="background:linear-gradient(135deg,#D97706,#FBBF24)"></button>
                            <button class="theme-dot" data-theme="sky" title="ئاسمانی" style="background:linear-gradient(135deg,#0284C7,#38BDF8)"></button>
                            <button class="theme-dot" data-theme="slate" title="ڕەساسی" style="background:linear-gradient(135deg,#475569,#94A3B8)"></button>
                        </div>
                    </li>
                </ul>
            </div>
            {{-- Language Picker --}}
            <div class="dropdown">
                <button class="btn btn-sm btn-light dropdown-toggle" type="button" data-bs-toggle="dropdown">
                    <i class="bi bi-translate me-1"></i>{{ app()->getLocale() === 'ku' ? 'کوردی' : 'EN' }}
                </button>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="{{ route('lang.switch', 'en') }}">🇬🇧 English</a></li>
                    <li><a class="dropdown-item" href="{{ route('lang.switch', 'ku') }}">🇮🇶 کوردی</a></li>
                </ul>
            </div>
            <div class="topbar-user">
                <i class="bi bi-person-circle"></i>
                <span>{{ auth()->user()->name }}</span>
            </div>
        </div>
    </div>

    <div class="content-area">
        @if(session('success'))
        <div class="alert alert-success alert-dismissible fade show mb-3" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>{{ session('success') }}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        @endif
        @if(session('error'))
        <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
            <i class="bi bi-exclamation-circle-fill me-2"></i>{{ session('error') }}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        @endif
        @yield('content')
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Sidebar toggle
const sidebar = document.getElementById('sidebar');
const backdrop = document.getElementById('sidebarBackdrop');
document.getElementById('sidebarToggle')?.addEventListener('click', () => {
    sidebar.classList.toggle('show');
    backdrop.classList.toggle('show');
});
backdrop?.addEventListener('click', () => {
    sidebar.classList.remove('show');
    backdrop.classList.remove('show');
});

// Theme system
(function() {
    const saved = document.cookie.split(';').find(c => c.trim().startsWith('app_theme='));
    if (saved) {
        const t = saved.split('=')[1];
        document.documentElement.setAttribute('data-theme', t);
    }
    document.querySelectorAll('.theme-dot').forEach(btn => {
        btn.addEventListener('click', function() {
            const theme = this.dataset.theme;
            document.documentElement.setAttribute('data-theme', theme);
            document.cookie = 'app_theme=' + theme + ';path=/;max-age=31536000';
            document.querySelectorAll('.theme-dot').forEach(d => d.classList.remove('active'));
            this.classList.add('active');
        });
    });
    // Mark active
    const current = document.documentElement.getAttribute('data-theme') || 'indigo';
    document.querySelector('.theme-dot[data-theme="' + current + '"]')?.classList.add('active');
})();
</script>
@stack('scripts')
</body>
</html>
