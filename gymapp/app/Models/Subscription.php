<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Carbon\Carbon;

class Subscription extends Model
{
    protected $fillable = [
        'member_id', 'subscription_plan_id', 'start_date', 'end_date',
        'status', 'amount_paid', 'notes'
    ];

    protected $casts = [
        'start_date' => 'date',
        'end_date' => 'date',
        'amount_paid' => 'decimal:2',
    ];

    protected static function booted()
    {
        static::saving(function ($subscription) {
            if ($subscription->end_date < Carbon::today()) {
                $subscription->status = 'expired';
            }
        });
    }

    public function member()
    {
        return $this->belongsTo(Member::class);
    }

    public function plan()
    {
        return $this->belongsTo(SubscriptionPlan::class, 'subscription_plan_id');
    }

    public function payments()
    {
        return $this->hasMany(Payment::class);
    }

    public function getDaysRemainingAttribute(): int
    {
        return max(0, Carbon::today()->diffInDays($this->end_date, false));
    }

    public function getIsExpiredAttribute(): bool
    {
        return $this->end_date < Carbon::today();
    }
}
