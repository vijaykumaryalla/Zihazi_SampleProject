import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../baseclasses/app_button.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/custome_loader/lodading_indicator.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../controller/signupcontroller.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignupController controller = Get.find<SignupController>();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: 30,
              child:  IconButton(
                icon: const Icon(CupertinoIcons.arrow_left),
                onPressed: () {
                  Get.back();
                },
              ),),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 118, 30, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(child: Image.asset(ImageUtil.passwordLogo, height: 203, width: 220)),

                    const SizedBox(height: 49,),
                    Text(
                      "reset_password".tr,
                      style: Style.headingTextStyle(),
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: controller.signupFormKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          TextFormField(
                              obscureText: true,
                              controller: controller.passwordController,
                              validator: (value) {
                                return controller.validatePassword(value!);
                              },
                              decoration: Style.roundedTextFieldStyle("password".tr,
                                  "enter_password".tr, ImageUtil.passwordIcon),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20),
                              ]
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                              obscureText: true,
                              controller: controller.confirmpwdController,
                              validator: (value) {
                                return controller.validateConfirmPassword(value!);
                              },
                              decoration: Style.roundedTextFieldStyle(
                                  "confirm_password".tr,
                                  "enter".tr + " " + "confirm_password".tr,
                                  ImageUtil.confirmPasswordImg),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20),
                              ]
                          ),
                          Obx(() {
                            return  controller.resetPasswordError.value.isNotEmpty ? Column(
                              children: [
                                const SizedBox(height: 10,),
                                Text(controller.resetPasswordError.value,style: const TextStyle(
                                    fontSize: 12,fontWeight: FontWeight.w400,
                                    color: AppTheme.primaryColor
                                ),
                                ),
                              ],
                            ) : const SizedBox();
                          }
                          ),
                          const SizedBox(height: 76)
                        ],
                      ),
                    ),
                    AppButton("submit_button".tr,
                      height: 50,
                      radius: 25,
                      buttonBgColor:  AppTheme.primaryColor,
                      onTap: () {
                        controller.resetPasswordCall();
                      },
                    ),
                    // GestureDetector(
                    //   onTap: (){
                    //     // controller.callOTPSubmit();
                    //   },
                    //   child: Container(
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(25),
                    //       color: AppTheme.primaryColor,
                    //     ),
                    //     child: const Center(child: Text('Continue',
                    //       style:  TextStyle(
                    //           fontSize: 16,
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.w600
                    //       ),
                    //     )),
                    //
                    //   ),
                    // ),
                    Obx((){
                      return controller.loading.value==true?const Center(
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballRotateChase,
                            colors:  [AppTheme.primaryColor],
                            strokeWidth: 2,
                          ),
                        ),
                      ):Container();
                    })


                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
