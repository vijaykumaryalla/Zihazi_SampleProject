import 'package:dio/dio.dart';
import 'package:get/get.dart' as Get;
import 'package:zihazi_sampleproject/baseclasses/sessions.dart';
import 'package:zihazi_sampleproject/baseclasses/utils/constants.dart';

class DioInterceptor extends Interceptor {
var storage = Get.Get.put(StorageService());
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Token'] = storage.read(Constants.apiToken);
    options.headers['content-type'] ="application/json";
    options.headers['lang'] = storage.getAppLanguage();

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    super.onError(err, handler);
  }
}