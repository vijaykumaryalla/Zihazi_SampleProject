import 'dart:convert';
import 'dart:io';

import 'package:get/get_connect/connect.dart';

import '../../baseclasses/sessions.dart';
import '../../baseclasses/utils/constants.dart';
import '../../service/apiresponse.dart';
import '../../service/networkerrors.dart';

class ShippingAddressRepo extends GetConnect{

  @override
  void onInit() {
    httpClient.timeout=const Duration(seconds: 15);
    super.onInit();
  }

  Future<ApiResponse> getShippingAddress(dynamic reqModel) async {
    try {
      var result = await post(
          Constants.baseUrl+"shippingaddress/list",
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

  Future<ApiResponse> deleteAddress(dynamic reqModel) async {
    try {
      var result = await post(
          Constants.baseUrl+"shippingaddress/delete",
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

  Future<ApiResponse> addAddress(dynamic reqModel) async {
    try {
      var result = await post(
          Constants.baseUrl+"shippingaddress/add",
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

  Future<ApiResponse> editAddress(dynamic reqModel) async {
    try {
      var result = await post(
          Constants.baseUrl+"shippingaddress/edit",
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

  Future<ApiResponse> getCountry(dynamic reqModel) async {
    try {
      print(StorageService().getHeader());
      var result = await post(
          Constants.baseUrl+"shippingaddress/countryList",
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