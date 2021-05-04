<?php

namespace App\Http\Controllers;

use App\Models\Passenger;
use App\Models\Ride;
use App\Models\User;
use App\Models\Vehicle;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class RideController extends Controller
{
    //

    /* *

    ride statuses

    pending  1
    accepted 2
    finished 3;

     */

    public function publishRide(Request $request)
    {
        $this->validate($request, [
            /* 'pickup1' => 'required|string', */
            'pickups' => 'required',
            'destination' => 'required',
            'knockoffs' => 'required',
            'capacity' => 'required',
            'airconditioner' => 'required',
            'amount' => 'required',
            'departure' => 'required',
            "car"=>'required',
        ]);

        $ride = new Ride();

        $knockoffs = array();
        $knockoffs = explode(",", $request->knockoffs);
        $knockoffs = json_encode($knockoffs);

        $ride->knockoffs = $knockoffs;
        $ride->driver_id = Auth::user()->id;
        $ride->amount = $request->amount;
        $ride->departure_time = $request->departure;
        $ride->destination = $request->destination;
        $ride->amount = $request->amount;
        $ride->capacity = $request->capacity;
        $ride->car = $request->car;
        $ride->pickups = json_encode($request->pickups);

        /*  //we may later use array to integrate drop-offs and pickups
        //in the mean time lets go this way
        $ride->pickup1 = $request->pickup1;
        $ride->pickup2 = $request->pickup2; */

        $ride->status = 1; //0 cancelled, 1 Pending , 2 inprogress, 3 completed

        $ride->save();

        $rideId = $ride->id;

        $message = "success";

        $title = "Published Ride!";
        $body = "You just Published a Ride!";
        $userId = Auth::user()->id;
        $this->ToSpecificUser($title, $body, $userId);

        return response()->json(compact("message", "rideId"));
    }

    public function Search(Request $request)
    {

        $this->validate($request, [
            'search_query' => 'required|string',
            'origin' => 'required|string',
        ]);

        $pattern = '/[\x{ff0c}," "]/u';

        $query = $request->search_query;
        $origin = $request->origin;
        //Deal with all white spaces
        $query = trim($query);
        $query = preg_replace('/\W+/', ' ', $query);

        $keywords = preg_split($pattern, $query);

        $results = array();

        foreach ($keywords as $term) {
            $result = Ride::where('destination', 'like', "%" . $term . "%")->get();

            if ($result != null && Count($result) > 0) {
                foreach ($result as $ride) {
                    $ride["knockoffs"] = json_decode($ride["knockoffs"]);
                    $ride["pickups"] = json_decode($ride["pickups"]);

                    foreach ($ride["pickups"] as $pickup) {

                        //$start = $origin !=null ? $origin : "ChIJL3W5c0IKThAROqEfOKvXokE";

                        $start = "ChIJL3W5c0IKThAROqEfOKvXokE";

                        $destination = $pickup->place;
                        $matrix = $this->distanceMatrix($start, $destination);

                        if ($matrix != null) {

                        }

                        $pickup->time = $matrix["rows"][0]["elements"][0]["duration"]["text"];
                        $pickup->seconds = $matrix["rows"][0]["elements"][0]["duration"]["value"];

                    }

                    $ride["pickups"] = $this->SortPickups($ride["pickups"]);

                    $ride["passengers"] = $this->fetchPassengers($ride["driver_id"]);
                    $ride["driver"] = $this->driverInfo($ride["driver_id"]);
                    $ride["taken_seats"] = $this->countTakenSeats($ride["id"]);
                    $results[] = $ride;
                }
            }
        }

        $results = $this->uniqueArray($results, "id");

        return response()->json(compact("results"));

    }

    public function SortPickups($array)
    {
        usort($array, function ($a, $b) {
            return $a->seconds > $b->seconds;
        });
        return $array;
    }

    public function BookRide(Request $request)
    {
        $this->validate($request, [
            'ride_id' => 'required',
            'passenger_id' => 'required',
            'status' => 'required',
            'seats' => 'required',
            'pickup' => 'required',
        ]);

        $passenger = new Passenger;

        $passenger->ride_id = $request->ride_id;
        $passenger->passenger_id = $request->passenger_id;
        $passenger->request_status = $request->status;
        $passenger->seats = $request->seats;
        $passenger->pickup = $request->pickup;
        $passenger->save();

        $message = "success";

        $title = "Ride Request";
        $body = "You have Placed a Ride Request!";
        $userId = $passenger->passenger_id;
        $this->ToSpecificUser($title, $body, $userId);

        $title = "Ride Request";
        $body = "You have a Ride Request!";
        $ride = Ride::find($request->ride_id);
        $userid = $ride->driver_id;
        $this->ToSpecificUser($title, $body, $userid);
        //notify driver
        return response()->json(compact("message"));

    }

    public function RideRequests(Request $request)
    {

        $this->validate($request, [
            'id' => 'required',
        ]);

        $id = $request->id;

        $pending = 1; //pending // requests awaiting acceptance

        $in_progress = 2;

        $result = Ride::where('driver_id', $id)->where('status', $pending)->orWhere('status', $in_progress)->first();

        $ride_id = $result["id"];

        $pending = 1;

        $accepted = 2;

        //print($ride_id);

        $passengers = DB::table('passengers as p')->leftJoin('users as u', function ($join) {
            $join->on('u.id', '=', 'p.passenger_id');
        })->select('p.id as pid', 'p.*', 'u.*')->where('p.request_status', $pending)->orWhere('p.request_status', $accepted)->where('p.ride_id', $ride_id)->get();

        foreach ($passengers as $passenger) {
            $passenger->profile_image = url("/assets/uploads/profile/" . $passenger->profile_image);
        }
        return response()->json(compact("passengers"));
    }

    public function fetchRequest(Request $request)
    {

        $this->validate($request, [
            "id" => 'required',
        ]);

        $pending = 1;
        $accepted = 2;
        $id = $request->id;

        $ride_request = DB::table('passengers as p')->leftJoin('rides as r', function ($join) {
            $join->on('r.id', '=', 'p.ride_id');
        })->select('p.id as pid', 'p.*', 'r.*')->where('p.passenger_id', $id)->where('p.passenger_ride_status', 1)->where('p.request_status', $pending)->orWhere('p.request_status', $accepted)->first();
        $ride_request->knockoffs = json_decode($ride_request->knockoffs);
        $ride_request->pickups = json_decode($ride_request->pickups);
        $ride_request->passengers = $this->fetchPassengers($ride_request->driver_id);
        $ride_request->driver = $this->driverInfo($ride_request->driver_id);

        return response()->json(compact("ride_request"));

    }

    public function cancelRide(Request $request)
    {

        $this->validate($request, [
            "id" => 'required',
        ]);

        $id = $request->id;
        $pending = 1; //pending // requests awaiting acceptance
        $in_progress = 2;

        $result = Ride::where('driver_id', $id)->where('status', $pending)->orWhere('status', $in_progress)->first();

        $ride_id = $result["id"];
        $ride = Ride::find($ride_id);

        $canceled = 3; //cancelled
        $ride->status = $canceled;
        $ride->save();
        $message = "success";

        //notify passengers

        $passengers = Passenger::where("ride_id", $ride_id)->get();

        foreach ($passengers as $passenger) {

            $title = "Ride Canceled";
            $body = "The Driver Just Canceled this Ride!";
            $userId = $passenger->passenger_id;
            $this->ToSpecificUser($title, $body, $userId);

        }

        return response()->json(compact("message"));
    }

    public function startRide(Request $request)
    {

        $this->validate($request, [
            "id" => 'required',
        ]);

        $id = $request->id;

        $pending = 1; //pending // requests awaiting acceptance
        $in_progress = 2;
        $ride_id = $request->id;

        $result = Ride::where('driver_id', $id)->where('status', $pending)->orWhere('status', $in_progress)->first();
        $ride_id = $result["id"];
        $ride = Ride::find($ride_id);

        $started = 2; //started or in-progress
        $ride->status = $started;
        $ride->save();
        $message = "success";

        //notify passengers
        $passengers = Passenger::where("ride_id", $ride_id)->get();

        foreach ($passengers as $passenger) {

            $title = "Ride Started";
            $body = "The Driver Just Started this Ride!";
            $userId = $passenger->passenger_id;
            $this->ToSpecificUser($title, $body, $userId);

        }

        return response()->json(compact("message"));

    }

    public function ridestatus(Request $request)
    {

        $this->validate($request, [
            "id" => 'required',
        ]);

        $result = Ride::where('driver_id', Auth::user()->id)->where("id", $request->id)->first();
        $status = $result["status"];
        return response()->json(compact("status"));
    }

    public function userridestatus(Request $request)
    {
        $this->validate($request, [
            "ride_id" => 'required',
        ]);

        $ride_id = $request->ride_id;
        $ride = Ride::find($ride_id);
        $status = $ride->status;
        return response()->json(compact("status"));
    }

    public function rideHistory(Request $request)
    {

        $declined = 3;
        $completed = 4;
        $id = Auth::user()->id;
        $usertype = Auth::user()->user_type;

        //get all rides where I was a passenger
        $rides = DB::table('passengers as p')
            ->join('rides as r', 'r.id', '=', 'p.ride_id')
            ->select('p.id as pid', 'p.*', 'r.*')
            ->where('p.passenger_id', $id)->where(function ($query) use ($completed) {
            $query->where('r.status', $completed);
        })->oRwhere(function ($query) use ($declined) {
            $query->where('r.status', $declined);
        })->get();

        //  orWhere('r.status', $completed)->where('r.status', $declined)->get();
        /* $rides = DB::table('passengers as p')->Join('rides as r', function ($join) {
        $join->on('r.id', '=', 'p.ride_id');
        })->select('p.id as pid', 'p.*', 'r.*')->where('p.passenger_id', $id)->where('r.status', $declined)->orWhere('r.status', $completed)->get();*/

        foreach ($rides as $ride) {
            $ride->knockoffs = json_decode($ride->knockoffs);
            $ride->pickups = json_decode($ride->pickups);
            //$ride->passengers = $this->ridePassengers($ride->id);
            $ride->driver = $this->driverInfo($ride->driver_id);
        }

        //$rides = Ride::where("driver_id", $id)->where("status", $declined)->orWhere("status",$completed)->get();

        $drivens = Ride::where(function ($query) use ($completed, $id) {
            $query->where('driver_id', $id)->where('status', $completed);
        })->oRwhere(function ($query) use ($id, $declined) {
            $query->where('driver_id', $id)->where('status', $declined);
        })->get();

        // $drivens = Ride::where('driver_id', $id)->where('status', $declined)->orWhere('status', $completed)->get();

        foreach ($drivens as $driven) {
            $driven->knockoffs = json_decode($driven->knockoffs);
            $driven->pickups = json_decode($driven->pickups);
            $driven->passengers = $this->ridePassengers($driven->id);
            //$driven->driver = $this->driverInfo($driven->driver_id);
        }

        return response()->json(compact("rides", 'drivens'));

    }

    public function AcceptRequest(Request $request)
    {
        $this->validate($request, [
            'id' => 'required',
        ]);

        $id = $request->id;

        $passenger = Passenger::find($id);

        $passenger->request_status = 2; //accepted

        $passenger->save();

        $message = "success";

        $title = "Ride Request Accepted!";
        $body = "Your Ride Request has been Accepted by the driver!";
        $userId = $passenger->passenger_id;
        $this->ToSpecificUser($title, $body, $userId);

        return response()->json(compact("message"));

    }

    public function DeclineRequest(Request $request)
    {
        $this->validate($request, [
            'id' => 'required',
        ]);

        $id = $request->id;

        $passenger = Passenger::find($id);

        $passenger->request_status = 3; //declined

        $passenger->passenger_ride_status = 3; // ride terminated automatically

        $passenger->save();

        $message = "success";

        $title = Auth::user()->id == $passenger->passenger_id ? "Ride Request Canceled!" : "Ride Request Declined!";
        $body = Auth::user()->id == $passenger->passenger_id ? "You Have Canceled Your Ride Request" : "Your Ride Request has been declined by the driver!";

        $userId = $passenger->passenger_id;
        $this->ToSpecificUser($title, $body, $userId);
        return response()->json(compact("message"));
    }

    public function fetchPassengers($id)
    {
        $status = 3; // status of request is done

        //fetch number of passengers driver has ridden with
        $passengers = Passenger::leftJoin('rides', function ($join) {
            $join->on('passengers.ride_id', '=', 'rides.id');
        })->where('rides.driver_id', $id)->where('passengers.request_status', $status)->get();

        return count($passengers);
    }

    public function ridePassengers($id)
    {
        $canceled = 3; // status of request is done
        $in_progress = 2;
        $completed = 4;
        //fetch number of passengers driver has ridden with
        $passengers = Passenger::join('users', function ($join) {
        $join->on('passengers.passenger_id', '=', 'users.id');
        })->where('passengers.ride_id', $id)->get();

        //$passengers = Passenger::where("ride_id", $id)->get();

        foreach ($passengers as $passenger) {
            //$user_passenger = User::find($passenger->passenger_id);
            $passenger->profile_image = url("/assets/uploads/profile/" . $passenger->profile_image);
            //$passenger->knockoffs = json_decode($passenger->knockoffs);
            //$passenger->pickups = json_decode($passenger->pickups);
        }

        return $passengers;
    }

    public function driverInfo($id)
    {
        $driver = User::leftJoin('vehicles', function ($join) {
            $join->on('users.id', '=', 'vehicles.driver_id');
        })->where('users.id', $id)->where('vehicles.driver_id', $id)->first();

        $driver->profile_image = url("/assets/uploads/profile/" . $driver->profile_image);

        return $driver;
    }

    public function uniqueArray($array, $key)
    {
        $temp_array = array();
        $i = 0;
        $key_array = array();

        foreach ($array as $val) {
            if (!in_array($val[$key], $key_array)) {
                $key_array[$i] = $val[$key];
                //$temp_array[$i] = $val;
                $temp_array[] = $val;
            }
            $i++;
        }
        return $temp_array;
    }

    public function distanceMatrix($start, $destination, $jsonFormat = true)
    {

        $key = "AIzaSyDAHdeQbSuLtDdpfhueU392zOUW6KAjGlA";

        $url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=place_id:$start&destinations=place_id:$destination&key=$key";

        // Create a curl call
        $ch = curl_init();
        $timeout = 0;

        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, $timeout);

        $data = curl_exec($ch);
        // send request and wait for response

        $response = json_decode($data, true);

        curl_close($ch);

        if ($jsonFormat == true) {
            return $response; // response()->json( $response, 200 );
        } else {
            return $response;
        }
    }

    //count accepted seats
    public function countTakenSeats($rideid)
    {

        $accepted = 2;
        $seats = Passenger::where("request_status", $accepted)->where("ride_id", $rideid)->count();
        return $seats;
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
        $result = curl_exec($ch);
        // print($result);

        //Send the request
        curl_exec($ch);

        //Close request
        curl_close($ch);
    }


    public function registerVehicle(Request $request)
    {

        $this->validate($request, [
            'brand' => 'required|string',
            'model' => 'required|string',
            'model_year' => 'required|string',
            'colour' => 'required|string',
            'capacity' => 'required|string',
            'plate_number' => 'required|string',
            'carpicture' => 'required',
        ]);

        if (!empty($request->file('carpicture')) ) {

            //The Car's Front View Picture
            $extension = $request->file('carpicture');
            $extension = $request->file('carpicture')->getClientOriginalExtension();
            //$size = $request->file('file')->getSize();
            $dir = 'assets/uploads/images/';
            $CarPicturefilename = uniqid() . '_' . time() . '_' . date('Ymd') . '.' . $extension;
            $request->file('carpicture')->move($this->public_path($dir), $CarPicturefilename);

            $user = User::find(Auth::user()->id);

            $previousVehicle = Vehicle::where('driver_id', Auth::user()->id)->first();

            $vehicle = new Vehicle();
            $vehicle->driver_id = Auth::user()->id;
            $vehicle->brand = $request->brand;
            $vehicle->model = $request->model;
            $vehicle->model_year = $request->model_year;
            $vehicle->colour = $request->colour;
            $vehicle->capacity = $request->capacity;
            $vehicle->plate_number = $request->plate_number;
            $vehicle->license = $previousVehicle->license;
            $vehicle->car_picture = $CarPicturefilename;


            $user->user_type = 1;
            $vehicle->save();
            $user->save();

            $cars = $this->fetchVehicles(Auth::user()->id);

            $message = "success";
            return response()->json(compact('message', 'cars'));

        } else {
            $filename = '';
        }



    }




    public function fetchVehicles($id)
    {
        $response = Vehicle::where("driver_id", $id)->get();
        foreach($response as $car){

            $car->car_picture = url('assets/uploads/images/'. $car->car_picture);
        }
        return $response;
    }



    public function public_path($path = null)
    {
        return rtrim(app()->basePath('public/' . $path), '/');
    }


    public function ToSpecificUser($title, $body, $userId)
    {
        $users = User::where('users.id', $userId)->get();
        foreach ($users as $user) {
            $token = $user['device_token'];
            if ($token != null && !empty($token)) {
                $this->pushtoToken($token, $title, $body, $userId);
            }
        }
    }

}