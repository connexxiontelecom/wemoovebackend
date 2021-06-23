<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\support_request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;

class SupportController extends Controller
{
    public function SubmitRequest(Request $request){
        $this->validate($request, [
            'subject' => 'required|string',
            'details' => 'required|string',
        ]);

        $subject  =  $request->subject;
        $detail = $request->details;

        $support_request = new support_request();

        $support_request->user_id = Auth::user()->id;
        $support_request->subject   = $subject;
        $support_request->content   = $detail;

        $support_request->save();

        $message = "success";
        return response()->json(compact("message"));

    }


}
