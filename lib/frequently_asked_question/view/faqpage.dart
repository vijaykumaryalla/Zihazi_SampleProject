import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../service/networkerrors.dart';
import '../controller/faqcontroller.dart';

class FaqPage extends StatefulWidget{
  const FaqPage({Key? key}) : super(key: key);

  @override
  _FaqPageState createState() => _FaqPageState();


}

class _FaqPageState extends State<FaqPage> {

  var controller=Get.find<FaqController>();

  @override
  Widget build(BuildContext context) {
    return Obx (() => (
        Scaffold (
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text("faq".tr,style: Style.customTextStyle(Colors.black, 16.0,FontWeight.bold,FontStyle.normal),),
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
          backgroundColor: AppTheme.white,
          body: SafeArea(
            child:controller.isConnected.value? SingleChildScrollView(
              child: controller.faqView()
            ):
            PageErrorView((){}, NoInternetError()),
          ),


        )
    )
    );
  }

}