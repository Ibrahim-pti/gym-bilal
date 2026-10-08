<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Carbon\Carbon;

class Member extends Model
{
    protected $fillable = [
        'name', 'phone', 'balance', 'age', 'gender', 'notes', 'photo', 'barcode'
    ];

    public function subscriptions()
    {
        return $this->hasMany(Subscription::class);
    }

    public function payments()
    {
        return $this->hasMany(Payment::class);
    }

    public function attendances()
    {
        return $this->hasMany(Attendance::class);
    }

    public function sales()
    {
        return $this->hasMany(Sale::class);
    }

    public function dietPlans()
    {
        return $this->hasMany(DietPlan::class);
    }

    public function workoutPlans()
    {
        return $this->hasMany(WorkoutPlan::class);
    }

    public function activeSubscription()
    {
        return $this->hasOne(Subscription::class)->where('status', 'active')->latest();
    }

    public function latestSubscription()
    {
        return $this->hasOne(Subscription::class)->latest();
    }

    public function getStatusAttribute(): string
    {
        $active = $this->subscriptions()
            ->where('status', 'active')
            ->where('end_date', '>=', Carbon::today())
            ->exists();
        return $active ? 'active' : 'expired';
    }

    public function getActiveUntilAttribute(): ?string
    {
        $sub = $this->subscriptions()
            ->where('status', 'active')
            ->where('end_date', '>=', Carbon::today())
            ->orderBy('end_date', 'desc')
            ->first();
        return $sub ? $sub->end_date : null;
    }

    public function getActiveFromAttribute(): ?string
    {
        $sub = $this->subscriptions()
            ->where('status', 'active')
            ->latest()
            ->first();
        return $sub ? $sub->start_date : null;
    }
}
