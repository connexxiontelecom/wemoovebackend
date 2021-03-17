import 'package:dio/dio.dart';
import 'package:wemoove/models/request_errors.dart';
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
    try {
      String token = ""; // initially a user doesn't have a token
      Response response = await Client(token).post(data, '/register');
      var body = response.data;
      //print(body);
      //final String authtoken = body["token"];
      //User user = User.fromJson(body["user"]);
      return;
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
} //end of class
