import 'package:dio/dio.dart';
import 'package:wemoove/globals.dart' as globals;

class Client {
  Dio dio = new Dio();

  Client(token) {
    dio.options.headers['Content-type'] = 'application/json';
    dio.options.headers["Authorization"] = 'Bearer $token';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.baseUrl = globals.baseUrl;
  }

  get(queryParameters, apiUrl) async {
    Response response;
    response = await dio.get(
      apiUrl,
      queryParameters: queryParameters,
    );

    return response;
  }

  post(data, apiUrl) async {
    Response response;
    response = await dio.post(apiUrl, data: data);
    return response;
  }
}
