<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Chat;
use App\Models\User;

class chatController extends Controller
{
    //


    public function SaveChat(Request $request){
        $this->validate($request, [
            'sender' => 'required',
            'reciever' => 'required',
            'read' => 'required',
            'message' => 'required',
            'time' => 'required',
        ]);
        $chat =  new Chat;

        $chat->sender =  $request->sender;
        $chat->receiver = $request->reciever;
        $chat->read = $request->read;
        $chat->message = $request->message;
        $chat->replyto = $request->replyto;
        $chat->replytoIndex = $request->replytoIndex;
        $chat->time = $request->time;
        $chat->save();
        $message = "success";



        $title = "You have a New Message";
        $body = $request->message;
        $user = User::find($request->reciever);
        $userId =  $user->id;
        $this->ToSpecificUser($title, $body, $userId);

        return response()->json(compact("message"));
    }//end of function


    public function fetchChat(Request $request){
        $this->validate($request, [
            'sender' => 'required',
            'receiver' => 'required',
        ]);

        $sender = $request->sender;
        $receiver =  $request->receiver;

        $chats = Chat::where(function ($query) use ($sender, $receiver) {
            $query->where('sender', $sender)->where('receiver', $receiver);
        })->oRwhere(function ($query) use ($sender, $receiver) {
            $query->where('sender', $receiver)->where('receiver', $sender);
        })->get();

        return response()->json(compact("chats"));
    }




    public function deleteChat(Request $request){
        $this->validate($request, [
            'sender' => 'required',
            'receiver' => 'required',
            'id'=>"required"
        ]);

        $sender = $request->sender;
        $receiver =  $request->receiver;
        $chat = $request->id;

        $chat =  Chat::find($chat);
        if($chat!=null){
            $chat->delete();
        }

        $chats = Chat::where(function ($query) use ($sender, $receiver) {
            $query->where('sender', $sender)->where('receiver', $receiver);
        })->oRwhere(function ($query) use ($sender, $receiver) {
            $query->where('sender', $receiver)->where('receiver', $sender);
        })->get();

        return response()->json(compact("chats"));
    }



    public function markAsRead(Request $request){
        $this->validate($request, [
            'sender' => 'required',
            'receiver' => 'required',
        ]);


        $unread = 1;
        $sender = $request->sender;
        $receiver =  $request->receiver;

        $unreadChats =  Chat::where("unread", $unread)->where("sender", $sender)->where("receiver", $receiver)->get();

        foreach($unreadChats as $unreadchat){
            $unreadchat->unread =  0;
            $unreadchat->save();
        }

    }






    public function pushtoToken($token, $title, $body, $userId)
    {
        //$token, $title, $body, $userId, $tenantId

        $ch = curl_init("https://fcm.googleapis.com/fcm/send");

        $data = array("clickaction" => "FLUTTERNOTIFICATIONCLICK", "user" => $userId);

        //Creating the notification array.
        $notification = array('title' => $title, 'body' => $body);

        //This array contains, the token and the notification. The 'to' attribute stores the token.
        $arrayToSend = array('to' =>$token, 'notification' => $notification, 'data' => $data);

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




		public function ToSpecificUser($title, $body, $userId)
		{
			$users = User::where('users.id', $userId)->get();
			foreach($users as $user)
			{
					 $token= $user['device_token'];
					 if($token !=null && !empty($token))
						{
							$this->pushtoToken($token, $title, $body, $userId);
						}
			}
		}












}
