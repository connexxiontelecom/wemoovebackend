<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class VASController extends Controller
{
    //
        private $api_key = "5adea9-044a85-708016-7ae662-646d59";
        private $api_url= "https://payments.baxipay.com.ng/api/baxipay";
        private $url="";

    function Authourize($request){

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
        print_r($info);
        print_r($info['request_header']);
        curl_close($ch);
        if($result){
            $result = json_decode($result);
        }

        return $result;
    }

    //purchase Airtime
    public function purchaseAirtime(){
       $parameters =  array(
            'phone' =>"08137236980",
            'amount'=> '200',
            'service_type'=> 'mtn',
            'plan'=>'prepaid',
            'agentId'=>'207',
            'agentReference'=>'AX14s68P2ZQXW'
        );
      $result =  $this->connect($parameters, "/services/airtime/request");
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
    public  function databundles(){
        $endpoint = "/services/databundle/bundles";
        $parameters = array(
            'service_type'=> 'mtn',
        );
        $result = $this->connect($parameters, $endpoint);
        return response()->json(compact("result"));
    }

    //purchase data-bundle
    public  function databundle(){
        $endpoint = "/services/databundle/request";
        $parameters = array(
            'phone'=> '08137236980',
            'amount'=> 200,
            'service_type'=> 'mtn',
            'datacode'=> '200',
            'agentId'=> 207,
            'agentReference'=>'AX14s68P2AZX'
        );
        $result = $this->connect($parameters, $endpoint);
        return response()->json(compact("result"));
    }

    //Retrieves cable tv providers and their codes
    public  function cabletv(){
        $endpoint = "/services/cabletv/providers";
        $result = $this->connect(null, $endpoint,"GET");
        return response()->json(compact("result"));
    }


    //Retrieves subscription bundles for Cable TV product
    public  function cabletvProductBundles(){
        $endpoint = "/services/multichoice/list";
        $parameters = array(
            'service_type'=> 'dstv',
        );
        $result = $this->connect($parameters, $endpoint);
        return response()->json(compact("result"));
    }


    //Retrieves Addons that can be added along side the selected subscription bundle.
    public  function cabletvProductBundleAddon(){
        $endpoint = "/services/multichoice/addons";
        $parameters = array(
            'service_type'=> 'dstv',
            'product_code'=> 'PRWASIE36',
        );
        $result = $this->connect($parameters, $endpoint);
        return response()->json(compact("result"));
    }



    //Cable TV Subscription for Multichoice Only (DSTV, GOTV)
    public  function cabletvPurchaseSubscription(){
        $endpoint = "/services/multichoice/request";
        $parameters = array(
            'smartcard_number'=> '1122334455',
            'total_amount'=> '49000',
            'product_code'=> 'PRWASIE36',
            'product_monthsPaidFor'=> '1',
            'addon_code'=> 'HDPVRE36',
            'addon_monthsPaidFor'=> '1',
            'service_type'=> 'dstv',
            'agentId'=> '207',
            'agentReference'=> 'AX14s68P2Zq',

        );
        $result = $this->connect($parameters, $endpoint);
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
        return response()->json(compact("result"));
    }



    //Gets various types of electricity billers
    public  function electricityBillers(){
        $endpoint = "/services/electricity/billers";
        $result = $this->connect(null, $endpoint,"GET");
        return response()->json(compact("result"));
    }



    //Purchase available pin bundle types (9Mobile, Glo, Waec, Bulksms, Spectranet)
    public  function verifyUserAccount(){
        $result = $this->verifyuser("ikeja_electric_prepaid", "04042404048");
        //return response()->json(compact("result"));
    }

    //Verify a user before making an electricity payment
    private function verifyuser($service, $account) {

        $fields = array(
            "service_type"=>$service,
            "account_number"=>$account,
        );
        print json_encode($fields);
        $_url = $this->api_url."/services/electricity/verify";
        print($_url);
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

        $info = curl_getinfo($ch);
        print_r($info);
        print_r($info['request_header']);
        curl_close($ch);
        if($result){
            $result = json_decode($result);
        }

        return $result;
    }


    //Make an electricity purchase request
    public  function purchaseElectricity(){
        $account_number = "04042404048";
        $amount = 2000;
        $phone = "08012345678";
        $service_type = "ikeja_electric_prepaid";
        $agentId = 205;
        $agentReference = "ASF33309d4XAW";

        $endpoint = "/services/electricity/request";
        $parameters = array ("account_number"=> $account_number,
        "amount"=>$amount,
        "phone"=>$phone,
        "service_type"=>$service_type,
        "agentId"=>$agentId,
        "agentReference"=>$agentReference);
        $result = $this->purchaseunits($parameters, $endpoint);
        return response()->json(compact("result"));
    }


    //Verify a user before making an electricity payment
    private function purchaseunits($parameters, $endpoint) {
        $_url = $this->api_url.$endpoint;
        print($_url);
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
        print_r($info);
        print_r($info['request_header']);
        curl_close($ch);
        if($result){
            $result = json_decode($result);
        }

        return $result;
    }






}
