import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import '../../baseclasses/sessions.dart';
import '../../baseclasses/utils/constants.dart';
import '../../service/apiresponse.dart';

class WishlistRepo extends GetConnect{
  @override
  void onInit() {
    httpClient.timeout=const Duration(seconds: 15);
    super.onInit();
  }

  Future<ApiResponse> getWishlistItems(dynamic reqModel) async {
    try {
      var result = await post(
          Constants.baseUrl+"custom-api/homepage/getwishlistproduct",
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

  Future<ApiResponse> removeWishlistItems(dynamic reqModel) async {
    try {
      var result = await post(
          Constants.baseUrl+"custom-api/wishlist/remove",
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

  Future<ApiResponse> addWishlistItems(dynamic reqModel) async {
    try {
      var result = await post(
          Constants.baseUrl+"custom-api/wishlist/add",
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



  addProductToCart(dynamic reqModel) async {
    try {
      var result = await post(
          Constants.baseUrl+"custom-api/product/addtocart",
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