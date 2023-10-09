<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Passenger;
use App\Models\policy_setting;
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
        $status = 4; // status of ride is done


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
        $user = User::find(Auth::user()->id);

        if (!empty($request->file('profile_pic'))) {
            $extension = $request->file('profile_pic');
            $extension = $request->file('profile_pic')->getClientOriginalExtension();
            //$size = $request->file('file')->getSize();
            $dir = 'assets/uploads/profile/';
            $filename = uniqid() . '_' . time() . '_' . date('Ymd') . '.' . $extension;
            $request->file('profile_pic')->move($this->public_path($dir), $filename);

            $user->profile_image =$filename;
        }

            // delete profile picture from folder
            if (Auth::user()->profile_image != "avatar.png" && Auth::user()->profile_image != "avatar.jpg"){

                unlink('assets/uploads/profile/'.Auth::user()->profile_image);
            }

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

    }

    //get policy config from database
    public function getPolicyConfiguration(){
    $configuration  =  policy_setting::first();
    return response()->json(compact("configuration"));

    }

    public function public_path($path = null)
    {
        return rtrim(app()->basePath('public/' . $path), '/');
    }

    public function updateUserToDriver(Request $request)
    {
        $this->validate($request, [
            'userID' => 'required',
            'carpicture' => 'required',
            'license' => 'required',
            'colour' => 'required',
            'usertype' => 'required',
            'plate_number' => 'required',
            'selfPictureAndLicense' => 'required',
            'model' => 'required',
            'brand' => 'required',
        ]);

        try {


                $user = User::where("id", $request->userID)->first();

                $user->user_type = $request->input('usertype');
                $user->brand = $request->input('brand');
                $user->model = $request->input('model');
                $user->colour = $request->input('colour');
                $user->capacity = $request->input('capacity');
                $user->plate_number = $request->input('plate_number');
                $user->license = $request->input('license');
                $user->car_picture = $request->input('carpicture');
                $user->self_picture = $request->input('selfPictureAndLicense');


                if (!empty($request->file('license'))) {
                    $extension = $request->file('license');
                    $extension = $request->file('license')->getClientOriginalExtension();
                    //$size = $request->file('file')->getSize();
                    $dir = 'assets/uploads/license/';
                    $license_filename = uniqid() . '_' . time() . '_' . date('Ymd') . '.' . $extension;
                    $request->file('license')->move($this->public_path($dir), $license_filename);
                    $user->license = $license_filename;
                }

                if (!empty($request->file('selfPictureAndLicense'))) {
                    $extension = $request->file('selfPictureAndLicense')->getClientOriginalExtension();
                    $dir = 'assets/uploads/images/';
                    $self_picture_filename = uniqid() . '_' . time() . '_' . date('Ymd') . '.' . $extension;
                    $request->file('selfPictureAndLicense')->move($this->public_path($dir), $self_picture_filename);
                    $user->self_picture = $self_picture_filename;
                }

                if(!empty($request->file('carpicture'))){
                    //SAVE CAR FRONT VIEW
                    $extension = $request->file('carpicture')->getClientOriginalExtension();
                    //$size = $request->file('file')->getSize();
                    $dir = 'assets/uploads/images/';
                    $CarPicturefilename = uniqid() . '_' . time() . '_' . date('Ymd') . '.' . $extension;
                    $request->file('carpicture')->move($this->public_path($dir), $CarPicturefilename);
                    $user->car_picture = $CarPicturefilename;
                }

                //$user = User::find(Auth::user()->id);

                if (!empty($request->file('profileImage'))) {
                    $extension = $request->file('profileImage');
                    $extension = $request->file('profileImage')->getClientOriginalExtension();
                    //$size = $request->file('file')->getSize();
                    $dir = 'assets/uploads/profile/';
                    $profileImagefilename = uniqid() . '_' . time() . '_' . date('Ymd') . '.' . $extension;
                    $request->file('profileImage')->move($this->public_path($dir), $profileImagefilename);
                    $user->profile_image = $profileImagefilename;
                }else{
                    $user->profile_image = 'avatar.png';
                }

                $user->save();


            $user->profile_image = url("/assets/uploads/profile/" . $user->profile_image);
            $user->car_picture = url("/assets/uploads/images/" . $user->car_picture);
            $user->license =url("/assets/uploads/license/" . $user->license);
            $user->self_picture =url("/assets/uploads/images/" . $user->self_picture);

            return response()->json(['token' => '', 'user' => $user, 'message' => 'User updated successfully'], 201);

        } catch (\Exception $e) {
            //return error message
            return response()->json([ 'error'=>$e, 'message' => 'User Update  Failed!'], 409);
        }
    }

}
