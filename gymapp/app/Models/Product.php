<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $fillable = [
        'name', 'description', 'price', 'cost', 'stock_quantity', 'expiry_date', 'category', 'barcode', 'status'
    ];

    protected $casts = [
        'expiry_date' => 'date',
    ];

    public function saleItems()
    {
        return $this->hasMany(SaleItem::class);
    }
}
