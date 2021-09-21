<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Wallet;

class VASController extends Controller
{
    //
        private $api_key = "5adea9-044a85-708016-7ae662-646d59";
        private $api_url= "https://payments.baxipay.com.ng/api/baxipay";
        private $url="";

    function Authourize($request){

    }

    private function generateRandomString() {
        $randomString = substr(sha1(time()), 28, 40);
        return $randomString;
    }

    private function connect($parameters=null, $endpoint="", $method="POST") {
        $_post = Array();
        if ( !is_null($parameters) && is_array($parameters)) {
            foreach ($parameters as $name => $value) {
                $_post[] = $name.'='.urlencode($value);
            }
        }

        if (is_array($_post) && count($_post)>0) {
            $postfields = join('&', $_post);
            $this->url = $this->api_url.$endpoint.'?'.$postfields;
        }
        else{

            $this->url = $this->api_url.$endpoint;
        }

        $ch = curl_init($this->url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        if($method == "POST")
        {
            curl_setopt($ch, CURLOPT_POST, 1);
        }
        else{
            //curl_setopt($ch, CURLOPT_HTTPGET, 1);
        }

        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
        //curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
           ' Accept: application/json',
            'Content-Type: application/json',
            'x-api-key:'.$this->api_key,
        ));
        curl_setopt($ch, CURLINFO_HEADER_OUT, true);
        curl_setopt($ch, CURLOPT_VERBOSE, 1);
        //curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
       //curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
       /* curl_setopt($ch, CURLOPT_POSTFIELDS, $postfields);*/
        //curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)');
        $result = curl_exec($ch);
        //print_r($ch);
        if (curl_errno($ch) != 0 && empty($result)) {
            $result = false;
        }

        $info = curl_getinfo($ch);
        //print_r($info);
        //print_r($info['request_header']);
        curl_close($ch);
        if($result){
            $result = json_decode($result,true);
        }

