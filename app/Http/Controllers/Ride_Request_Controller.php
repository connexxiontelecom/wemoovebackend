<?php

namespace App\Http\Controllers;

use App\Models\Passenger;
use App\Models\Rating;
use App\Models\Ride;
use App\Models\RideRequest;
use App\Models\User;
use App\Models\Vehicle;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use Eloquent;
use App\Models\Wallet;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;

class Ride_Request_Controller extends Controller
{
    //

    /* *

    ride statuses

    pending  1
    accepted 2
    declined 3
    cancelled 4
    expired 5

     */

    public function createRideRequest(Request $request)
    {
            $this->validate($request, [
                'status' => 'required',
                'userId' => 'required',
                'username' => 'required',
                'destination_longitude' => 'required',
                'destination_latitude' => 'required',
                'user_latitude' => 'required',
                'user_longitude' => 'required',
                'distance_text' => 'required',
                "distance_value" => 'required',
            ]);

            $isExist  = User::where('ride_id', $request->id)->first();

            if($isExist != null){
                return response()->json(['message' => 'Already Taken'], 409);
            }
            else{
                try{
                    $ride = new RideRequest();
                    $ride->ride_id = $request->id;
                    $ride->user_id = $request->userId;
                    $ride->username = $request->username;
                    $ride->destination_address = $request->destination;
                    $ride->destination_longitude = $request->destination_longitude;
                    $ride->destination_latitude = $request->destination_latitude;
                    $ride->position_latitude = $request->user_latitude;
                    $ride->position_longitude = $request->user_longitude;
                    $ride->distance_text = $request->distance_text;
                    $ride->distance_value = $request->distance_value;
                    $ride->driver_id = $request->driver;
                    $ride->pickup = $request->pickup;
                    $ride->status = $request->status;; //Accepted


                    $ride->save();
                    return response()->json($ride, 200);

                    //            $data = array(
                    //                "clickaction" => "FLUTTERNOTIFICATIONCLICK",
                    //                "id" => '1',
                    //                'type'=>'request',
                    //                'username'=>$ride->username,
                    //                'destination'=> $ride->destination_address,
                    //                'destination_latitude'=>$ride->destination_latitude,
                    //                'destination_longitude'=> $ride->destination_longitude,
                    //                'user_latitude' => $ride->position_latitude,
                    //                'user_longitude' => $ride->position_longitude,
                    //                'distance_text' => $ride->distance_text,
                    //                'distance_value'=> $ride->distance_value,
                    //            );

                                        //$this->notifyDrivers($data);

                }
                catch (Exception $e) {
                    return response()->json(['error'=>$e,'message' => 'Sending request failed'], 500);
                }
            }
    }

    public function updateRideRequest(Request $request)
    {

        $this->validate($request, [
            'status' => 'required',
            'id' => 'required',
            'driverId' => 'required',
        ]);

        $id = $request->id;
        $driverId = $request->driverId;
        $status = $request->status;

        $ride = RideRequest::find($id);

        $ride->driver_id = $driverId;
        $ride->status =  $status == 'accepted' ? 2 : 1 ;

        $ride->save();

        $driver  = User::find($driverId);
        $passenger = User::find($ride->user_id);

        $data = array(
            "clickaction" => "FLUTTERNOTIFICATIONCLICK",
            "id" => '1',
            'type'=>'REQUEST_ACCEPTED',
            'username'=>$ride->username,
            'destination'=> $ride->destination_address,
            'destination_latitude'=>$ride->destination_latitude,
            'destination_longitude'=> $ride->destination_longitude,
            'user_latitude' => $ride->position_latitude,
            'user_longitude' => $ride->position_longitude,
            'distance_text' => $ride->distance_text,
            'distance_value'=> $ride->distance_value,
            'driver' => $driver
        );

        $this->notifyPassenger($data, $passenger);

        //$ride->driver = $driver;
        $ride->passenger = $passenger;
        return response()->json($ride, 200);
    }

    public function notifyDrivers($data)
    {
        $userType = 2; //driver ride;
        $drivers = User::where('user_type', $userType)->get();

        foreach ($drivers as $driver) {
            $token = $driver->device_token;
            if (!empty($token)) {
                $title = "A Ride Request!";
                $body = "A Ride Request!";
                $this->sendtoToken($token, $title, $body, $driver->id, $data);
            }
        }

    }

