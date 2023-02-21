import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import '../../baseclasses/sessions.dart';
import '../../baseclasses/utils/constants.dart';
import '../../service/apiresponse.dart';
class ContactUsRepo extends GetConnect{

  @override
  void onInit() {
    httpClient.timeout=const Duration(seconds: 15);
    super.onInit();
  }

  sendData(dynamic reqModel) async {
    print(jsonEncode(reqModel));
    try {
      var result = await post(
          Constants.baseUrl+"custom-api/user/contactus",
          jsonEncode(reqModel),
          headers: StorageService().getHeader()
      );
      print(result.body);
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