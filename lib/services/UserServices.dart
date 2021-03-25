import 'package:dio/dio.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/models/user.dart';
import 'package:wemoove/services/client.dart';

class UserServices {
  static loginUser(String email, String password) async {
    try {
      var data = {"email": email, 'password': password};
      String token = ""; // initially a user doesn't have a token
      Response response = await Client(token).post(data, '/login');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        //attempt to parse the response, to extract the message
        if (false) {
        } else {
          return RequestError.RESPONSE_ERROR;
        }
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static registerUser(data) async {
    //8return "success";
    try {
      String token = ""; // initially a user doesn't have a token
      Response response = await Client(token).post(data, '/register');
      var body = response.data;
      //print(body);
      final String authtoken = body["token"];
      User user = User.fromJson(body["user"]);
      globals.token = authtoken;
      globals.user = user;
      if (user.userType == 1) {
        globals.isDriverMode = true;
      }
      return "success";
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        var errorbody = e.response.data;
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
        print(e.request);
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
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }

  static sendOTP(data, token) async {
    try {
      Response response = await Client(token).post(data, '/auth/otp');
      var body = response.data;
      final String otp = body["otp"];
      print(body);
      globals.otp = otp;
      return;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        /*print(e.response.data);
        print(e.response.headers);
        print(e.response.request);*/
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        /*print(e.request);
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
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
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
      return message;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        return RequestError.RESPONSE_ERROR;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
        return RequestError.CONNECTION_ERROR;
      }
    }
  }
} //end of class
