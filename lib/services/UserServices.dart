import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/Account.dart';
import 'package:wemoove/models/Addon.dart';
import 'package:wemoove/models/Bank.dart';
import 'package:wemoove/models/Boarded.dart';
import 'package:wemoove/models/CableTVBundle.dart';
import 'package:wemoove/models/CableTvProvider.dart';
import 'package:wemoove/models/Credentials.dart';
import 'package:wemoove/models/DataBundleProvider.dart';
import 'package:wemoove/models/DataPackage.dart';
import 'package:wemoove/models/Driven.dart';
import 'package:wemoove/models/DriverDetail.dart';
import 'package:wemoove/models/ElectricityBiller.dart';
import 'package:wemoove/models/ElectricityUser.dart';
import 'package:wemoove/models/MyRequest.dart';
import 'package:wemoove/models/PayOut.dart';
import 'package:wemoove/models/PolicyConfig.dart';
import 'package:wemoove/models/Ride.dart';
import 'package:wemoove/models/Vehicle.dart';
import 'package:wemoove/models/WalletBalance.dart';
import 'package:wemoove/models/airtimeProvider.dart';
import 'package:wemoove/models/callToken.dart';
import 'package:wemoove/models/chat.dart';
import 'package:wemoove/models/request.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/models/user.dart';
import 'package:wemoove/services/client.dart';