    public function notifyPassenger($data, $passenger)
    {
            $passenger = User::find(27);
            $token = $passenger->device_token;
            if (!empty($token)) {
                $title = "Ride Request Accepted";
                $body = "Ride Request Accepted";
                $this->sendtoToken($token, $title, $body, $passenger->id, $data);
            }

    }

    public function fetchPendingRides()
    {
        $pending = 1; //pending ride;
        $result = RideRequest::where('status', $pending)->get();
        return response()->json($result, 200);
        //return response()->json(compact(""));
    }

    public function pushtoToken($token, $title, $body, $userId)
    {
        //$token, $title, $body, $userId, $tenantId

        $ch = curl_init("https://fcm.googleapis.com/fcm/send");

        $data = array("clickaction" => "FLUTTERNOTIFICATIONCLICK", "user" => $userId);

        //Creating the notification array.
        $notification = array('title' => $title, 'body' => $body);

        //This array contains, the token and the notification. The 'to' attribute stores the token.
        $arrayToSend = array('to' => $token, 'notification' => $notification, 'data' => $data);

        //Generating JSON encoded string form the above array.
        $json = json_encode($arrayToSend);

        $url = "https://fcm.googleapis.com/fcm/send";
        //Setup headers:
        $headers = array();
        $headers[] = 'Content-Type: application/json';
        $headers[] = 'Authorization: key=AAAAlftCod0:APA91bH_f5ZouSisahhGVjPDS_fbx54iR1noZeeI9gGN7b6KCTBamaDebRKN4zQlftXWLVKgv2zOP2vgg1NaP9W1Qbc1_8BinzGkE8J8pvL19jEE2HvaMqQBz2MKi2uuot4laQZH7EHt';

        //Setup curl, add headers and post parameters.
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
        curl_setopt($ch, CURLOPT_POSTFIELDS, $json);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        //$result = curl_exec($ch);
        // print($result);

        //Send the request
        curl_exec($ch);

        //Close request
        curl_close($ch);
    }


    public function sendtoToken($token, $title, $body, $userId, $data)
    {
        //$token, $title, $body, $userId, $tenantId

        $ch = curl_init("https://fcm.googleapis.com/fcm/send");

        //Creating the notification array.
        $notification = array('title' => $title, 'body' => $body);

        //This array contains, the token and the notification. The 'to' attribute stores the token.
        $arrayToSend = array('to' => $token, 'notification' => $notification, 'data' => $data);

        //Generating JSON encoded string form the above array.
        $json = json_encode($arrayToSend);

        $url = "https://fcm.googleapis.com/fcm/send";
        //Setup headers:
        $headers = array();
        $headers[] = 'Content-Type: application/json';
        $headers[] = 'Authorization: key=AAAAlftCod0:APA91bH_f5ZouSisahhGVjPDS_fbx54iR1noZeeI9gGN7b6KCTBamaDebRKN4zQlftXWLVKgv2zOP2vgg1NaP9W1Qbc1_8BinzGkE8J8pvL19jEE2HvaMqQBz2MKi2uuot4laQZH7EHt';

        //Setup curl, add headers and post parameters.
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
        curl_setopt($ch, CURLOPT_POSTFIELDS, $json);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        //$result = curl_exec($ch);
        // print($result);

        //Send the request
        curl_exec($ch);

        //Close request
        curl_close($ch);
    }


    public function ToSpecificUser($title, $body, $userId)
    {
        $users = User::where('users.id', $userId)->orderBy('id', 'DESC')->get();
        foreach ($users as $user) {
            $token = $user['device_token'];
            if ($token != null && !empty($token)) {
                $this->pushtoToken($token, $title, $body, $userId);
            }
        }
    }

    public function cancelTrip(Request $request)
    {
        $rideId = $request->rideId;
        $reason =  $request->cancellation_reason;
        $ride = RideRequest::where('id', $rideId)->first();
        $ride->status = 3;
        $ride->cancellation_reason = $reason;
        $ride->save();
        return response()->json(compact("ride"));
    }


}
