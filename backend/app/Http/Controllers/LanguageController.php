<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class LanguageController extends Controller
{
    public function switch(Request $request, string $locale)
    {
        $allowed = ['en', 'ku'];
        if (!in_array($locale, $allowed)) {
            $locale = 'en';
        }

        session(['locale' => $locale]);

        return redirect()->back()->withCookie(cookie('locale', $locale, 60 * 24 * 365));
    }
}
