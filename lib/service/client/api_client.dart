import 'package:dio/dio.dart';
import 'package:five/service/client/service_interceptor.dart';

class ApiClient {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: 10000,
      receiveTimeout: 10000
    )
  )..interceptors.add(ServiceInterceptor());
}
