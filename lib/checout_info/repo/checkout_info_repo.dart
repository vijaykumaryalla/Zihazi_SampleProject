import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/utils/constants.dart';
import '../../service/apiresponse.dart';

class CheckoutInfoRepo extends GetConnect{

  Future<ApiResponse> getUserAddress(dynamic reqModel) async {
    try {
      var result = await post(
          Constants.baseUrl+"custom-api/shippingaddress/list",
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