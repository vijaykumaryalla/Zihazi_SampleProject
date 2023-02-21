
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../baseclasses/sessions.dart';
import '../../baseclasses/utils/constants.dart';
import '../../service/apiresponse.dart';
import '../model/createorderresmodel.dart';


class Repo extends GetConnect{


  Future<ApiResponse> callPayfortToken(dynamic reqModel) async {
    try {

      var result = await post(Constants.paymentUrl,jsonEncode(reqModel));
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

  Future<ApiResponse> createOrder(dynamic reqModel) async {
    try {
      var result = await http.post(Uri.parse(Constants.baseUrl+"custom-api/order/createorder"), body:jsonEncode(reqModel) , headers: StorageService().getHeader());
      print(jsonEncode(reqModel));
      return ApiResponse.success(CreateOrderResModel.fromJson(jsonDecode(result.body)));
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

  Future<ApiResponse> updateStatus(dynamic reqModel) async {
    try {

      var result = await post(Constants.baseUrl+"custom-api/order/updatestatus", jsonEncode(reqModel),headers: StorageService().getHeader());
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

  Future<ApiResponse> updatePaymentInfo(dynamic reqModel) async {
    try {
      var result = await post(Constants.baseUrl+"custom-api/order/updateorderpaymentinfo", jsonEncode(reqModel),headers: StorageService().getHeader());
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