import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../baseclasses/basecontroller.dart';
import '../../baseclasses/basefailuremodel.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/custome_loader/lodading_indicator.dart';
import 'package:zihazi_sampleproject/myorders/model/order_details.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../../service/networkerrors.dart';
import '../repo/myordersrepo.dart';
import '../view/deliverystatus.dart';
import '../view/productitempage.dart';

class OrderDetailController extends BaseController {
  var orderResponse = ResponseInfo(responseStatus: Constants.loading).obs;
  var repo = Get.find<OrdersRepo>();
  var storageService = Get.find<StorageService>();
  RxInt orderTrackingIndex = 0.obs;
  late Data orderDetail;
  var orderName = "".obs;
  var paymentMethod = "".obs;
  RxList<Products> productList = List<Products>.empty(growable: true).obs;

  void getOrderDetail(String orderId) async {
    orderResponse.value = ResponseInfo(responseStatus: Constants.loading);
    var userId = await storageService.read("userid");
    var result = await repo.getOrderDetail({
      "userid": userId,
      "orderid": orderId
    });
    print(userId);
    print(orderId);
    if(result.response == null) {
      getOrderDetail(orderId);
    } else {
      print(result.response);
      var ordersModel = OrderDetail.fromJson(result.response);
      try {
        if (result.error == null) {
          var responseCode = result.response['SuccessCode'];
          if (responseCode == 200) {
            var ordersModel = OrderDetail.fromJson(result.response);
            orderName.value = ordersModel.data?.orderName ?? "";
            orderDetail = ordersModel.data!;
            paymentMethod.value = ordersModel.data?.paymentMethod ?? "";
            productList.clear();
            productList.addAll(ordersModel.data?.products ?? []);
            orderTrackingIndex.value = getDeliveryStatus(ordersModel.data!);
            orderResponse.value = ResponseInfo(
                responseStatus: Constants.success,
                respCode: ordersModel.successCode ?? 0,
                respMessage: ordersModel.message ?? "");
          } else {
            var baseFailureModel = BaseFailureModel.fromJson(result.response);
            orderResponse.value = ResponseInfo(
                responseStatus: Constants.failure,
                respCode: baseFailureModel.responseCode,
                respMessage: baseFailureModel.message);
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
            respMessage: "no_data_found".tr);
        printError(info: e.toString());
      }
    }
  }

  int getDeliveryStatus(Data order) {
    if(order.delivered) {
      return Constants.delivered;
    } else if(order.outForDelivery) {
      return Constants.outForDelivery;
    } else if(order.orderShipped) {
      return Constants.shipped;
    } else if(order.confirmed) {
      return Constants.confirmed;
    } else if(order.orderPlaced) {
      return Constants.placed;
    } else {
      return 0;
    }
  }

  Widget handleResponse() {
    if(orderResponse.value.responseStatus == Constants.success) {
      return buildContent();
    } else if(orderResponse.value.responseStatus == Constants.loading) {
      return const Center(
        child: SizedBox(
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
        ),
      );
    } else if(orderResponse.value.responseStatus == Constants.failure) {
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
    }
    return Container();
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "order_id".tr + orderName.toString().padLeft(9, '0'),
            style: Style.titleTextStyle(AppTheme.blackTextColor, 14),
          ),
          const SizedBox(height: 24),
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: AppTheme.lightGrey),
            child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: DeliveryStatus(orderTrackingIndex.value, orderDetail)
            ),
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: AppTheme.lightGrey),
            child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 20),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImageUtil.cashOnDeliveryIcon,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      paymentMethod.value,
                      style: Style.titleTextStyle(AppTheme.blackTextColor, 14),
                    ),
                  ],
                )
            ),
          ),
          const SizedBox(height: 21),
          Text(
            "delivery_address".tr,
            style: Style.titleTextStyle(AppTheme.blackTextColor, 14),
          ),
          const SizedBox(height: 10),
          _buildDeliveryAddress(),
          const SizedBox(height: 21),
          Text(
            "products".tr,
            style: Style.titleTextStyle(AppTheme.blackTextColor, 14),
          ),
          const SizedBox(height: 10),
          _buildProducts(),
          const SizedBox(height: 21),
          Text(
            "price_details".tr,
            style: Style.titleTextStyle(AppTheme.blackTextColor, 14),
          ),
          const SizedBox(height: 20),
          Visibility(
            visible: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("shipping_charge".tr, style: Style.titleTextStyle(AppTheme.textColor, 15),),
                const Spacer(),
                Text("sar".tr, style: Style.titleTextStyle(AppTheme.secondaryTextColor, 15),),
                const SizedBox(width: 5),
                Text(orderDetail.priceDetails.shippingCharge ?? "0.0", style: Style.titleTextStyle(AppTheme.primaryColor, 15),),
              ],
            ),
          ),
          const Visibility(
              visible: true,
              child: SizedBox(height: 10)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("delivery_charge".tr, style: Style.titleTextStyle(AppTheme.textColor, 15),),
              const Spacer(),
              Text(getDeliveryCharge(), style: Style.titleTextStyle(AppTheme.greenButtonColor, 15),),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("discount".tr, style: Style.titleTextStyle(AppTheme.textColor, 15),),
              const Spacer(),
              Text(orderDetail.priceDetails.discount ?? "0.0", style: Style.titleTextStyle(AppTheme.greenButtonColor, 15),),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("total".tr, style: Style.titleTextStyle(AppTheme.textColor, 15),),
              const Spacer(),
              Text("sar".tr, style: Style.titleTextStyle(AppTheme.secondaryTextColor, 15),),
              const SizedBox(width: 5),
              Text(orderDetail.priceDetails.total ?? "0.0", style: Style.titleTextStyle(AppTheme.primaryColor, 15),),
            ],
          ),
        ],
      ),
    );
  }

  _buildDeliveryAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          orderDetail.shippingAddress.firstname ?? "",
          style: Style.titleTextStyle(AppTheme.blackTextColor, 14),
        ),
        Text(
          orderDetail.shippingAddress.telephone ?? "",
          style: Style.normalTextStyle(AppTheme.blackTextColor, 14),
        ),
        const SizedBox(height: 5),
        Text(
          (orderDetail.shippingAddress.street ?? "") + " " + (orderDetail.shippingAddress.city ?? ""),
          style: Style.normalTextStyle(AppTheme.blackTextColor, 14),
        ),
        Text(
          orderDetail.shippingAddress.region ?? "",
          style: Style.normalTextStyle(AppTheme.blackTextColor, 14),
        ),
      ],
    );
  }

  _buildProducts() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return ProductItemPage(productList[index]);
        });
  }

  String getDeliveryCharge() {
    var deliveryCharge = orderDetail.priceDetails.codCharge ?? "0.0";
    if(double.parse(deliveryCharge) == 0.0) {
      return "FREE";
    }
    return deliveryCharge;
  }
}