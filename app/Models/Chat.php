<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Chat extends Model
{
    //
    public function chat()
    {
        return $this->belongsTo(User::class, 'sender');
    }
}