        return $result;
    }


    //Airtime Providers
    public function  airtimeProviders (Request $request){
        $endpoint = "/services/airtime/providers";
        $result = $this->connect(null, $endpoint,"GET");
        return response()->json(compact("result"));
    }

    //purchase Airtime
    public function purchaseAirtime(Request $request){
        $this->validate($request, [
            'operator' => 'required',
            'amount' => 'required',
            'phone' => 'required',
        ]);
        $operator= $request->operator;
        $amount = $request->amount;
        $phone = $request ->phone;
        $parameters =  array(
            'phone' => $phone,
            'amount'=> $amount,
            'service_type'=> $operator,
            'plan'=>'prepaid',
            'agentId'=>'207',
            'agentReference'=>$this->generateRandomString() //'AX14s68P2ZQXczsW'
        );
      $result =  $this->connect($parameters, "/services/airtime/request");

      //if Successfull
        /*{
        "result":{"status":"success","message":"Successful","code":200,"data":{"statusCode":"0","transactionStatus":"success","transactionReference":10700149,"transactionMessage":"Airtime Topup successful on 08137236980","baxiReference":1459789,"provider_message":"SendOk"}}}*/
        //var_dump($result->status);
        $status = $result['status'];
        $code= $result["code"];
        $transactionStatus = $result["data"]["transactionStatus"];
        if($status == $transactionStatus && $code == 200)
        {
            $this->debit($amount, Auth::user()->id, "Purchase of $amount airtime");
        }

      //var_dump($result);
      return response()->json(compact("result"));
    }

    //Retrieves databundle providers and their codes
    public  function databundleproviders(){
        $endpoint = "/services/databundle/providers";
        $result = $this->connect(null, $endpoint, 'GET');
        return response()->json(compact("result"));
    }


    //fetch Databundles for a particular operator
    public  function databundles(Request $request){
        $this->validate($request, [
            'operator' => 'required',
        ]);
        $operator = $request->operator;
        $endpoint = "/services/databundle/bundles";
        $parameters = array(
            'service_type'=>$operator,
        );
        $result = $this->connect($parameters, $endpoint);
        return response()->json(compact("result"));
    }

    //purchase data-bundle
    public  function purchaseDatabundle(Request $request){
        $this->validate($request, [
            'operator' => 'required',
            'amount'=>'required',
            'datacode'=>'required',
        ]);
        $endpoint = "/services/databundle/request";
        $parameters = array(
            'phone'=> $request->phone,
            'amount'=> $request->amount,
            'service_type'=> $request->operator,
            'datacode'=> $request->datacode,
            'agentId'=> 207,
            'agentReference'=>$this->generateRandomString()
        );

        $result = $this->connect($parameters, $endpoint);

        //debit
        $status = $result['status'];
        $code= $result["code"];
        $transactionStatus = $result["data"]["transactionStatus"];
        if($status == $transactionStatus && $code == 200)
        {
            $this->debit($request->amount, Auth::user()->id, "Purchase of N $request->amount  worth Data Plan ");
        }

        return response()->json(compact("result"));
    }

    //Retrieves cable tv providers and their codes
    public  function cabletv(){
        $endpoint = "/services/cabletv/providers";
        $result = $this->connect(null, $endpoint,"GET");
        return response()->json(compact("result"));
    }


    //Retrieves subscription bundles for Cable TV product
    public  function cabletvProductBundles(Request $request){
        $this->validate($request, [
            'operator' => 'required',
        ]);
        $endpoint = "/services/multichoice/list";
        $parameters = array(
            'service_type'=> $request->operator,
        );
        $result = $this->connect($parameters, $endpoint);
        return response()->json(compact("result"));
    }


    //Retrieves Addons that can be added along side the selected subscription bundle.
    public  function cabletvProductBundleAddon(Request $request){
        $endpoint = "/services/multichoice/addons";
        $this->validate($request, [
            'operator' => 'required',
            'productcode'=>'required',
        ]);
        $parameters = array(
            'service_type'=>$request->operator,
            'product_code'=>$request->productcode,
        );
        $result = $this->connect($parameters, $endpoint);
        return response()->json(compact("result"));
    }



    //Cable TV Subscription for Multichoice Only (DSTV, GOTV)
    public  function cabletvPurchaseSubscription(Request $request){

        $this->validate($request, [
            'smartcardnumber' =>'required',
            'amount'=>'required',
            'productcode'=>'required',
            'productmonthsPaidFor'=>'required',
            'operator'=>'required'
        ]);

        $endpoint = "/services/multichoice/request";
        $parameters = array(
            'smartcard_number'=> $request->smartcardnumber,
            'total_amount'=>$request->amount,
            'product_code'=>$request->productcode,
            'product_monthsPaidFor'=>$request->productmonthsPaidFor,
           /*'addon_code'=> 'HDPVRE36',
            'addon_monthsPaidFor'=> '1',*/
            'service_type'=>$request->operator,
            'agentId'=> '207',
            'agentReference'=> $this->generateRandomString(),
        );
        if (!is_null($request->addon)){

            $parameters["addon_code"] = $request->addon;
            $parameters["addon_monthsPaidFor"] = $request->productmonthsPaidFor;

        }
        $result = $this->connect($parameters, $endpoint);

        $status = $result['status'];
        $code= $result["code"];
        $transactionStatus = $result["data"]["transactionStatus"];
        if($status == $transactionStatus && $code == 200)
        {
            $this->debit($request->amount, Auth::user()->id, "Purchase of $request->amount Cable TV Subscription");
        }


        return response()->json(compact("result"));
    }


    //Retrieves epin providers and their service type codes
    public  function epinproviders(){
        $endpoint = "/services/epin/providers";
        $result = $this->connect(null, $endpoint,"GET");
        return response()->json(compact("result"));
    }


    //Retrieves available pin bundle types (9Mobile, Glo, Waec, Bulksms, Spectranet)
    public  function epinbundles(){
        $endpoint = "/services/epin/bundles";
        $parameters = array(
            'service_type'=> 'waec',
        );
        $result = $this->connect($parameters, $endpoint);
        return response()->json(compact("result"));
    }

    //Purchase available pin bundle types (9Mobile, Glo, Waec, Bulksms, Spectranet)
    public  function epinPurchase(){
        $amount = 0;
        $endpoint = "/services/epin/request";
        $parameters = array(
            'service_type'=> 'glo',
            'numberOfPins'=> 1,
            'pinValue'=> 100,
            'amount'=> 100,
            'agentId'=> '207',
            'agentReference'=> 'AX14s68P2ZQwsazx',
        );
        $result = $this->connect($parameters, $endpoint);
        $status = $result['status'];
        $code= $result["code"];
        $transactionStatus = $result["data"]["transactionStatus"];
        if($status == $transactionStatus && $code == 200)
        {
            $this->debit($amount, Auth::user()->id, "Purchase of $amount ");
        }
        return response()->json(compact("result"));
    }


    //Gets various types of electricity billers
    public  function electricityBillers(){
        $endpoint = "/services/electricity/billers";
        $result = $this->connect(null, $endpoint,"GET");
        return response()->json(compact("result"));
    }


    //Purchase available pin bundle types (9Mobile, Glo, Waec, Bulksms, Spectranet)
    public  function verifyUserAccount(Request $request){

        $this->validate($request, [
            'service' =>'required',
            'account'=>'required',
        ]);

        $service = $request->service;
        $account = $request->account;

        $result = $this->verifyuser($service, $account);
        return response()->json(compact("result"));
    }

    //Verify a user before making an electricity payment
    private function verifyuser($service, $account) {

        $fields = array(
            "service_type"=>$service,
            "account_number"=>$account,
        );
        //print json_encode($fields);
        $_url = $this->api_url."/services/electricity/verify";
       // print($_url);
        $ch = curl_init($_url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            'Accept: application/json',
            'Content-Type: application/json',
            'x-api-key:'.$this->api_key,
        ));
        curl_setopt($ch, CURLINFO_HEADER_OUT, true);
        curl_setopt($ch, CURLOPT_VERBOSE, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS,json_encode($fields));

        $result = curl_exec($ch);
        if (curl_errno($ch) != 0 && empty($result)) {
            $result = false;
        }

       /* $info = curl_getinfo($ch);
        print_r($info);
        print_r($info['request_header']);*/

        curl_close($ch);
        if($result){
            $result = json_decode($result);
        }

        return $result;
    }


    //Make an electricity purchase request
    public  function purchaseElectricity(Request $request){

        $this->validate($request, [
            'service' =>'required',
            'metre'=>'required',
            'amount'=>'required',
            'service'=> 'required',
            'phone'=>'required'
        ]);

        $agentId = 205;
        $agentReference =  $this->generateRandomString();
        $endpoint = "/services/electricity/request";
        $parameters = array ("account_number"=> $request->metre,
        "amount"=>$request->amount,
        "phone"=>$request->phone,
        "service_type"=>$request->service,
        "agentId"=>$agentId,
        "agentReference"=>$agentReference);
        $result = $this->purchaseunits($parameters, $endpoint);

        $status = $result['status'];
        $code= $result["code"];
        $transactionStatus = $result["data"]["transactionStatus"];
        if($status == $transactionStatus && $code == 200)
        {
            $this->debit($request->amount, Auth::user()->id, "Purchase of $request->amount electricity units");
        }


        return response()->json(compact("result"));
    }


    //Verify a user before making an electricity payment
    private function purchaseunits($parameters, $endpoint) {
        $_url = $this->api_url.$endpoint;
        //print($_url);
        $ch = curl_init($_url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            'Accept: application/json',
            'Content-Type: application/json',
            'x-api-key:'.$this->api_key,
        ));
        curl_setopt($ch, CURLINFO_HEADER_OUT, true);
        curl_setopt($ch, CURLOPT_VERBOSE, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS,json_encode($parameters));

        $result = curl_exec($ch);
        if (curl_errno($ch) != 0 && empty($result)) {
            $result = false;
        }

        $info = curl_getinfo($ch);
        //print_r($info);
        //print_r($info['request_header']);
        curl_close($ch);
        if($result){
            $result = json_decode($result);
        }

        return $result;
    }





    private function debit($amount, $account, $narration)
    {
        $wallet = new Wallet();
        $wallet->debit = $amount;
        $user = Auth::user()->full_name;
        $wallet->narration = $narration;
        $wallet->user_id = $account;
        $wallet->credit = 0;
        $wallet->save();
    }



}
