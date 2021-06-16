import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/Boarded.dart';
import 'package:wemoove/models/Credentials.dart';
import 'package:wemoove/models/Driven.dart';
import 'package:wemoove/models/DriverDetail.dart';
import 'package:wemoove/models/MyRequest.dart';
import 'package:wemoove/models/Ride.dart';
import 'package:wemoove/models/Vehicle.dart';
import 'package:wemoove/models/WalletBalance.dart';
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
      print(response);
      log(response.toString());
      var body = response.data;
      print(body);
      if (body["token"] != null && body["user"] != null) {
        final String authtoken = body["token"];
        User user = User.fromJson(body["user"]);
        globals.token = authtoken;
        if (globals.devicetoken != null &&
            globals.devicetoken.isNotEmpty &&
            user is User) {
          //save the device token
          //print(data['email']);
          saveLocaLStorage(
              "credentials",
              Credentials(
                  username: data['username'], password: data['password']));
          saveDeviceToken({"device_token": globals.devicetoken}, globals.token);
          ridehistory(globals.token);
        }

        globals.user = user;
        if (user.userType == 1) {
          globals.isDriverMode = true;
          var data = {'id': globals.user.id};
          var response = await fetchDriversDetail(data, globals.token);
          if (response != null && response is DriverDetails) {
            globals.details = response;
          }
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        print(e.response.statusCode);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        /*print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);*/
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        /*//print(e.request);
        print(e.message);*/
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
        /*print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);*/
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        /*//print(e.request);
        print(e.message);*/
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        /*print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);*/
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        /*//print(e.request);
        print(e.message);*/
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static fetchDriversDetail(data, token) async {
    try {
      Response response = await Client(token).get(data, '/auth/driverdetails');
      var body = response.data;
      print(body);
      var result = body["details"];
      DriverDetails details = DriverDetails.fromJson(result);
      return details;
    } on DioError catch (e) {
      // The request was made and the server responded with a status views.code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
        /*print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);*/
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        /*//print(e.request);
        print(e.message);*/
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
        /*print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);*/
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        /*//print(e.request);
        print(e.message);*/
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
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
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
