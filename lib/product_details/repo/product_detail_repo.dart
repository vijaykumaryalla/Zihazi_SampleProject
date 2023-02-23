

import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:zihazi_sampleproject/baseclasses/dio.dart';
import 'package:zihazi_sampleproject/baseclasses/sessions.dart';
import 'package:zihazi_sampleproject/baseclasses/utils/constants.dart';
import 'package:zihazi_sampleproject/service/apiresponse.dart';

class ProductDetailRepo extends GetConnect{

  @override
  void onInit() {
    httpClient.timeout=const Duration(seconds: 20);
    super.onInit();
  }

  Future<ApiResponse> getProductDetails(dynamic reqModel) async {
    try {
      var result = await DioClient().dio.post(
          "homepage/getproductdetails",
         data: jsonEncode(reqModel),
          // headers: StorageService().getHeader()
      );
      return ApiResponse.success(result.data);
    } on SocketException {
      return ApiResponse.error("No Internet");
    }
    on HttpException {
      return ApiResponse.error("Server error");
    }
    on FormatException {
      return ApiResponse.error('Invalid response');
    }
    catch (e) {
      return ApiResponse.error('Unknown error occurred');
    }
  }

  Future<ApiResponse> removeWishlistItem(dynamic reqModel) async {
    try {
      var result = await post(
          "wishlist/remove",
          jsonEncode(reqModel),
          headers: StorageService().getHeader()
      );
      return ApiResponse.success(result.body);
    } on SocketException {
      return ApiResponse.error("No Internet");
    }
    on HttpException {
      return ApiResponse.error("Server error");
    }
    on FormatException {
      return ApiResponse.error('Invalid response');
    }
    catch (e) {
      return ApiResponse.error('Unknown error occurred');
    }
  }

  Future<ApiResponse> addWishlistItem(dynamic reqModel) async {
    try {
      var result = await post(
          "wishlist/add",
          jsonEncode(reqModel),
          headers: StorageService().getHeader()
      );
      return ApiResponse.success(result.body);
    } on SocketException {
      return ApiResponse.error("No Internet");
    }
    on HttpException {
      return ApiResponse.error("Server error");
    }
    on FormatException {
      return ApiResponse.error('Invalid response');
    }
    catch (e) {
      return ApiResponse.error('Unknown error occurred');
    }
  }


}