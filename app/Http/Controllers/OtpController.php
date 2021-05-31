<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class OtpController extends Controller
{

    private $API_KEY = "TLfrtWYbF5uWb0GLWjwDigrMb722yJgAp2B3jDoYYRzYOSjIU3PHwRIpGSZlga";

    public function sendOtp(Request $request)
    {
        $this->validate($request, [
            'phone' => 'required|string',
        ]);

        $phone = $request->phone;

        $phone = substr($phone, 1); //strip the first zero

        $phone = '234'. $phone;

        $otp = $this->FourRandomDigits();

        $curl = curl_init();

        $channel = 'generic';

        $sender = 'wemoove';

        curl_setopt_array($curl, array(
        CURLOPT_URL => 'https://termii.com/api/sms/send',
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_SSL_VERIFYPEER => 0,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 0,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'POST',
        CURLOPT_POSTFIELDS =>' {
                  "to": "'.$phone.'",
                   "from": "'.$sender.'",
                   "sms":  "Your wemoove confirmation code is '.$otp.'. It expires in 10 minutes",
                   "type": "plain",
                   "channel": "'.$channel.'",
                   "api_key": "'.$this->API_KEY.'"
               }',
        CURLOPT_HTTPHEADER => array(
          'Content-Type: application/json'
        ),
        ));

        $response = curl_exec($curl);

        curl_close($curl);
        return response()->json(compact("response"));

    }




    public function resendOtp(Request $request)
    {
        $this->validate($request, [
            'phone' => 'required|string',
        ]);

        $phone = $request->phone;

        $phone = substr($phone, 1); //strip the first zero

        $phone = '234'. $phone;

        $otp = $this->FourRandomDigits();

        $curl = curl_init();

        $channel = 'dnd';

        $sender = 'N-Alert';

        curl_setopt_array($curl, array(
        CURLOPT_URL => 'https://termii.com/api/sms/send',
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_SSL_VERIFYPEER => 0,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 0,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'POST',
        CURLOPT_POSTFIELDS =>' {
                  "to": "'.$phone.'",
                   "from": "'.$sender.'",
                   "sms":  "Your wemoove confirmation code is '.$otp.'. It expires in 10 minutes",
                   "type": "plain",
                   "channel": "'.$channel.'",
                   "api_key": "'.$this->API_KEY.'"
               }',
        CURLOPT_HTTPHEADER => array(
          'Content-Type: application/json'
        ),
        ));

        $response = curl_exec($curl);

        curl_close($curl);
        return response()->json(compact("response"));

    }




    /*  public function sendOtp(Request $request)
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

    } */

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
