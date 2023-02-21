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
import '../controller/contactuscontroller.dart';
class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();


}

class _ContactUsPageState extends State<ContactUsPage> {

  var controller=Get.find<ContactUsController>();

  @override
  Widget build(BuildContext context) {

    return Obx (() => (
        Scaffold (
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text("contact_us".tr,style: Style.customTextStyle(Colors.black, 16.0,FontWeight.bold,FontStyle.normal),),
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
            child:controller.isConnected.value? Container(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                      controller.contactUsView(),
                      controller.handleAPIResponse(context),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: Style.elevatedNormalRedButton(),
                              onPressed: (){
                                controller.validateAndCallApi();
                              },
                              child:Text("send".tr,style: Style.normalTextStyle(Colors.white, 18.0),)
                          ),
                        ),

                        Align(
                            alignment : Alignment.bottomCenter,
                            child: InkWell(
                              onTap: (){
                                Get.back();
                              },
                                child: Text("cancel".tr,style: Style.customTextStyle(Colors.black, 18.0,FontWeight.bold,FontStyle.normal),))
                        ),

                        controller.bottomView()

                        ],
                      ),
                      )
                ],
              ),
            ):
            PageErrorView((){}, NoInternetError()),
          ),


        )
    )
    );
  }

}