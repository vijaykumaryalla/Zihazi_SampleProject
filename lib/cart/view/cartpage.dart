
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../service/networkerrors.dart';
import '../controller/cartcontroller.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("my_cart".tr,
            style: Style.titleTextStyle(AppTheme.blackTextColor, 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: controller.isConnected.value? SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => controller.buildCartList()),
              Obx(() => controller.handleRemoveItemResponse(context)),
              Obx(() => controller.handleUpdateItemResponse(context)),
              Obx(() => controller.handlePromoResponse(context)),
              Obx(() => controller.handleRemovePromoResponse(context)),
            ],
          ),
        ) :
        PageErrorView((){}, NoInternetError()),
      ),
    );
  }
}
