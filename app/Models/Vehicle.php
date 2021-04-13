<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Vehicle extends Model
{


    /**
     * Get the user that owns the car.
     */
    public function vehicle()
    {
        return $this->belongsTo(User::class, 'driver_id');
    }


}
