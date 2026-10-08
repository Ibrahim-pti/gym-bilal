<?php

namespace App\Http\Controllers;

use App\Models\Setting;
use Illuminate\Http\Request;

class SettingsController extends Controller
{
    public function index()
    {
        $settings = [
            'gym_name'    => Setting::get('gym_name',    config('app.name')),
            'gym_phone'   => Setting::get('gym_phone',   ''),
            'gym_address' => Setting::get('gym_address', ''),
            'currency'    => Setting::get('currency',    'IQD'),
            'language'    => Setting::get('language',    'en'),
        ];

        return view('settings.index', compact('settings'));
    }

    public function update(Request $request)
    {
        $validated = $request->validate([
            'gym_name'    => 'required|string|max:255',
            'gym_phone'   => 'nullable|string|max:30',
            'gym_address' => 'nullable|string|max:500',
            'currency'    => 'required|string|max:10',
            'language'    => 'required|in:en,ku',
        ]);

        foreach ($validated as $key => $value) {
            Setting::set($key, $value);
        }

        // Switch locale if language changed
        app()->setLocale($validated['language']);
        session(['locale' => $validated['language']]);

        return redirect()->route('settings.index')
                         ->with('success', __('messages.settings_updated'));
    }
}
