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

    $router->post('saveratings', 'RideController@saveRatings');

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

    $router->get('banks', 'banksController@getBanks');

    $router->post('savebank', 'banksController@saveBank');

    $router->post('requestpayout', 'walletsController@requestPayout');

    $router->get('payoutshistory', 'walletsController@payouts');

    $router->post('requestsupport', 'SupportController@SubmitRequest');

    $router->post('reserveaccount', 'walletsController@createVirtualAccount');

    $router->get('getaccount', 'walletsController@FetchAccountNumber');

    $router->post('buyairtime', 'VASController@purchaseAirtime');
    $router->post('buydatabundle', 'VASController@purchaseDatabundle');
    $router->post('subscribetv', 'VASController@cabletvPurchaseSubscription');
    $router->post('verifyelectricuser', 'VASController@verifyUserAccount');
    $router->post('buyelectricityunits', 'VASController@purchaseElectricity');

});

//un-authenticated route
$router->group(['prefix'=>'api'], function () use ($router) {

    $router->post('register', 'AuthController@register');
    $router->post('login', 'AuthController@login');

    $router->post('identifyaccount', 'AuthController@IdentifyAccount');
    $router->post('resetpassword', 'AuthController@IdentifyAccount');

    $router->post('code', 'OtpController@sendOtp');

    $router->post('resendcode', 'OtpController@resendOtp');

    $router->get('fetchuser/{user_id}', 'backendController@fetchUser');
    $router->get('fetchcars/{driver_id}', 'backendController@fetchCars');

    $router->get('config', 'UserController@getPolicyConfiguration');

    $router->post('adduser', 'VoximplantController@adduser');
    $router->get('calltoken', 'CallController@generateToken');

    $router->post('monnify-receipt', 'walletsController@recieveMonnifyPayment');

    $router->get('airtimeproviders', 'VASController@airtimeProviders');

    $router->get('databundleproviders', 'VASController@databundleproviders');

    $router->post('datapackages', 'VASController@databundles');

    $router->get('cabletvproviders', 'VASController@cabletv');
    $router->post('cabletvproductbundles', 'VASController@cabletvProductBundles');
    $router->post('productaddon', 'VASController@cabletvProductBundleAddon');

    $router->get('electricitybillers', 'VASController@electricityBillers');

    $router->get('ride-requests', 'Ride_Request_Controller@fetchPendingRides');
    $router->post('ride-request/create', 'Ride_Request_Controller@createRideRequest');
    $router->put('ride-request/update', 'Ride_Request_Controller@updateRideRequest');
    $router->get('ride-history/passenger/{id}', 'RideController@getRideHistory');
    $router->get('ride-history/driver/{id}', 'RideController@getDriverRideHistory');
    $router->post('users/create', 'AuthController@register');
    $router->post('users/auth-login', 'AuthController@authLogin');
    $router->post('users/update-to-driver', 'UserController@updateUserToDriver');
    $router->post('savedevicetoken', 'AuthController@updateDeviceToken');
    $router->post('otp', 'OtpController@sendOtp');
    $router->post('resendotp', 'OtpController@resendOtp');
    $router->post('otp/verify', 'OtpController@updateVerified');

});




