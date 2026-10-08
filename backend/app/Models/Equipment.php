<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Equipment extends Model
{
    protected $table = 'equipment';

    protected $fillable = [
        'name', 'category', 'quantity', 'purchase_price',
        'purchase_date', 'condition', 'last_maintenance',
        'next_maintenance', 'notes'
    ];

    protected $casts = [
        'purchase_date' => 'date',
        'last_maintenance' => 'date',
        'next_maintenance' => 'date',
        'purchase_price' => 'decimal:2',
    ];
}
