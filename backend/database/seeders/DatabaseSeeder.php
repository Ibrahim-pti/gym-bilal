<?php

namespace Database\Seeders;

use App\Models\Setting;
use App\Models\SubscriptionPlan;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Admin user
        User::updateOrCreate(
            ['email' => 'admin@gym.com'],
            [
                'name'     => 'Admin',
                'password' => Hash::make('password'),
                'role'     => 'admin',
            ]
        );

        // Store Keeper user (Seller)
        User::updateOrCreate(
            ['email' => 'seller@gym.com'],
            [
                'name'     => 'Seller Account',
                'password' => Hash::make('password'),
                'role'     => 'store_keeper',
            ]
        );

        // Default subscription plans
        $plans = [
            ['name' => 'Monthly',  'price' => 25000, 'duration_days' => 30,  'type' => 'monthly', 'description' => '1 Month membership'],
            ['name' => '3 Months', 'price' => 60000, 'duration_days' => 90,  'type' => 'custom',  'description' => '3 Month membership'],
            ['name' => '6 Months', 'price' => 100000,'duration_days' => 180, 'type' => 'custom',  'description' => '6 Month membership'],
            ['name' => 'Yearly',   'price' => 180000,'duration_days' => 365, 'type' => 'yearly',  'description' => '1 Year membership'],
        ];

        foreach ($plans as $plan) {
            SubscriptionPlan::firstOrCreate(['name' => $plan['name']], $plan);
        }

        // Default settings
        $settings = [
            'gym_name'    => 'My Gym',
            'gym_phone'   => '',
            'gym_address' => '',
            'currency'    => 'IQD',
            'language'    => 'en',
        ];

        foreach ($settings as $key => $value) {
            Setting::firstOrCreate(['key' => $key], ['value' => $value]);
        }
    }
}

