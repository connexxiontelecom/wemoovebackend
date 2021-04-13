<?php

namespace App\Http\Controllers;

use App\Models\User;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class OtpController extends Controller
{

    public function sendOtp(Request $request)
    {

        $this->validate($request, [
            'phone' => 'required|string',
        ]);

        $phone = $request->phone;

        $phone = substr($phone, 1); //strip the first zero

        $otp = $this->FourRandomDigits();

        $client = new \GuzzleHttp\Client(['verify' => false]);
        $result = $client->post('https://api.africastalking.com/version1/messaging', [
            'headers' => [
                'Accept' => 'application/json',
                'Content-Type' => 'application/x-www-form-urlencoded',
                'apiKey' => 'd42621635f86f069b57a58ff7cc6359137cd9e1c6ba8b1b3ae0544b7ad6a64f1',
            ],
            'form_params' => [
                'username' => 'wolex',
                'to' => '+234' . $phone,
                'message' => $otp,
                //'from'=>'simplySholly'
            ],
        ]);

        //return response()->json(compact('result'));
        //print_r(json_decode($result->getBody()->getContents(), true));

        try {

            $result = json_decode($result->getBody()->getContents(), true); //json_decode($result);

            $status = $result["SMSMessageData"]["Recipients"][0]["status"];
            $code = $result["SMSMessageData"]["Recipients"][0]["statusCode"];

            // $result["SMSMessageData"]["Recipients"];

            if ($status == "Success" && $code == "101") {

                return response()->json(compact('otp', "status"));
            }

        } catch (Exception $e) {

            $error = "error";

            return response()->json(compact("error"));
        }

    }

    public function updateVerified(Request $request)
    {

        $this->validate($request, [
            'verify' => 'required|string',
        ]);

        if ($request->verify == "true") {
            $user = User::find(Auth::user()->id);

            $user->verified = 1;

            $user->save();

            $message = "success";
            return response()->json(compact("message"));
        }
    }


    public function FourRandomDigits()
    {
        $fourRandomDigit = mt_rand(1000, 9999);
        return $fourRandomDigit;
    }

}

/*  "SMSMessageData": {
"Message": "Sent to 1/1 Total Cost: KES 0.8000",
"Recipients": [{
"statusCode": 101,
"number": "+254711XXXYYY",
"status": "Success",
"cost": "KES 0.8000",
"messageId": "ATPid_SampleTxnId123"
}]
} */
