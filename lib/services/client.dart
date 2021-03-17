import 'package:dio/dio.dart';

class Client {
  Dio dio = new Dio();

  Client(token) {
    dio.options.headers['Content-type'] = 'application/json';
    dio.options.headers["Authorization"] = 'Bearer $token';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.baseUrl = "http://192.168.88.102:8001/api";
  }

  get(queryParameters, apiUrl) async {
    Response response;
    response = await dio.get(
      apiUrl,
      queryParameters: queryParameters,
      /*options: Options(
            contentType: 'application/json',
            headers: {
              'Content-type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            }
        )*/
    );

    return response;
  }

  post(data, apiUrl) async {
    Response response;
    response = await dio.post(apiUrl, data: data);
    return response;
  }
}
