import 'dart:convert';
import 'dart:io';

import 'package:get/get_connect/connect.dart';
import 'package:zihazi_sampleproject/baseclasses/dio.dart';

import '../../baseclasses/sessions.dart';
import '../../baseclasses/utils/constants.dart';
import '../../service/apiresponse.dart';
import 'package:http/http.dart' as http;

class DashboardRepo extends GetConnect{

  @override
  void onInit() {
    httpClient.timeout=const Duration(seconds: 15);
    super.onInit();
  }

  Future<ApiResponse> getBanner(dynamic reqModel) async {
    try {
      var result = await DioClient().dio.post(
          Constants.baseUrl+"custom-api/homepage/banner",
          data:jsonEncode(reqModel),
          // headers: StorageService().getHeader()
      );
      return ApiResponse.success((result.data));
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

  Future<ApiResponse> getCategories() async {
    try {
      var result = await DioClient().dio.post(
          Constants.baseUrl+"custom-api/homepage/categories",
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

  Future<ApiResponse> getCategoryProducts(dynamic reqModel) async {
    try {
      var result = await DioClient().dio.post(
          Constants.baseUrl+"custom-api/homepage/topcategories",
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

  Future<ApiResponse> getTopBrands() async {
    try {
      var result = await DioClient().dio.post(
          Constants.baseUrl+"custom-api/homepage/brands",
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


}