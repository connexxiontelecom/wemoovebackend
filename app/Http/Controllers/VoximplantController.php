<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Voximplant\VoximplantApi;
use Voximplant\Resources\Params\StartScenariosParams;
use Voximplant\Resources\Params\AddUserParams;

class VoximplantController extends Controller
{
   // public $voxApi;
    /**
     * Instantiate a new UserController instance.
     */
    public function __construct()
    {
        //'assets/voximplant/key.json'

        //var_dump($this->voxApi);

    }


    public function adduser(Request $request)
    {

        $path =  "assets/voximplant/key.json";
        $path = rtrim(app()->basePath('public/' . $path), '/');
        $voxApi = new VoximplantApi($path);


        $params = new AddUserParams();
        $params->user_name = 'GordonFreeman';
        $params->user_display_name = 'GordonFreeman';
        $params->user_password = '1234567';
        $params->application_id = 10345012;

        // Add a new user.
        $result = $voxApi->Users->AddUser($params);

        // Show result
        var_dump($result);
    }
}
