<?php

/** @var \Laravel\Lumen\Routing\Router $router */

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
 */

$router->get('/', function () use ($router) {
    return $router->app->version();
});

// Authenticated API route group
$router->group(['middleware' => ['jwt.auth'], 'prefix'=>'api/auth' ], function () use ($router) {

    $router->post('regvehicle', 'AuthController@registerVehicle');

    $router->get('user', 'AuthController@getAuthenticatedUser');

    $router->post('otp', 'OtpController@sendOtp');

    $router->post('otp/verify', 'OtpController@updateVerified');

    $router->post('publish', 'RideController@publishRide');

    $router->get('search', 'RideController@Search');

    $router->post('book', 'RideController@BookRide');

    $router->get('requests', 'RideController@RideRequests');

    $router->post('accept', 'RideController@AcceptRequest');

    $router->post('decline', 'RideController@DeclineRequest');

    $router->get('myrequest', 'RideController@fetchRequest');

    $router->post('registercar', 'RideController@registerVehicle');

    $router->get('rides', 'RideController@FetchPendingRides');

    $router->post('savechat', 'chatController@SaveChat');

    $router->post('deletechat', 'chatController@deleteChat');

    $router->post('markasread', 'chatController@markAsRead');

    $router->get('fetchchat', 'chatController@fetchChat');

    $router->post('savedevicetoken', 'AuthController@updateDeviceToken');

    $router->get('ridehistory', 'RideController@rideHistory');

    $router->post('cancelride', 'RideController@cancelRide');

    $router->post('finishride', 'RideController@finishRide');

    $router->post('startride', 'RideController@startRide');

    $router->get('fetchunread', 'chatController@checkUnreadMessages');

    $router->post('markasread', 'chatController@markAsRead');

    $router->get('ridestatus', 'RideController@ridestatus');

    $router->get('userridestatus', 'RideController@userridestatus');

    $router->get('driverdetails', 'UserController@fetchDriverDetail');

    $router->post('updateprofile', 'UserController@updateProfile');

    $router->post('credit', 'walletsController@creditWallet');

    $router->post('debit', 'walletsController@debitWallet');

    $router->post('transfer', 'walletsController@transfer');

    $router->post('balance', 'walletsController@getBalance');

    $router->get('beneficiary', 'walletsController@getBeneficiaryName');

});

//un-authenticated route
$router->group(['prefix'=>'api'], function () use ($router) {
    $router->post('register', 'AuthController@register');
    $router->post('login', 'AuthController@login');
});




