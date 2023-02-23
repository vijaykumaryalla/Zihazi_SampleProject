import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import '../../baseclasses/dio.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/utils/constants.dart';
import '../../service/apiresponse.dart';
import '../../service/networkerrors.dart';

class LoginRepo<T> extends GetConnect {

  @override
  void onInit() {
    httpClient.timeout=const Duration(seconds: 15);
    super.onInit();
  }

  Future<ApiResponse> login(dynamic reqModel) async {
    try {
      var result = await DioClient().dio.post(
         "login",
         data: jsonEncode(reqModel),
          // headers: StorageService().getHeader()
      );
      return ApiResponse.success(result.data);
    } on SocketException {
      return ApiResponse.error(NoInternetError());
    }
    on HttpException {
      return ApiResponse.error(ServerError(msg: 'Server error'));
    }
    on FormatException {
      return ApiResponse.error(ServerError(msg: 'Invalid response'));
    }
    catch (e) {
      return ApiResponse.error(ServerError(msg: 'Unknown error occurred'));
    }
  }

}