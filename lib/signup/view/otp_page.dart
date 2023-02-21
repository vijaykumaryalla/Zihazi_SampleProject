import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import '../../baseclasses/app_button.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/custome_loader/lodading_indicator.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../controller/signupcontroller.dart';

class OTPPage extends StatelessWidget {
  const OTPPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignupController controller = Get.find<SignupController>();
    controller.setOTP();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: 20,
              child:  IconButton(
                icon: const Icon(CupertinoIcons.arrow_left),
                onPressed: () {
                  Get.back();
                },
              ),),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Image.asset(ImageUtil.otpLogo, height: 257, width: 216)),

                    const SizedBox(height: 49,),
                    Text(
                      "otp_heading".tr,
                      style: Style.headingTextStyle(),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Text(
                        "otp_subheading".tr + ' ' + controller.phoneNumber.value,
                        textAlign: TextAlign.center,
                        style: Style.subheadingTextStyle(16),
                      ),
                    ),
                    const SizedBox(height: 44),
                     Obx( () {
                 return Center(
                  child: OTPTextField(

                    otpFieldStyle: OtpFieldStyle(
                        borderColor: AppTheme.headingTextColor,
                        disabledBorderColor: AppTheme.lightGrey,
                        enabledBorderColor: AppTheme.headingTextColor,
                        focusBorderColor:AppTheme.headingTextColor,
                        backgroundColor: AppTheme.white,
                        errorBorderColor: AppTheme.primaryColor,
                    ),
                    obscureText: false,
                    controller: controller.otpController,
                    length: 6,
                    width: 300,
                    spaceBetween: 2,
                    textFieldAlignment: MainAxisAlignment.spaceBetween,
                    fieldWidth: 40,
                    fieldStyle: FieldStyle.box,
                    outlineBorderRadius: 6,
                    hasError: controller.otpError.value.isNotEmpty ? true : false,
                    style: const TextStyle(fontSize: 15),
                    onChanged: (value) {
                      controller.otpError.value = '';
                      controller.otpValue = value;

                    },
                    onCompleted: (pin) {
                      controller.otpError.value = '';
                      controller.otpValue = pin;
                    },
                  ),
                );
              }),
                    Obx(() {
                      return  controller.otpError.value.isNotEmpty ? Column(
                        children: [
                          const SizedBox(height: 10,),
                          Text(controller.otpError.value,style: const TextStyle(
                              fontSize: 12,fontWeight: FontWeight.w400,
                              color: AppTheme.primaryColor
                          ),
                          ),
                        ],
                      ) : const SizedBox();
                    }
                    ),
                    const SizedBox(height: 40,),
                    AppButton("submit_button".tr,
                      height: 50,
                      radius: 25,
                      buttonBgColor:  AppTheme.primaryColor,
                      onTap: () {
                        controller.otpVerification();
                      },
                    ),
                    // GestureDetector(
                    //   onTap: (){
                    //    // controller.callOTPSubmit();
                    //     controller.gotoResetPassword();
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
                    const SizedBox(height: 24,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() {
                          return Text(
                            controller.timerValue.value != '0'?
                            controller.timerValue.value + " " + "secs".tr :
                            "otp_resend".tr,
                          );
                        }),
                        const SizedBox(width: 53,),
                        Obx(() {
                          return InkWell(
                            onTap: () {
                              if (!controller.resendDisabled.value) {

                                controller.resendOtp();
                                controller.resendDisabled.value = true;
                                controller.resendTime = 60;
                                controller.startTimerForOTP();
                              }
                            },
                            child: Text(
                             " " + "resend_button".tr,
                              style: TextStyle(
                                color:
                                controller.resendDisabled.value
                                    ? AppTheme.grey5B5E60FF
                                    : AppTheme.primaryColor,
                              ),
                            ),
                          );
                        }),
                      ],
                    )


                  ],
                ),
              ),
            ),
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
    );

  }
}
