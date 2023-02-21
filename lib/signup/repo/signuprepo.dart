import 'dart:convert';
import 'dart:io';

import 'package:get/get_connect/connect.dart';

import '../../baseclasses/sessions.dart';
import '../../baseclasses/utils/constants.dart';
import '../../service/apiresponse.dart';
import '../../service/networkerrors.dart';

class SignupRepo<T> extends GetConnect {

  @override
  void onInit() {
    httpClient.timeout=const Duration(seconds: 15);
    super.onInit();
  }

  Future<ApiResponse> signup(dynamic reqModel) async {
    try {
      var result = await post(
          Constants.baseUrl+"custom-api/register",
          jsonEncode(reqModel),
          headers: StorageService().getHeader()
      );
      return ApiResponse.success(result.body);
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


  Future<ApiResponse> mobileSignup(dynamic reqModel) async {
    try {
      var result = await post(
          Constants.baseUrl+"custom-api/regisrationotpsend",
          jsonEncode(reqModel),
          headers: StorageService().getHeader()
      );
      return ApiResponse.success(result.body);
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

  Future<ApiResponse> otpVerification(dynamic reqModel) async {
    try {
      var result = await post(
          Constants.baseUrl+"custom-api/verifyregisrationotp",
          jsonEncode(reqModel),
          headers: StorageService().getHeader()
      );
      return ApiResponse.success(result.body);
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

  Future<ApiResponse> resetPasswordCall(dynamic reqModel) async {
    try {
      var result = await post(
          Constants.baseUrl+"custom-api/mobileregisration",
          jsonEncode(reqModel),
          headers: StorageService().getHeader()
      );
      return ApiResponse.success(result.body);
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