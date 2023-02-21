
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../service/networkerrors.dart';
import '../controller/orderdetailcontroller.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  String orderId = Get.arguments[0];
  OrderDetailController controller = Get.find<OrderDetailController>();

  @override
  Widget build(BuildContext context) {
    controller.getOrderDetail(orderId);
    return Obx( () {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "my_orders".tr,
            style: Style.titleTextStyle(AppTheme.blackTextColor, 16),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              CupertinoIcons.arrow_left,
              color: AppTheme.black,
            ),
          ),
        ),
        body: SafeArea(
          child: controller.isConnected.value? SingleChildScrollView(
              child: Obx(() => controller.handleResponse())
          ) :
          PageErrorView((){}, NoInternetError()),
        ),
      );
    });
  }
}
