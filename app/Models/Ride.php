<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Ride extends Model
{
    //


    public function passengers()
    {
        return $this->hasMany(Passenger::class, "ride_id");
    }
}
