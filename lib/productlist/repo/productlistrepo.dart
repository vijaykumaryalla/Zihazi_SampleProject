import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import '../../baseclasses/sessions.dart';
import '../../baseclasses/utils/constants.dart';
import '../../service/apiresponse.dart';
import 'package:http/http.dart' as http;

class ProductListRepo extends GetConnect {

  Future<ApiResponse> getSubCategory(dynamic reqModel) async {
    try {
      var result = await http.post(
          Uri.parse(Constants.baseUrl + "custom-api/homepage/getsubcategorylist"),
          body:jsonEncode(reqModel),
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

  Future<ApiResponse> getProdFromSubCategory(dynamic reqModel) async {
    var json = jsonEncode(reqModel.toJson());
    try {
      var result = await http.post(
          Uri.parse(Constants.baseUrl + "custom-api/homepage/productlist"),
          body:jsonEncode(reqModel),
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

  Future<ApiResponse> getCategorySearch(dynamic reqModel) async {
    try {
      var result = await http.post(
          Uri.parse(Constants.baseUrl + "custom-api/homepage/search"),
          body:jsonEncode(reqModel),
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

  Future<ApiResponse> removeFromWishList(dynamic reqModel) async {
    try {
      var result = await post(
          Constants.baseUrl + "custom-api/wishlist/remove",
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

  Future<ApiResponse> addToWishList(dynamic reqModel) async {
    try {
      var result = await post(
          Constants.baseUrl + "custom-api/wishlist/add",
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
  @override
  void onInit() {
    httpClient.timeout=const Duration(seconds: 20);
    super.onInit();
  }
}