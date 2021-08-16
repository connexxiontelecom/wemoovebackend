<?php

namespace App\Http\Controllers;

use App\Models\Account;
use App\Models\payout_request;
use App\Models\User;
use App\Models\Wallet;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Lcobucci\JWT\Signer\Rsa\Sha256;
use Lcobucci\JWT\Signer\Rsa\Sha512;

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

    private function credit($amount, $beneficiary, $depositor="")
    {
        $wallet = new Wallet();
        $wallet->credit = $amount;
        $user = Auth::user()!= null ?  Auth::user()->full_name : "";
        $narration = "";
        if(empty($depositor))
        {
          $narration =  "Received " . $amount . " credit from " . $user;
        }
        else{
            $narration = "Received " . $amount . " credit from ". "$depositor";
        }
        //$narration = empty($depositor) == true ? ("Received " . $amount . " credit from " . $user) : "Received " . $amount . " credit from " . $user;
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

    public function getBeneficiaryName(Request $request)
    {
        $this->validate($request, [
            'beneficiary' => 'required',
        ]);
        $account = $request->beneficiary;
        $user = User::where('phone_number', $account)->first();
        if (!is_null($user)) {
            $response = $user->full_name;
            $message = "success";
            return response()->json(compact("response", "message"));
        } else {
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

    public function getAccount($id){
        $account =  Account::where('user_id', $id)->first();
        return $account;
    }

    public function FetchAccountNumber(Request $request){
        //$id = $request->user_id;
        $id = Auth::user()->id;
        $account =  $this->getAccount($id);
        return response()->json(compact('account'));
    }

    public function balance()
    {
        $id = Auth::user()->id;
        $credit = Wallet::where('user_id', $id)->get()->sum('credit');
        $debit = Wallet::where('user_id', $id)->get()->sum('debit');
        $total = $credit - $debit;
        return $total;
    }

    //payout controller
    public function requestPayout(Request $request)
    {

        $this->validate($request, [
            'user_id' => 'required',
            'amount' => 'required',
        ]);

        $user = $request->user_id;
        $amount = $request->amount;
        $status = 0;
        $payout_request = new payout_request();

        $payout_request->user_id = $user;
        $payout_request->amount = $amount;
        //$payout_request->s
        $payout_request->save();
        $payout_request->action_type = 0;
        $payout = $payout_request;
        $message = "success";
        return response()->json(compact("message","payout"));
    }

    //payouts history for a particular user
    public function payouts(Request $request)
    {

        $payouts = payout_request::where("user_id", Auth::user()->id)->orderBy('id', 'DESC')->get();

        $message = "success";
        return response()->json(compact("message", "payouts"));
    }

    public function history()
    {
        $id = Auth::user()->id;
        $history = Wallet::where('user_id', $id)->get();
        return $history;
    }



    public function createVirtualAccount(Request $request){
        $account  = $this->getAccount(Auth::user()->id);
        if(empty($account)) {
            $accountReference = substr(sha1(time()), 20, 40);
            $accountName = Auth::user()->full_name;
            $currencyCode = "NGN";
            $contractCode = "5321458792";
            $customerEmail = Auth::user()->email;
            $customerName = Auth::user()->full_name;
            $getAllAvailableBanks = false;
            $preferredBanks = "035";
            $fields = [
                "accountReference" => $accountReference,
                "accountName" => $accountName,
                "currencyCode" => $currencyCode,
                "contractCode" => $contractCode,
                "customerEmail" => $customerEmail,
                "customerName" => $customerName,
                "getAllAvailableBanks" => $getAllAvailableBanks,
                "preferredBanks" => [$preferredBanks]
            ];
            $response = $this->createAccount($fields);
            $response = json_decode($response);
            $account_numb =  $response->responseBody->accounts[0]->accountNumber;
            $bankname = $response->responseBody->accounts[0]->bankName;
            $bankCode = $response->responseBody->accounts[0]->bankCode;
            $account_reference = $response->responseBody->accountReference;
            $reservationReference = $response->responseBody->reservationReference;
            $acct = new Account();
            $acct->user_id = Auth::user()->id;
            $acct->number = $account_numb;
            $acct->bankcode = $bankCode;
            $acct->bank = $bankname;
            $acct->reservationreference = $reservationReference;
            $acct->accountreference = $account_reference;
            $acct->save();
            return response()->json(compact("acct"));
        }
    }

    public function createAuthToken(){
        $keys =  "MK_TEST_2UM78S43SG:HJGKH9F7A2VKX5XG7HANTKFNPGGUMVSS"; //apiKey:clientSecret;
        $key =  base64_encode($keys);
        $curl = curl_init();

        curl_setopt_array($curl, array(
            CURLOPT_URL => 'https://sandbox.monnify.com/api/v1/auth/login',
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_SSL_VERIFYPEER => 0,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => 'POST',
            CURLOPT_HTTPHEADER => array(
                'Content-Type:application/json',
                'Authorization: Basic '.$key,
            ),
        ));
        $response = curl_exec($curl);
        curl_close($curl);
        $response = json_decode($response);
        $token = $response->responseBody->accessToken;
        return $token;
    }



    private function createAccount($fieldsArray)
    {
        $fields = json_encode($fieldsArray);
        $authToken = $this->createAuthToken();
        $curl = curl_init();

        curl_setopt_array($curl, array(
            CURLOPT_URL => 'https://sandbox.monnify.com/api/v2/bank-transfer/reserved-accounts',
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_SSL_VERIFYPEER => 0,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => 'POST',
            CURLOPT_POSTFIELDS => $fields,
            CURLOPT_HTTPHEADER => array(
                'Content-Type:application/json',
                'Authorization:Bearer '.$authToken,
            ),
        ));

        $response = curl_exec($curl);

        curl_close($curl);
        //return response()->json(compact("response"));
        // return response()->json(compact("response"));
        return $response;
    }


    public function recieveMonnifyPayment(Request $request){
        $clientSecret ="HJGKH9F7A2VKX5XG7HANTKFNPGGUMVSS";
        $transactionReference = $request->transactionReference;
        $paymentReference = $request->paymentReference;
        $amountPaid  = $request->amountPaid;
        $paidOn = $request->paidOn;
        $transactionHash = $request->transactionHash;
        $hashParameters = $clientSecret."|".$paymentReference."|".$amountPaid."|".$paidOn."|".$transactionReference;
        $transactionhash = hash("SHA512",$hashParameters);
        $paymentStatus = $request->paymentStatus;
        $accountRef = $request->product["reference"];
        $paymentMethod = $request->paymentMethod;
        $isequal = ($transactionhash == $transactionHash) ?  true : false;
        //find the user with account reference
        $account = Account::where('accountreference', $accountRef)->first();
        $this->credit($amountPaid,$account->user_id, "Monnify");
        //return response()->json(compact("account"));
        //return response()->json(compact("clientSecret",'amountPaid',"transactionReference", 'paymentReference', 'transactionhash', 'isequal', 'accountRef', 'paymentMethod', 'paymentStatus' ));
        $this->ToSpecificUser("Credit Alert $isequal", "Your wallet has been Credited with $amountPaid", $account->user_id);
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


}
