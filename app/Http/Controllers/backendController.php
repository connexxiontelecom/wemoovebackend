<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Passenger;
use App\Models\Ride;
use App\Models\User;
use App\Models\Vehicle;
use App\Models\Wallet;

class backendController extends Controller
{
    //
    public function fetchUser($user_id){
     /*    $this->validate($request, [
            'user_id' => 'required',
        ]); */

        $user_id = $user_id;//$request->user_id;
        $user = User::find($user_id);
        $user->profile_image = url("/assets/uploads/profile/" . $user->profile_image);
        $user->license = url("assets/uploads/license/" . $user->license);
        $image =   $user->profile_image ;
        return response()->json(compact("user"));

    }

    public function fetchCars(Request $request){
        $this->validate($request, [
            'driver_id' => 'required',
        ]);

        $driver_id = $request->driver_id;
        $cars = Vehicle::where("driver_id", $driver_id);

        foreach($cars as $car)
        {
            $car->car_picture = url('assets/uploads/images/' . $car->car_picture);
        }

        return response()->json(compact("cars"));
    }


    public function public_path($path = null)
    {
        return rtrim(app()->basePath('public/' . $path), '/');
    }
}
