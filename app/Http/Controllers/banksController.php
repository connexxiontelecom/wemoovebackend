<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Bank;
use Illuminate\Http\Request;

class banksController extends Controller
{

    public function getBanks(){

        $banks = Bank::all();

        return response()->json(compact('banks'));

    }


    public function saveBank(Request $request){
        $this->validate($request, [
            "id" => 'required',
             "bank"=>"required",
             "account"=>"required"
        ]);

        $id = $request->id;
        $user = User::find($id);

        $user->bank = $request->bank;
        $user->account = $request->account;

        $bank = Bank::find($user->bank);
        $bank = $bank->bank;
        $account = $request->account;

        $user->save();
        $message = "success";

        return response()->json(compact("message", "bank", "account"));
    }

}