class UserServices {
  static loginUser(data) async {
    print(data);
    try {
      // var data = {"email": email, 'password': password};
      String token = ""; // initially a user doesn't have a token
      Response response = await Client(token).post(data, '/login');
      //print(response);
      //log(response.toString());
      var body = response.data;
      //print(body);
      if (body["token"] != null && body["user"] != null) {
        final String authtoken = body["token"];
        User user = User.fromJson(body["user"]);
        globals.token = authtoken;
        if (globals.devicetoken != null &&
            globals.devicetoken.isNotEmpty &&
            user is User &&
            user != null) {
          //save the device token
          //print(data['email']);
          saveLocaLStorage(
              "credentials",
              Credentials(
                  username: data['username'], password: data['password']));
          await saveDeviceToken(
              {"device_token": globals.devicetoken}, globals.token);
          await ridehistory(globals.token);
        }
        getBanks({"id": "none"}, globals.token);
        fetchConfigurations();
        fetchCallToken();
        fetchReservedAccount();
        createVirtualAccount();
        await getWalletBalance({"id": user.id}, globals.token);
        globals.user = user;

        print("Current Request Status " + user.currentRequestStatus.toString());

        print("Current Ride Status" + user.currentRideStatus.toString());

        if (user.userType == 1) {
          globals.isDriverMode = true;
          var data = {'id': globals.user.id};
          print("fetching driver's details");
          var response = await fetchDriversDetail(data, globals.token);
          if (response != null && response is DriverDetails) {
            globals.details = response;
          }
          payoutsHistory(data, globals.token);
        }
        return "success";
      } else {
        final String message = body["message"];
        return message;
      }
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static registerUser(data) async {
    //8return "success";
    try {
      String token = ""; // initially a user doesn't have a token
      data = jsonEncode(data);
      Response response = await Client(token).post(data, '/register');
      var body = response.data;
      print(body);
      final String authtoken = body["token"];
      User user = User.fromJson(body["user"]);
      globals.token = authtoken;
      globals.user = user;
      if (user.userType == 1) {
        globals.isDriverMode = true;
      }
      return "success";
    } on DioError catch (e) {
      print(e);
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        var errorbody = e.response.data;
        print(errorbody);
        return;
        List<String> errors = [];
        /**iterate through and fetch errors
         * attempt to parse the response, to extract the message
         **/
        (errorbody as Map).forEach((i, value) {
          //print('index=$i, value=$value');
          //print(value[0]);
          errors.add(value[0]);
        });
        //RegistrationErrors errors = RegistrationErrors.fromJson(errorbody);
        print(errorbody);
        print(errors != null);
        print(errors.runtimeType);
        //if there are errors
        if (errors.length > 0) {
          return errors;
        }
        //the response must be an error from server
        else {
          return RequestError.RESPONSE_ERROR;
        }
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static registerVehicle(data, token) async {
    //new Instance for Form Submission
    //so the Accept Content-Type is form-data
    Dio dio = new Dio();
    dio.options.headers["Authorization"] = 'Bearer $token';
    try {
      Response response =
          await dio.post(globals.baseUrl + '/auth/regvehicle', data: data);
      var body = response.data;
      print(body);
      final String message = body["message"];
      final dynamic details = body["details"];
      globals.user.profileImage = details["profile"];
      globals.user.userType = details["type"];

      final dynamic cars = details["cars"] as List;
      List<Vehicles> vehicles = [];
      if (cars != null && cars.length > 0) {
        for (var car in cars) {
          if (car != null) {
            Vehicles ride = Vehicles.fromJson(car);
            vehicles.add(ride);
          }
        }
      }
      globals.user.vehicles = vehicles;
      globals.isDriverMode = true;
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static registerCar(data, token) async {
    Dio dio = new Dio();
    dio.options.headers["Authorization"] = 'Bearer $token';
    try {
      Response response =
          await dio.post(globals.baseUrl + '/auth/registercar', data: data);
      var body = response.data;
      print(body);
      final String message = body["message"];
      final dynamic cars = body["cars"] as List;
      List<Vehicles> vehicles = [];
      if (cars != null && cars.length > 0) {
        for (var car in cars) {
          if (car != null) {
            Vehicles ride = Vehicles.fromJson(car);
            vehicles.add(ride);
          }
        }
      }
      globals.user.vehicles = vehicles;
      globals.isDriverMode = true;
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static sendOTP(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/otp');
      var body = response.data;
      final String otp = body["otp"].toString();
      print(body);
      globals.otp = otp;
      return;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static resendOTP(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/resendotp');
      var body = response.data;
      final String otp = body["otp"].toString();
      print(body);
      globals.otp = otp;
      return;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static updateOTPVerified(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/otp/verify');
      var body = response.data;
      print(body);
      final String message = body["message"];
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static postRide(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/publish');
      var body = response.data;
      print(body);
      final String message = body["message"];
      final int id = body["rideId"];
      globals.postedRide = id;
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static searchRide(data, token) async {
    try {
      Response response = await Client(token).get(data, '/auth/search');
      var body = response.data;
      print(body);
      List results = body["results"];
      print(results);
      List<Ride> rides = [];
      if (results != null && results.length > 0) {
        for (var result in results) {
          if (result != null) {
            Ride ride = Ride.fromJson(result);
            rides.add(ride);
          }
        }
      }
      return rides;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static fetchRides(data, token) async {
    try {
      Response response = await Client(token).get(data, '/auth/rides');
      var body = response.data;
      print(body);
      //return;
      List results = body["results"];
      print(results);
      List<Ride> rides = [];
      if (results != null && results.length > 0) {
        for (var result in results) {
          if (result != null) {
            Ride ride = Ride.fromJson(result);
            rides.add(ride);
          }
        }
      }
      return rides;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static bookRide(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/book');
      var body = response.data;
      print(body);
      final String message = body["message"];
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static rideRequests(data, token) async {
    try {
      Response response = await Client(token).get(data, '/auth/requests');
      var body = response.data;
      print(body);
      var ride = body['ride_id'];
      globals.postedRide = ride;

      List results = body["passengers"] as List;
      List<Request> requests = [];
      if (results != null && results.length > 0) {
        for (var result in results) {
          if (result != null) {
            Request request = Request.fromJson(result);
            requests.add(request);
          }
        }
      }
      return requests;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static acceptRequest(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/accept');
      var body = response.data;
      print(body);
      final String message = body["message"];
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static declineRequest(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/decline');
      var body = response.data;
      print(body);
      final String message = body["message"];
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static myrequest(data, token) async {
    try {
      Response response = await Client(token).get(data, '/auth/myrequest');
      var body = response.data;
      print(body);
      MyRequest result = MyRequest.fromJson(body["ride_request"]);
      return result;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static saveChat(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/savechat');
      var body = response.data;
      print(body);
      //final String message = body["message"];
      return; //message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static fetchChat(data, token) async {
    try {
      Response response = await Client(token).get(data, '/auth/fetchchat');
      var body = response.data;
      print(body);
      var _chats = body["chats"] as List;
      List<Chat> chats = [];
      for (var chat in _chats) {
        if (chat != null) {
          chats.add(Chat.fromJson(chat));
        }
      }
      return chats;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static saveDeviceToken(data, token) async {
    try {
      Response response =
          await Client(token).post(data, '/auth/savedevicetoken');
      var body = response.data;
      //final String otp = body["otp"].toString();
      print(body);
      //globals.otp = otp;
      return;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static ridehistory(token) async {
    var data = {
      "id": "",
    };
    try {
      Response response = await Client(token).get(data, '/auth/ridehistory');
      var body = response.data;
      print(body);
      var boarded = body["rides"] as List; //returned ride histories
      List<Boarded> histories = [];
      for (var history in boarded) {
        if (history != null) {
          histories.add(Boarded.fromJson(history));
        }
      }

      var driven = body["drivens"] as List; //returned driven histories
      List<Driven> driven_histories = [];
      for (var history in driven) {
        if (history != null) {
          driven_histories.add(Driven.fromJson(history));
        }
      }

      globals.drivens = driven_histories;
      globals.boarded = histories;

      return "success";
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static cancelRide(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/cancelride');
      var body = response.data;
      print(body);
      final String message = body["message"];
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static FinishRide(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/finishride');
      var body = response.data;
      print(body);
      final String message = body["message"];
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static startRide(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/startride');
      var body = response.data;
      print(body);
      final String message = body["message"];
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static saveRating(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/saveratings');
      var body = response.data;
      print(body);
      final String message = body["message"];
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static fetchunread(data, token) async {
    try {
      Response response = await Client(token).get(data, '/auth/fetchunread');
      var body = response.data;
      print(body);

      var _results = body["results"] as List; //retuned ride histories
      List<int> results = [];
      for (var result in _results) {
        if (result != null) {
          results.add(result);
          //histories.add(RideHistory.fromJson(history));
        }
      }
      return results;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static markasread(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/markasread');
      var body = response.data;
      print(body);
      final String message = body["message"];
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static fetchridestatus(token) async {
    try {
      var data = {"id": globals.postedRide};
      Response response = await Client(token).get(data, '/auth/ridestatus');
      //print(response);
      var body = response.data;
      print(body);
      var result = body["status"];
      return result;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static userfetchridestatus(data, token) async {
    try {
      Response response = await Client(token).get(data, '/auth/ridestatus');
      var body = response.data;
      print(body);

      var result = body["status"];
      return result;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static fetchDriversDetail(data, token) async {
    try {
      Response response = await Client(token).get(data, '/auth/driverdetails');
      var body = response.data;
      print("Driver Detail" + response.toString());
      print(body);
      var result = body["details"];
      DriverDetails details = DriverDetails.fromJson(result);
      return details;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static updateProfile(data, token) async {
    //new Instance for Form Submission
    //so the Accept Content-Type is form-data
    Dio dio = new Dio();
    dio.options.headers["Authorization"] = 'Bearer $token';
    try {
      Response response =
          await dio.post(globals.baseUrl + '/auth/updateprofile', data: data);
      var body = response.data;
      print(body);
      dynamic result = body["details"];
      globals.user.profileImage = result["profile"];
      globals.user.address = result["home"];
      globals.user.workAddress = result["work"];
      return "success";
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static getWalletBalance(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/balance');
      var body = response.data;
      print(body);
      final String bal = body["result"].toString();

      final double balance = double.parse(bal);

      var _results = body["history"] as List; //returned wallet histories
      List<WalletHistory> results = [];
      for (var result in _results) {
        if (result != null) {
          results.add(WalletHistory.fromJson(result));
          //histories.add(RideHistory.fromJson(history));
        }
      }
      globals.Balance = balance;
      globals.walletHistories = results;

      return "success";
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static debit(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/debit');
      var body = response.data;
      print(body);
      final String message = body["message"];
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static credit(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/credit');
      var body = response.data;
      print(body);
      final String message = body["message"];
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static transfer(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/transfer');
      var body = response.data;
      print(body);
      final String message = body["message"];
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static getBeneficiary(data, token) async {
    try {
      Response response = await Client(token).get(data, '/auth/beneficiary');
      var body = response.data;
      print(body);
      final String beneficiary = body["response"];
      final String message = body["message"];
      List<String> responses = [];
      responses.add(message);
      responses.add(beneficiary);
      return responses;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static identifyAccount(data) async {
    try {
      String token = ""; // initially a user doesn't have a token
      Response response = await Client(token).post(data, '/identifyaccount');
      var body = response.data;
      print(body);
      final String message = body["message"];
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static sendcode(data) async {
    try {
      String token = "";
      Response response = await Client(token).post(data, '/code');
      var body = response.data;
      final String otp = body["otp"].toString();
      print(body);
      globals.otp = otp;
      return;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static resendCode(data) async {
    try {
      String token = "";
      Response response = await Client(token).post(data, '/resendcode');
      var body = response.data;
      final String otp = body["otp"].toString();
      print(body);
      globals.otp = otp;
      return;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static resetPassword(data) async {
    try {
      String token = ""; // initially a user doesn't have a token
      Response response = await Client(token).post(data, '/resetpassword');
      var body = response.data;
      print(body);
      final String message = body["message"];
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static getBanks(data, token) async {
    try {
      Response response = await Client(token).get(data, '/auth/banks');
      var body = response.data;
      print(body);
      var banks = body["banks"] as List; //returned wallet histories
      List<Bank> _banks = [];
      for (var bank in banks) {
        if (bank != null) {
          _banks.add(Bank.fromJson(bank));
        }
      }
      globals.banks = _banks;
      return "success";
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static saveBank(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/savebank');
      var body = response.data;
      print(body);

      final String message = body["message"];
      final String bank = body['bank'];
      final String account = body['account'];
      globals.user.bank = bank;
      globals.user.account = account;
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static requestPayout(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/requestpayout');
      var body = response.data;
      print(body);

      final String message = body["message"];
      final dynamic _payout = body['payout'];
      PayOut payout = PayOut.fromJson(_payout);
      payout.amount = double.parse(payout.amount);
      List<dynamic> results = [];
      results.add(message);
      results.add(payout);
      return results;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static payoutsHistory(data, token) async {
    try {
      Response response = await Client(token).get(data, '/auth/payoutshistory');
      var body = response.data;
      print(body);
      final String message = body["message"];
      final dynamic payoutHistory = body['payouts'] as List;

      List<PayOut> payouts = [];
      if (payoutHistory != null && payoutHistory.length > 0) {
        for (var payout in payoutHistory) {
          if (payout != null) {
            PayOut _payout = PayOut.fromJson(payout);
            payouts.add(_payout);
          }
        }
      }
      globals.payouts = payouts;
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static requestSupport(data, token) async {
    try {
      Response response =
          await Client(token).post(data, '/auth/requestsupport');
      print(response);
      var body = response.data;
      print(body);
      final String message = body["message"];
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static fetchConfigurations() async {
    try {
      var data = {'id': "null"};
      var token = "";
      Response response = await Client(token).get(data, '/config');
      var body = response.data;
      print("Fetched Configurations");
      print(body);
      var result = body["configuration"];
      PolicyConfig config = PolicyConfig.fromJson(result);
      globals.config = config;
      return;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static void showDebugerrors(DioError e) {
    print(e.toString());
    //print(e.request);
    print(e.message);
    //print(e.response);
    print(e.error.toString());
    print(e.error);
    print(e.requestOptions.path);
    if (e.response != null) {
      print(e.response.data);
      print(e.response.statusMessage);
      print(e.response.realUri.toString());
      print(e.response.headers);
      print(e.response.realUri);
      print(e.response.requestOptions.path);
      print(e.response.requestOptions.data);
      print(e.response.requestOptions.uri.path);
    }
  }

  static fetchCallToken() async {
    try {
      var data = {'id': "null"};
      var token = "";
      Response response = await Client(token).get(data, '/calltoken');
      var body = response.data;
      print("Fetched Call Token");
      print(body);
      //var result = body["configuration"];
      callToken calltoken = callToken.fromJson(body);
      globals.calltoken = calltoken;
      print(globals.calltoken.token);
      return;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static createVirtualAccount() async {
    try {
      var data = {'id': "null"};
      var token = globals.token;
      Response response =
          await Client(token).post(data, '/auth/reserveaccount');
      var body = response.data;
      print("Created Account");
      debugPrint(body);
      //var result = body["configuration"];
      //if body is not empty
      if (!["", null].contains(body)) {
        Account account = Account.fromJson(body["acct"]);
        globals.account = account;
      }
      return;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static fetchReservedAccount() async {
    try {
      var data = {'id': "null"};
      var token = globals.token;
      Response response = await Client(token).get(data, '/auth/getaccount');
      var body = response.data;
      print("Account Retreived");
      print(body);
      //var result = body["configuration"];
      Account account = Account.fromJson(body["account"]);
      globals.account = account;
      return;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static fetchairtimeproviders() async {
    try {
      var data = {'id': "null"};
      var token = "";
      Response response = await Client(token).get(data, '/airtimeproviders');
      print(response);
      print("Fetched airtime providers");
      var body = response.data;
      print("Fetched airtime providers");
      print(body);
      var providers = body["result"]["data"]["providers"]
          as List; //returned wallet histories
      List<airtimeProvider> _providers = [];
      for (var provider in providers) {
        if (provider != null) {
          _providers.add(airtimeProvider.fromJson(provider));
        }
      }
      globals.airtimeproviders = _providers;
      return globals.airtimeproviders;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static purchaseAirtime(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/buyairtime');
      print(response);
      print("Airtime Purchase");
      var body = response.data;
      var status = body['result']['status'];
      var code = body['result']['code'];
      var transactionStatus = body['result']['data']['transactionStatus'];
      if (status == transactionStatus &&
          transactionStatus == 'success' &&
          code == 200) {
        return "success";
      } else {
        return;
      }
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static fetchDataBundleProviders() async {
    try {
      var data = {'id': "null"};
      var token = "";
      Response response = await Client(token).get(data, '/databundleproviders');
      print(response);
      print("Fetched data providers");
      var body = response.data;
      print("Fetched data providers");
      print(body);
      var providers = body["result"]["data"]["providers"]
          as List; //returned wallet histories
      List<databundleprovider> _providers = [];
      for (var provider in providers) {
        if (provider != null) {
          _providers.add(databundleprovider.fromJson(provider));
        }
      }
      globals.databundleproviders = _providers;
      return globals.databundleproviders;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static fetchDataPackages(String operator) async {
    try {
      var data = {'operator': operator};
      Response response =
          await Client(globals.token).post(data, '/datapackages');
      var body = response.data;
      print(body);
      var packages = body["result"]["data"] as List; //returned wallet histories
      List<DataPackage> _packages = [];
      for (var package in packages) {
        if (package != null) {
          _packages.add(DataPackage.fromJson(package));
        }
      }
      globals.packages = _packages;
      return globals.packages;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static purchaseDataBundle(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/buydatabundle');
      print(response);
      print("Data Purchase");
      var body = response.data;
      var status = body['result']['status'];
      var code = body['result']['code'];
      var transactionStatus = body['result']['data']['transactionStatus'];
      if (status == transactionStatus &&
          transactionStatus == 'success' &&
          code == 200) {
        return "success";
      } else {
        return;
      }
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static fetchCableTVProviders() async {
    try {
      var data = {'id': "null"};
      var token = "";
      Response response = await Client(token).get(data, '/cabletvproviders');
      print(response);
      print("Fetched data providers");
      var body = response.data;
      print("Fetched data providers");
      print(body);
      var providers = body["result"]["data"]["providers"]
          as List; //returned wallet histories
      List<CableTvProvider> _providers = [];
      for (var provider in providers) {
        if (provider != null) {
          _providers.add(CableTvProvider.fromJson(provider));
        }
      }
      globals.tvProviders = _providers;
      return globals.tvProviders;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  //productaddon
  static fetchCableTVBundles(String operator) async {
    try {
      var data = {'operator': operator};
      var token = "";
      Response response =
          await Client(token).post(data, '/cabletvproductbundles');
      print(response);
      //print("Fetched data providers");
      var body = response.data;
      //print("Fetched data providers");
      print(body);
      var bundles = body["result"]["data"] as List; //returned wallet histories
      List<CableTvBundle> _bundles = [];
      for (var bundle in bundles) {
        if (bundle != null) {
          _bundles.add(CableTvBundle.fromJson(bundle));
        }
      }
      globals.tvbundles = _bundles;
      return globals.tvbundles;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  //productaddon
  static fetchCableTVBundlesAddon(String operator, String code) async {
    try {
      var data = {'operator': operator, 'productcode': code};
      var token = "";
      Response response = await Client(token).post(data, '/productaddon');
      print(response);
      //print("Fetched data providers");
      var body = response.data;
      //print("Fetched data providers");
      print(body);
      var addons = body["result"]["data"] as List; //returned wallet histories
      List<Addon> _addons = [];
      for (var addon in addons) {
        if (addon != null) {
          _addons.add(Addon.fromJson(addon));
        }
      }
      globals.addons = _addons;
      return globals.addons;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static purchaseCableTV(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/subscribetv');
      print(response);
      print("TV Subscription Purchase");
      var body = response.data;
      var status = body['result']['status'];
      var code = body['result']['code'];
      var transactionStatus = body['result']['data']['transactionStatus'];
      if (status == transactionStatus &&
          transactionStatus == 'success' &&
          code == 200) {
        return "success";
      } else {
        return;
      }
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static fetchelectricitybillers() async {
    try {
      var data = {'id': "null"};
      var token = "";
      Response response = await Client(token).get(data, '/electricitybillers');
      print(response);
      print("Fetched data electricity");
      var body = response.data;
      print("Fetched data electricity");
      print(body);
      var providers = body["result"]["data"]["providers"]
          as List; //returned wallet histories
      List<ElectricityBiller> _providers = [];
      for (var provider in providers) {
        if (provider != null) {
          _providers.add(ElectricityBiller.fromJson(provider));
        }
      }
      globals.ElectricityBillers = _providers;
      return globals.ElectricityBillers;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static verifyEletricuserAccount(data) async {
    try {
      Response response =
          await Client(globals.token).post(data, '/auth/verifyelectricuser');
      print(response);

      var body = response.data;

      print(body);
      var user = body["result"]["data"]; //returned wallet histories
      ElectricityUser _user = ElectricityUser.fromJson(user);
      return _user;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static purchaseElectricityUnits(data, token) async {
    try {
      Response response =
          await Client(token).post(data, '/auth/buyelectricityunits');
      print(response);
      print("Electricity Purchase");
      var body = response.data;
      var status = body['result']['status'];
      var code = body['result']['code'];
      var transactionStatus = body['result']['data']['transactionStatus'];
      if (status == transactionStatus &&
          transactionStatus == 'success' &&
          code == 200) {
        return "success";
      } else {
        return;
      }
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        showDebugerrors(e);
        return RequestError.RESPONSE_ERROR;
      } else {
        showDebugerrors(e);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static saveLocaLStorage(dynamic key, dynamic data) {
    globals.box.put(key, data);
    print("Saved to Local");
  }
} //end of class
//registercar
