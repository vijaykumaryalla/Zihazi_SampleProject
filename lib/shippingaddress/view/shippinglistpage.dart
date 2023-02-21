import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zihazi_sampleproject/shippingaddress/view/shipingaddeditpage.dart';

import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../service/networkerrors.dart';
import '../binding/altershippingbinding.dart';
import '../controller/shippingcontroller.dart';

class ShippingListPage extends StatefulWidget {
  const ShippingListPage({Key? key}) : super(key: key);

  @override
  _ShippingListPageState createState() => _ShippingListPageState();
}

class _ShippingListPageState extends State<ShippingListPage> {
  ShippingController controller = Get.find<ShippingController>();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      controller.showSaveButton.value = false;
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("my_address".tr,
            style: Style.titleTextStyle(AppTheme.blackTextColor, 16)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(CupertinoIcons.arrow_left, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: controller.isConnected.value? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Obx(() => controller.buildAddressList()),
            Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: (
                      controller.shippingAddressResponse.value.responseStatus != Constants.loading &&
                          controller.showSaveButton.value
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("save_address".tr),
                        style: Style.rectangularRedButton(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: (controller.shippingAddressResponse.value.responseStatus != Constants.loading),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          _navigateAndRefresh(context);
                        },
                        child: Text("add_new_address".tr),
                        style: Style.rectangularRedButton(),
                      ),
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ): PageErrorView((){}, NoInternetError()),
    );
  }

  void _navigateAndRefresh(BuildContext context) async {
    await Get.to( () =>
        AddEditShippingAddress(null),
        binding: AlterShippingBinding()
    );
    controller.onInit();
  }

}
