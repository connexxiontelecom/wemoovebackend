<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class VASController extends Controller
{
    //
        private $api_key = "5adea9-044a85-708016-7ae662-646d59";
        private $api_url= "https://payments.baxipay.com.ng/api/baxipay";

    function Authourize($request){

    }


    private function connect($post, $endpoint) {
        $_post = Array();
        if (is_array($post)) {
            foreach ($post as $name => $value) {
                $_post[] = $name.'='.urlencode($value);
            }
        }

        $postfields = "";

        if (is_array($post)) {
            $postfields = join('&', $_post);
        }

        $ch = curl_init($this->api_url.$endpoint.'?'.$postfields);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_POST, 1);
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

    //data bundles providers


    //fetch Databundles for a particular operator
    public  function databundleproviders(){
        $endpoint = "/services/databundle/providers";
        $parameters = array(
            'service_type'=> 'mtn',
        );
        $result = $this->connect($parameters, $endpoint);
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
        $result = json_decode($result);
        return response()->json(compact("result"));
    }

}
