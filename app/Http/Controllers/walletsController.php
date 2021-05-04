<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Wallet;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class walletsController extends Controller
{
    //credit wallet
    public function creditWallet(Request $request)
    {
        $this->validate($request, [
            'amount' => 'required',
            'beneficiary' => 'required',
        ]);

        $amount = $request->amount;
        $beneficiary = $request->beneficiary;
        $user = User::where('phone_number', $beneficiary)->first();
        $this->credit($amount, $user->id);
        $message = "success";
        return response()->json(compact("message"));
    }

    //Debit wallet
    public function debitWallet(Request $request)
    {
        $this->validate($request, [
            'amount' => 'required',
            'account' => 'required',
        ]);
        $amount = $request->amount;
        $account = $request->account;

        $balance = $this->balance();

        $amount = str_replace(",", "", $amount);

        if ($balance > doubleval($amount)) {

            $user = User::where('phone_number', $account)->first();
            $this->debit($amount, $user->id);
            $message = "success";
            return response()->json(compact("message"));
        }

    }

    private function credit($amount, $beneficiary)
    {
        $wallet = new Wallet();
        $wallet->credit = $amount;
        $user = Auth::user()->full_name;
        $narration = "Received " . $amount . " credit from " . $user;
        $wallet->narration = $narration;
        $wallet->user_id = $beneficiary;
        $wallet->debit = 0;
        $wallet->save();
    }

    private function debit($amount, $account)
    {
        $wallet = new Wallet();
        $wallet->debit = $amount;
        $user = Auth::user()->full_name;
        $narration = "Debit of " . $amount . " approved by " . $user;
        $wallet->narration = $narration;
        $wallet->user_id = $account;
        $wallet->credit = 0;
        $wallet->save();
    }

    //Debit wallet
    public function transfer(Request $request)
    {
        $this->validate($request, [
            'amount' => 'required',
            'beneficiary' => 'required',
        ]);

        $amount = $request->amount;
        $beneficiary = $request->beneficiary;

        $balance = $this->balance();

        $amount = str_replace(",", "", $amount);

        //if wallet balance is greater than specified amount
        if ($balance > doubleval($amount)) {
            $this->debit($amount, Auth::user()->id);
            $user = User::where('phone_number', $beneficiary)->first();
            $this->credit($amount, $user->id);
            $message = "success";
            return response()->json(compact("message"));
        } else {
            $message = "Insufficient Wallet Balance";
            return response()->json(compact("message"));
        }

    }

    public function getBeneficiaryName(Request $request){
        $this->validate($request, [
            'beneficiary' => 'required',
        ]);
        $account = $request->beneficiary;
        $user = User::where('phone_number', $account)->first();
      if(!is_null($user)){
        $response = $user->full_name;
        $message = "success";
        return response()->json(compact("response", "message"));
      }

      else {
        $response = "unknown user";
        $message = "error";
        return response()->json(compact("response", "message"));
      }

    }

    public function getBalance()
    {
        $result = $this->balance();
        $history = $this->history();
        return response()->json(compact("result", 'history'));
    }

    public function balance()
    {
        $id = Auth::user()->id;
        $credit = Wallet::where('user_id', $id)->get()->sum('credit');
        $debit = Wallet::where('user_id', $id)->get()->sum('debit');
        $total = $credit - $debit;
        return $total;
    }


    public function history()
    {
        $id = Auth::user()->id;
        $history = Wallet::where('user_id', $id)->get();
        return $history;
    }

}