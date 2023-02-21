import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../service/networkerrors.dart';
import '../controller/accountcontroller.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  var controller = Get.find<AccountController>();
  var storageService = Get.find<StorageService>();

  @override
  Widget build(BuildContext context) {
    controller.refresh();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("my_account".tr,
            style: Style.titleTextStyle(AppTheme.blackTextColor, 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: controller.isConnected.value
            ? SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => controller.buildMyAccount()),
            ],
          ),
        )
            : PageErrorView(() {}, NoInternetError()),
      ),
    );
  }
}