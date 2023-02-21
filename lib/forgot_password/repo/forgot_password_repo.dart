import 'dart:convert';
import 'dart:io';

import 'package:get/get_connect/connect.dart';

import '../../baseclasses/sessions.dart';
import '../../baseclasses/utils/constants.dart';
import '../../service/apiresponse.dart';
import '../../service/networkerrors.dart';

class ForgotPwdRepo<T> extends GetConnect{

  @override
  void onInit() {
    httpClient.timeout=const Duration(seconds: 15);
    super.onInit();
  }

  Future<ApiResponse> sendata(dynamic reqModel) async {
    try {
      print(Constants.baseUrl+"forgetpassword   "+jsonEncode(reqModel));
      var result = await post(
          Constants.baseUrl+"custom-api/forgetpassword",
          jsonEncode(reqModel),
          headers: StorageService().getHeader()
      );

      return ApiResponse.success(result.body);
    } on SocketException {
      return ApiResponse.error("");
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