import 'dart:convert';
import 'dart:io';

import 'package:get/get_connect/connect.dart';
import 'package:zihazi_sampleproject/service/apiresponse.dart';

import '../../baseclasses/sessions.dart';
import '../../baseclasses/utils/constants.dart';
import '../../service/networkerrors.dart';

class OrdersRepo extends GetConnect {

  @override
  void onInit() {
    httpClient.timeout=const Duration(seconds: 15);
    super.onInit();
  }

  Future<ApiResponse> getMyOrders(dynamic reqParam) async {
    try {
      var result = await post(
          Constants.baseUrl+"custom-api/order/myOrders",
          jsonEncode(reqParam),
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

  Future<ApiResponse> getOrderDetail(dynamic reqParam) async {
    try {
      var result = await post(
          Constants.baseUrl+"custom-api/order/details",
          jsonEncode(reqParam),
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