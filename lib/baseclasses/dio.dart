import 'package:dio/dio.dart';
import 'package:zihazi_sampleproject/baseclasses/utils/constants.dart';

import 'dio_interceptors.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "${Constants.baseUrl}custom-api/"
    )
  );

  DioClient() {
    _dio.interceptors.add(DioInterceptor());
    _dio.options.connectTimeout = 60 * 1000;
    _dio.options.receiveTimeout = 60 * 1000;
  }

  Dio get dio => _dio;
}