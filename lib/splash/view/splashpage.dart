import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/utils/constants.dart';
import '../../home/binding/homebinding.dart';
import '../../home/view/homepage.dart';
import '../../home/view/update_diologbox.dart';
import '../../login/binding/loginbinding.dart';
import '../../login/view/loginpage.dart';
import '../../service/networkerrors.dart';
import '../controller/splashcontroller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  var storageService = Get.find<StorageService>();

  @override
  void initState() {
    navigateScreen();
    // navigateOrUpdate();
    super.initState();
  }

  navigateOrUpdate() {
    final ref = FirebaseDatabase.instance.ref();
    ref
        .child("app_version")
        .once()
        .then((data) => handleUpdateDialog(data.snapshot.value));
  }

  handleUpdateDialog(dynamic latestVersion) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo.version);
    if (Version.parse(latestVersion) > Version.parse(packageInfo.version)) {
      Get.off(()=> const ShowUpdatePage());
    } else {
      Future.delayed(const Duration(milliseconds: 1500), () {
        Get.off(()=> const HomePage(),binding: HomeBinding());
      });
    }
  }

  navigateScreen() async {
    bool isLoggedIn = await storageService.checkLogin();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if(isLoggedIn) {
        Get.off(const HomePage(),binding: HomeBinding());
      } else {
        Get.off(const LoginPage(page: Constants.splash, productId: '0',), binding: LoginBinding());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<SplashController>();
    return Obx(() => Scaffold(
        body: SafeArea(
          child: controller.isConnected.value? Center(
              child: Container(
                height: 200,width: 200,
                margin:const EdgeInsets.only(left: 48,right: 48),
                child: Image.asset('assets/images/splash_logo.png'),
              )
          ):  PageErrorView((){}, NoInternetError()),
        )
    ));
  }
}
