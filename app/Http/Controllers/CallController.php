<?php

namespace App\Http\Controllers;
use App\Http\Agora\RtcTokenBuilder;
use Illuminate\Http\Request;
use DateTime;
use DateTimeZone;
class CallController extends Controller
{
    //


    private function generateRandomString($length = 20) {
        $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $charactersLength = strlen($characters);
        $randomString = '';
        for ($i = 0; $i < $length; $i++) {
            $randomString .= $characters[rand(0, $charactersLength - 1)];
        }
        return $randomString;
    }

    public function generateToken(Request $request){
        $appID = "d51fb65a711a4fc3bba870670cc914fb";
        $appCertificate = "82c6b5a03f0a40aaa83a1b76fee6c71b";
        $channelName = $this->generateRandomString(50);//"7d72365eb983485397e3e3f9d460bdda";
        $uid = 0;
        $uidStr = "2882341273";
        $role = RtcTokenBuilder::RolePublisher;
        $expireTimeInSeconds = 3600;
        $currentTimestamp = (new DateTime("now", new DateTimeZone('UTC')))->getTimestamp();
        $privilegeExpiredTs = $currentTimestamp + $expireTimeInSeconds;

        $token = RtcTokenBuilder::buildTokenWithUid($appID, $appCertificate, $channelName, $uid, $role, $privilegeExpiredTs);
        //echo 'Token with int uid: ' . $token . PHP_EOL;

        //$token = RtcTokenBuilder::buildTokenWithUserAccount($appID, $appCertificate, $channelName, $uidStr, $role, $privilegeExpiredTs);
        //echo 'Token with user account: ' . $token . PHP_EOL;

        return response()->json(compact("token", "channelName", "appID"));
    }


}
