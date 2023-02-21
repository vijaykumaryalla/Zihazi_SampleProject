import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../baseclasses/basecontroller.dart';
import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/custome_loader/lodading_indicator.dart';
import '../../service/networkerrors.dart';
import '../model/my_orders.dart';
import '../repo/myordersrepo.dart';
import '../view/myordersitempage.dart';

class MyOrdersController extends BaseController {
  RxList<Orders> orderList = List<Orders>.empty(growable: true).obs;
  var orderResponse = ResponseInfo(responseStatus: Constants.loading).obs;
  var repo = Get.find<OrdersRepo>();
  var storageService = Get.find<StorageService>();

  @override
  void onInit() {
    getMyOrders();
    super.onInit();
  }

  void getMyOrders() async {
    var userId = await storageService.read("userid");
    var result = await repo.getMyOrders({
      "userid": userId
    });
    try {
      if(result.response == null) {
        getMyOrders();
      } else if (result.error == null) {
        var responseCode = result.response['SuccessCode'];
        if (responseCode == 200) {
          var ordersModel = MyOrders.fromJson(result.response);
          orderList.addAll(ordersModel.data);
          orderList.value = orderList.reversed.toList();
          orderResponse.value = ResponseInfo(
              responseStatus: Constants.success,
              respCode: ordersModel.successCode,
              respMessage: ordersModel.message);
        } else {
          var message = result.response['message'];
          orderResponse.value = ResponseInfo(
              responseStatus: Constants.failure,
              respCode: responseCode,
              respMessage: message);
        }
      } else {
        orderResponse.value = ResponseInfo(
            responseStatus: Constants.failure,
            respCode: 500,
            respMessage: result.error);
      }
    } catch (e) {
      orderResponse.value = ResponseInfo(
          responseStatus: Constants.failure,
          respCode: 500,
          respMessage: "no_orders_found".tr);
      printError(info: e.toString());
    }
  }

  Widget buildMyOrders() {
    if (orderResponse.value.responseStatus == Constants.loading) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: SizedBox(
            height: 40,
            child: LoadingIndicator(
              indicatorType: Indicator.ballRotateChase,
              colors: [AppTheme.primaryColor],
              strokeWidth: 2,
            ),
          ),
        ),
      );
    } else if (orderResponse.value.responseStatus == Constants.failure) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            orderResponse.value.respMessage,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      );
    } else {
      if(orderList.isEmpty) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100,),
              Center(child: PageErrorView((){}, NoData(msg: "no_orders".tr))),
            ],
          ),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: orderList.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: MyOrdersItemPage(orderList[index]),
            onTap: () {
              Get.toNamed("/orderDetail", arguments: [orderList[index].orderId]);
            },
          );
        },
      );
    }
  }
}
