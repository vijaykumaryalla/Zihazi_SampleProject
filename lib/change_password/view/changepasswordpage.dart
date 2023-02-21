
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../service/networkerrors.dart';
import '../controller/changepasswordcontroller.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();

}

class _ChangePasswordState extends State<ChangePasswordPage> {

  var controller=Get.find<ChangePasswordController>();

  @override
  Widget build(BuildContext context) {
    return Obx (() => (
        Scaffold (
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text("change_password".tr,style: Style.customTextStyle(Colors.black, 16.0,FontWeight.bold,FontStyle.normal),),
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
            child:controller.isConnected.value? Column(
              children: [
                Expanded(child: controller.changePasswordView()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: Style.elevatedNormalRedButton(),
                      onPressed: (){
                        controller.validateFields();
                      },
                      child:Text("submit".tr,style: Style.normalTextStyle(Colors.white, 18.0),)
                  ),
                ),

                Align(
                    alignment : Alignment.bottomCenter,
                    child: InkWell(
                        onTap: (){
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text("cancel".tr,style: Style.normalTextStyle(Colors.black, 18.0),),
                        ))
                )



              ],
            ):
            PageErrorView((){}, NoInternetError()),
          ),


        )
    )
    );
  }

}