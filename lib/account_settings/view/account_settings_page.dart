import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zihazi_sampleproject/account_settings/controller/account_settings_controller.dart';

import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  var controller = Get.find<AccountSettingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            "account_settings".tr,
            style: Style.titleTextStyle(Colors.black, 16.0),
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
        body: SingleChildScrollView(
            child: Column(
              children: [
                Obx(() => controller.buildView(context)),
                Obx(() => controller.handleEditApiResponse(context)),
              ],
            )
        ));
  }
}
