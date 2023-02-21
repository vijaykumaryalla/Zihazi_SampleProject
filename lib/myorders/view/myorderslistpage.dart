import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../service/networkerrors.dart';
import '../controller/myorderscontroller.dart';

class MyOrdersListPage extends StatefulWidget {
  const MyOrdersListPage({Key? key}) : super(key: key);

  @override
  _MyOrdersListPageState createState() => _MyOrdersListPageState();
}

class _MyOrdersListPageState extends State<MyOrdersListPage> {
  MyOrdersController controller = Get.find<MyOrdersController>();

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(()=>controller.buildMyOrders()),
            ],
          ),
        ) :
        PageErrorView((){}, NoInternetError()),
      ),
    );
  }
}
