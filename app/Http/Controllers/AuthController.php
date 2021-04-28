<?php

namespace App\Http\Controllers;

use App\Models\Passenger;
use App\Models\Ride;
use App\Models\User;
use App\Models\Vehicle;
use App\Models\Wallet;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;

class AuthController extends Controller
{
    //

    /**
     * Get a JWT via given credentials.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function login(Request $request)
    {

        $this->validate($request, [
            'username' => 'required',//can be email or password
            'password' => 'required',
        ]);

        try {
            $myTTL = 10080; //minutes
            Auth::factory()->setTTL($myTTL);

            //attempt to login with phonenumber
            $credentials = array ('phone_number'=>$request->username, 'password'=>$request->password);
            $token = Auth::attempt($credentials);
            if(!$token){

                $credentials = array ('email'=>$request->username, 'password'=>$request->password);
                $token = Auth::attempt($credentials);
                if(!$token){
                    $message = "Login Credentials are not valid";
                    return response()->json(compact('message'));
                }
            }
        } catch (Exception $e) {

            //return response()->json(['message' => 'could not create token'], 500);
            $message = "Unable to login";
            return response()->json(compact('message'));
        }

        $user = Auth::user();
        $user["current_ride_status"] = 0;
        $user["current_request_status"] = 0;
        $user["profile_image"] = url("/assets/uploads/profile/" . $user["profile_image"]);
        $currentRideStatus =  $this->isRidePendingOrInProgress(Auth::user()->id);

        $currentRequestStatus = $this->isRequestPendingOrAccepted(Auth::user()->id);

        $hasvehicle =  $this->hasVehicle(Auth::user()->id);

        if($currentRideStatus!=false){
            $user["current_ride_status"] =1;
        }

        if($currentRequestStatus!=false){
            $user["current_request_status"]=1;
        }

        if($hasvehicle!=false){

            $user["hasvehicle"] = 1;
            $user['vehicles'] =  $this->fetchVehicles(Auth::user()->id);
        }
        else{

            $user["hasvehicle"] = 0;
        }

        return response()->json(compact('token','user'));
    }

    public function isValidToken()
    {
        return response()->json(['valid' => auth()->check()]);
    }

    public function getAuthenticatedUser()
    {
        try {

            if (!$user = Auth::user()) {
                return response()->json(['user not found'], 404);
            }

        } catch (TokenExpiredException $e) {

            return response()->json(['token expired'], 401);

        } catch (TokenInvalidException $e) {

            return response()->json(['token invalid'], 401);

        } catch (JWTException $e) {

            return response()->json(['token absent'], 401);

        }

        return response()->json(compact('user'));
    }

    /**
     * Register a User.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function register(Request $request)
    {
        $this->validate($request, [
            'name' => 'required|string',
            'email' => 'required|email|unique:users',
            'password' => 'required',
            'phone' => 'required|string',
            'usertype' => 'required',
        ]);

        try {

            //is a user already existing with the email
            $exists = User::where("email", $request->input('email'))->first();

            if ($exists != null) {
                return response()->json(['message' => 'email is taken already'], 409);
            } else {

                $user = new User;
                $user->full_name = $request->input('name');
                $user->email = $request->input('email');
                $user->phone_number = $request->input('phone');
                $user->user_type = $request->input('usertype');
                $plainPassword = $request->input('password');
                $user->password = app('hash')->make($plainPassword);
                $user->save();
            }

            $credentials = $request->only('email', 'password');

            $myTTL = 10080; //minutes
            Auth::factory()->setTTL($myTTL);

            if (!$token = Auth::attempt($credentials)) {
                return response()->json(['message' => 'invalid credentials, could not register user'], 409);
            }

            //initial credit bonus
            $this->credit(500, $user->id);

            return response()->json(['token' => $token, 'user' => $user, 'message' => 'User successfully registered'], 201);

        } catch (\Exception $e) {
            //return error message
            return response()->json(['message' => 'User Registration Failed!'], 409);
        }


    }

    public function registerVehicle(Request $request)
    {

        //echo $this->public_path();
        //echo  $this->public_path_p();

        $this->validate($request, [
            'brand' => 'required|string',
            'model' => 'required|string',
            'model_year' => 'required|string',
            'colour' => 'required|string',
            'capacity' => 'required|string',
            'plate_number' => 'required|string',
            'carpicture' => 'required',
            'license' => 'required',
        ]);

        if (!empty($request->file('license')) && !empty($request->file('carpicture')) ) {
            $extension = $request->file('license');
            $extension = $request->file('license')->getClientOriginalExtension();
            //$size = $request->file('file')->getSize();
            $dir = 'assets/uploads/license/';
            $license_filename = uniqid() . '_' . time() . '_' . date('Ymd') . '.' . $extension;
            $request->file('license')->move($this->public_path($dir), $license_filename);


            //The Car's Front View Picture
            $extension = $request->file('carpicture');
            $extension = $request->file('carpicture')->getClientOriginalExtension();
            //$size = $request->file('file')->getSize();
            $dir = 'assets/uploads/images/';
            $CarPicturefilename = uniqid() . '_' . time() . '_' . date('Ymd') . '.' . $extension;
            $request->file('carpicture')->move($this->public_path($dir), $CarPicturefilename);

            $user = User::find(Auth::user()->id);

            if (!empty($request->file('profileImage'))) {
                $extension = $request->file('profileImage');
                $extension = $request->file('profileImage')->getClientOriginalExtension();
                //$size = $request->file('file')->getSize();
                $dir = 'assets/uploads/profile/';
                $profileImagefilename = uniqid() . '_' . time() . '_' . date('Ymd') . '.' . $extension;
                $request->file('profileImage')->move($this->public_path($dir), $profileImagefilename);
                $user->profile_image = $profileImagefilename;
            }


            $vehicle = new Vehicle();
            $vehicle->driver_id = Auth::user()->id;
            $vehicle->brand = $request->brand;
            $vehicle->model = $request->model;
            $vehicle->model_year = $request->model_year;
            $vehicle->colour = $request->colour;
            $vehicle->capacity = $request->capacity;
            $vehicle->plate_number = $request->plate_number;
            $vehicle->license = $license_filename;
            $vehicle->car_picture = $CarPicturefilename;


            $user->user_type = 1;
            $vehicle->save();
            $user->save();

            $details = array();

            $details["profile"] = url("/assets/uploads/profile/" . $user->profile_image);
            $details["type"] = $user->user_type;

            $message = "success";
            return response()->json(compact('message', 'details'));

        } else {
            $filename = '';
        }



    }

    public function public_path($path = null)
    {
        return rtrim(app()->basePath('public/' . $path), '/');
    }

    /**
     * Log the user out (Invalidate the token).
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function logout(Request $request)
    {
        $token = $request->token;
        Auth::manager()->invalidate(new \Tymon\JWTAuth\Token($token), $forceForever = false);
        Auth::logout();
        return response()->json(['message' => 'User successfully signed out']);
    }

    /**
     * Refresh a token.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function refresh()
    {
        try
        {
            $token = Auth::refresh(Auth::getToken());
            Auth::setToken($token)->toUser();
            return response()->json(compact('token'));
        } catch (Exception $e) {
            return response()->json(['message' => 'Token cannot be refreshed, please Login again'], 400);
        }
    }

    /**
     * Get the authenticated User.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function userProfile()
    {
        return response()->json(auth()->user());
    }

    /**
     * Get the token array structure.
     *
     * @param  string $token
     *
     * @return \Illuminate\Http\JsonResponse
     */
    protected function createNewToken($token)
    {
        return response()->json([
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => Auth::factory()->getTTL() * 60,
            'user' => auth()->user(),
        ]);
    }

