import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../baseclasses/sessions.dart';
import '../../baseclasses/utils/constants.dart';
import '../../service/apiresponse.dart';
import '../../service/networkerrors.dart';

class CartRepo extends GetConnect {

  @override
  void onInit() {
    httpClient.timeout=const Duration(seconds: 15);
    super.onInit();
  }

  Future<ApiResponse> getCartItems(dynamic reqParam) async {
    print(reqParam.toString());
    try {
      var result = await http.post(
          Uri.parse(Constants.baseUrl+ "custom-api/homepage/getcartproduct"),
          body: jsonEncode(reqParam),
          headers: StorageService().getHeader()
      );
      return ApiResponse.success(result.body);
    } on SocketException catch (_){
      return ApiResponse.error(NoInternetError());
    }on TimeoutException catch (_) {
      return ApiResponse.error('Server timeout');
    } on HttpException {
      return ApiResponse.error(ServerError(msg: 'Server error'));
    }
    on FormatException {
      return ApiResponse.error(ServerError(msg: 'Invalid response'));
    }
    catch (e) {
      return ApiResponse.error(ServerError(msg: 'Unknown error occurred'));
    }
  }

  Future<ApiResponse> updateQuantity(dynamic reqParam) async {
    try {
      var result = await post(
          Constants.baseUrl+ "custom-api/product/updateCart",
          reqParam,
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

  Future<ApiResponse> removeItem(dynamic reqParam) async {
    try {
      var result = await post(
          Constants.baseUrl+ "custom-api/product/removeCart",
          reqParam,
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

  Future<ApiResponse> getProductCharge(dynamic reqParam) async {
    try {
      var result = await post(
          Constants.baseUrl+ "custom-api/homepage/getcartproduct",
          reqParam,
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

  Future<ApiResponse> applyCoupon(dynamic reqParam) async {
    try {
      var result = await post(
          Constants.baseUrl+ "custom-api/order/applycoupon",
          reqParam,
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

  Future<ApiResponse> removeCoupon(dynamic reqParam) async {
    try {
      var result = await post(
          Constants.baseUrl+ "custom-api/order/removecoupon",
          reqParam,
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