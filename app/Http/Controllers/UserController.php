<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Passenger;
use App\Models\Ride;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
class UserController extends Controller
{


    public function fetchDriverDetail(Request $request){
        $this->validate($request, [
            'id' => 'required'
        ]);


        $id  =  $request->id;

        $details = array();
        $status = 3; // status of request is done


        $numberofPassengers = Passenger::leftJoin('rides', function ($join) {
            $join->on('passengers.ride_id', '=', 'rides.id');
        })->where('rides.driver_id', $id)->where('rides.status', $status)->count();

        $rides = Ride::where('driver_id', $id)->where('status', $status)->count();

        if(!is_null($numberofPassengers)){
        $details["passengers"] = $numberofPassengers;
        }
        else{
            $details["passengers"] = 0;
        }


        if(!is_null($rides)){
            $details["rides"] = $rides;
            }
            else{
                $details["rides"] = 0;
            }


        return response()->json(compact("details"));

    }



    public function updateProfile(Request $request)
    {

        if (!empty($request->file('profile_pic'))) {
            $extension = $request->file('profile_pic');
            $extension = $request->file('profile_pic')->getClientOriginalExtension();
            //$size = $request->file('file')->getSize();
            $dir = 'assets/uploads/profile/';
            $filename = uniqid() . '_' . time() . '_' . date('Ymd') . '.' . $extension;
            $request->file('profile_pic')->move($this->public_path($dir), $filename);

            $user = User::find(Auth::user()->id);

            $user->profile_image =$filename;

            $user->address = $request->home;

            $user->work_address = $request->work;

            $user->save();



            $details =array();

            $details["profile"] = $user->profile_image = url("/assets/uploads/profile/" . $user->profile_image);
            $details["work"] = $user->work_address;
            $details["home"] = $user->address;
             return response()->json(compact("details"));

           // $message = "success";
           // return response()->json(compact("message"));

        } else {
            $filename = '';
        }

    }



    public function public_path($path = null)
    {
        return rtrim(app()->basePath('public/' . $path), '/');
    }




}
