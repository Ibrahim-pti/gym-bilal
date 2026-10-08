<!DOCTYPE html>
<html lang="ku" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>چوونەژوورەوە — {{ \App\Models\Setting::get('gym_name', 'GYM') }}</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Arabic:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.rtl.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --primary: #0ea5e9;
            --primary-dark: #0284c7;
            --bg-deep: #0f172a;
        }
        body {
            background-color: var(--bg-deep);
            background-image: 
                radial-gradient(at 0% 0%, rgba(14, 165, 233, 0.15) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(108, 99, 255, 0.1) 0px, transparent 50%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Noto Sans Arabic', sans-serif;
            color: #f8fafc;
        }
        .login-card {
            background: rgba(30, 41, 59, 0.7);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 32px;
            width: 100%;
            max-width: 450px;
            padding: 3rem 2.5rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        }
        .gym-logo {
            width: 80px;
            height: 80px;
            background: var(--primary);
            border-radius: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: white;
            margin: 0 auto 1.5rem;
            box-shadow: 0 10px 15px -3px rgba(14, 165, 233, 0.4);
            transform: rotate(-5deg);
        }
        .login-title { font-weight: 900; font-size: 1.75rem; margin-bottom: 0.5rem; text-align: center; }
        .login-subtitle { color: #94a3b8; font-size: 0.9rem; text-align: center; margin-bottom: 2.5rem; }
        
        .form-label { font-weight: 700; font-size: 0.85rem; color: #94a3b8; margin-bottom: 0.6rem; display: block; }
        .input-group-custom { position: relative; margin-bottom: 1.5rem; }
        .input-group-custom i { position: absolute; right: 1.25rem; top: 50%; transform: translateY(-50%); color: #64748b; font-size: 1.2rem; transition: all 0.3s; }
        .form-control {
            background: rgba(15, 23, 42, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 0.85rem 3.5rem 0.85rem 1.25rem;
            color: white;
            font-weight: 600;
            transition: all 0.3s;
        }
        .form-control:focus {
            background: rgba(15, 23, 42, 0.8);
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(14, 165, 233, 0.15);
            color: white;
        }
        .form-control:focus + i { color: var(--primary); }
        
        .btn-login {
            background: var(--primary);
            border: none;
            border-radius: 16px;
            padding: 0.9rem;
            width: 100%;
            color: white;
            font-weight: 800;
            font-size: 1.1rem;
            margin-top: 1rem;
            transition: all 0.3s;
            box-shadow: 0 4px 6px -1px rgba(14, 165, 233, 0.2);
        }
        .btn-login:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(14, 165, 233, 0.3);
        }
        
        .form-check-input { background-color: rgba(255,255,255,0.1); border-color: rgba(255,255,255,0.2); cursor: pointer; }
        .form-check-input:checked { background-color: var(--primary); border-color: var(--primary); }
        .form-check-label { color: #94a3b8; font-size: 0.85rem; font-weight: 600; cursor: pointer; }
        
        .error-toast {
            background: rgba(244, 63, 94, 0.1);
            border: 1px solid rgba(244, 63, 94, 0.2);
            color: #fb7185;
            padding: 1rem;
            border-radius: 16px;
            margin-bottom: 1.5rem;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="gym-logo">
        <i class="bi bi-activity"></i>
    </div>
    <h2 class="login-title">بەخێربێیتەوە</h2>
    <p class="login-subtitle">بۆ چوونە ناو سیستەمی هۆڵ، زانیارییەکانت بنووسە</p>

    @if($errors->any())
    <div class="error-toast animate-in">
        <i class="bi bi-exclamation-triangle-fill fs-5"></i>
        <span>ئیمەیڵ یان تێپەڕەوشەکەت هەڵەیە!</span>
    </div>
    @endif

    <form method="POST" action="{{ route('login') }}">
        @csrf
        <div class="mb-4">
            <label class="form-label">ناونیشانی ئیمەیڵ</label>
            <div class="input-group-custom">
                <input type="email" name="email" class="form-control" value="{{ old('email') }}" required autofocus placeholder="admin@gym.com">
                <i class="bi bi-envelope"></i>
            </div>
        </div>

        <div class="mb-4">
            <label class="form-label">تێپەڕەوشە (Password)</label>
            <div class="input-group-custom">
                <input type="password" name="password" class="form-control" required placeholder="••••••••">
                <i class="bi bi-lock"></i>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="form-check">
                <input type="checkbox" name="remember" class="form-check-input" id="remember">
                <label class="form-check-label" for="remember">بمخەرەوە یاد</label>
            </div>
            {{-- <a href="#" class="text-primary text-decoration-none small fw-bold">وشەی نهێنیت لەبیر چووە؟</a> --}}
        </div>

        <button type="submit" class="btn btn-login">
            <i class="bi bi-box-arrow-in-left me-2"></i> چوونەژوورەوە
        </button>
    </form>
    
    <div class="text-center mt-5">
        <p class="small text-muted mb-0">سیستەمی بەڕێوبەرایەتی هۆڵ</p>
        <div class="mt-2">
            <span class="badge bg-dark rounded-pill px-3 py-2 border border-secondary" style="font-size: 0.7rem; opacity: 0.7;">V 2.0 Modernized</span>
        </div>
    </div>
</div>

</body>
</html>
