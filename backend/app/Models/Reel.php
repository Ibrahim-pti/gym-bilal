<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Reel extends Model
{
    protected $fillable = [
        'title',
        'video_url',
        'coach_name',
        'likes_count',
        'thumbnail',
    ];
}
