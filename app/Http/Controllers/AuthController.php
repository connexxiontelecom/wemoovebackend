<?php

namespace App\Http\Controllers;

use App\Models\Passenger;
use App\Models\Ride;
use App\Models\User;
use App\Models\Vehicle;
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
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $credentials = $request->only('email', 'password');

        try {
            $myTTL = 10080; //minutes
            Auth::factory()->setTTL($myTTL);
            if (!$token = Auth::attempt($credentials)) {

                $message = "Email or Password not valid";
                return response()->json(compact('message'));
                //return response()->json(['message' => 'invalid credentials'], 400);
            }
        } catch (Exception $e) {

            //return response()->json(['message' => 'could not create token'], 500);
            $message = "Unable to login";
            return response()->json(compact('message'));
        }

        $user = Auth::user();
        $user["drive"] = 0;
        $user["ride"] = 0;


        $PendingdriverRide =  $this->isRidePendingOrInProgress(Auth::user()->id);

        $pendingRideRequest = $this->isRequestPendingOrAccepted(Auth::user()->id);

        $hasvehicle =  $this->hasVehicle(Auth::user()->id);

        if ($PendingdriverRide!=false) {
            $user["drive"] = 1;
            $user["driver_ride_pending"] = $PendingdriverRide;
        }
        else{
            $user["driver_ride_pending"] = 0;
        }

        if ($pendingRideRequest!=false) {
            $user["ride"] = 1;
            $user["user_ride_pending"] = $pendingRideRequest;
        }
        else{
            $user["user_ride_pending"] =0;
        }

        if($hasvehicle!=false){

            $user["hasvehicle"] = 1;
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
            'license' => 'required',
        ]);

        if (!empty($request->file('license'))) {
            $extension = $request->file('license');
            $extension = $request->file('license')->getClientOriginalExtension();
            //$size = $request->file('file')->getSize();
            $dir = 'assets/uploads/license/';
            $filename = uniqid() . '_' . time() . '_' . date('Ymd') . '.' . $extension;
            $request->file('license')->move($this->public_path($dir), $filename);

            $vehicle = new Vehicle();
            $vehicle->driver_id = Auth::user()->id;
            $vehicle->brand = $request->brand;
            $vehicle->model = $request->model;
            $vehicle->model_year = $request->model_year;
            $vehicle->colour = $request->colour;
            $vehicle->capacity = $request->capacity;
            $vehicle->plate_number = $request->plate_number;
            $vehicle->license = $filename;
            $vehicle->save();

            $message = "success";
            return response()->json(compact("message"));

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

        $response = Ride::where("driver_id", $id)->where("status", 1)->first();//get();
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
        $response = Passenger::where("passenger_id", $id)->where("request_status", 1)->orWhere("request_status", 2)->where("passenger_ride_status", 1)->first();//->get()
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


    public function updateDeviceToken(Request $request){
        $userid = Auth::user()->id;
        $user = User::find($userid);
        $user->device_token = $request->device_token;
        $user->save();
    }



}
