import 'package:dio/dio.dart';

class DioClient {
  static Dio createDio() {
    final dio = Dio();

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print("Request: ${options.method} ${options.uri}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print("Response: ${response.statusCode} ${response.data}");
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print("Error: ${e.message}");
        return handler.next(e);
      },
    ));

    return dio;
  }
}