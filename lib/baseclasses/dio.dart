import 'package:dio/dio.dart';

import 'dio_interceptors.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.interceptors.add(DioInterceptor());
  }

  Dio get dio => _dio;
}