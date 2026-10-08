<?php

namespace App\Http\Middleware;

use App\Models\Setting;
use Closure;
use Illuminate\Http\Request;

class SetLocale
{
    public function handle(Request $request, Closure $next)
    {
        // Priority: session > cookie > database setting > config
        $locale = session('locale');

        if (!$locale) {
            $locale = $request->cookie('locale');
        }

        if (!$locale) {
            try {
                $locale = Setting::get('language', config('app.locale', 'en'));
            } catch (\Throwable) {
                $locale = config('app.locale', 'en');
            }
        }

        $allowed = ['en', 'ku'];
        if (!in_array($locale, $allowed)) {
            $locale = 'en';
        }

        app()->setLocale($locale);

        return $next($request);
    }
}