    //determine if the driver is yet to start a trip he/she has posted
    //by checking whether there is a pending or an ongoing ride
    //posted by the driver
    public function isRidePendingOrInProgress($id)
    {

        $pending =1;    //yet to start
        $started = 2;   //in progress
        $response = Ride::where("driver_id", $id)->where("status", 1)->orWhere("status", 2)->first();//get();
        //$count = Count($response);
        if ($response!=null) {
            return $response->id;
        } else {
            return false;
        }

    }

    //determine if the passenger is waiting for a trip
    //by checking whether there is a pending or an accepted request
    //linked to an upcoming ride or a ride in progress
    public function isRequestPendingOrAccepted($id)
    {
        $pending = 1;
        $accepted = 2;
        $ride_pending =1;
        $response = Passenger::where(function ($query) use ($pending,$ride_pending, $id) {
            $query->where("passenger_id", $id)->where("request_status", $pending)->where("passenger_ride_status", $ride_pending);
        })->oRwhere(function ($query) use ($accepted, $ride_pending, $id) {
            $query->where("passenger_id", $id)->where("request_status", $accepted)->where("passenger_ride_status", $ride_pending);
        })->first();
        //$response = Passenger::where("passenger_id", $id)->where("request_status", 1)->where("passenger_ride_status", 1)->first();//->get()
        //$count = Count($response);
        if ($response!=null) {
            return $response->ride_id;
        } else {
            return false;
        }
    }

    //if user is a driver
    //check if user has a registered vehicle
    public function hasVehicle($id)
    {
        $response = Vehicle::where("driver_id", $id)->first();//->get()
        //$count = Count($response);
        if ($response!=null) {
            return $response->id;
        } else {
            return false;
        }
    }




    public function fetchVehicles($id)
    {
        $response = Vehicle::where("driver_id", $id)->get();
        return $response;
    }


    public function updateDeviceToken(Request $request){
        $userid = Auth::user()->id;
        $user = User::find($userid);
        $user->device_token = $request->device_token;
        $user->save();
    }

    private function credit($amount, $id)
    {
        $wallet = new Wallet();
        $wallet->credit = $amount;
        $user = Auth::user()->full_name;
        $narration = "Initial on-boarding credit bonus ";
        $wallet->narration = $narration;
        $wallet->user_id = $id;
        $wallet->debit = 0;
        $wallet->save();
    }


}
