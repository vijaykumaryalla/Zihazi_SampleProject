import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../../service/networkerrors.dart';
import '../../splash/controller/splashcontroller.dart';

class ShowUpdatePage extends StatelessWidget {
  const ShowUpdatePage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<SplashController>();
    return Obx(() => Scaffold(
        backgroundColor: AppTheme.white,
        body: SafeArea(
          child: controller.isConnected.value ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(ImageUtil.updateIcon),
              const SizedBox(height: 20),
              Text("update_jihazi".tr, style: Style.headingTextStyle()),
              const SizedBox(height: 20),
              Text(
                "update_dialogue".tr,
                style: Style.subheadingTextStyle(14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: ElevatedButton(
                  onPressed: () {
                    if(Platform.isAndroid) {
                      _launchStore("https://play.google.com/store/apps/details?id=com.leader.Jihazi");
                    } else if(Platform.isIOS) {
                      _launchStore("https://apps.apple.com/us/app/jihazi-%D8%AC%D9%87%D8%A7%D8%B2%D9%8A/id1135268529?uo=4");
                    }
                  },
                  child: Text("update_app".tr,
                      style: Style.normalTextStyle(AppTheme.white, 14)),
                  style: Style.primaryButtonStyle(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ): PageErrorView((){}, NoInternetError()),
        )
    ));
  }

  void _launchStore(String storeLink) async {
    debugPrint(storeLink);
    try {
      if (await canLaunch(storeLink)) {
        print(storeLink);
        await launch(storeLink);
      } else {
        throw 'Could not launch';
      }
    } catch (e) {
      Get.snackbar("Message", 'Something went wrong');
    }
  }
}
