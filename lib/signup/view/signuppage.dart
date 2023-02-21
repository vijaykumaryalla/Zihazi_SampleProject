import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:zihazi_sampleproject/signup/view/privacypolicy.dart';
import 'package:zihazi_sampleproject/signup/view/termsandcondition.dart';

import '../../baseclasses/app_button.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/custome_loader/lodading_indicator.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../controller/signupcontroller.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool checkboxValue = false;
  SignupController controller = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Obx(() => _handleApiResponse(context)),
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
              padding: const EdgeInsets.fromLTRB(30, 80, 30, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(child: Image.asset(ImageUtil.appLogo, height: 62, width: 189)),

                    const SizedBox(height: 80,),
                    Text(
                      "create_account".tr,
                      style: Style.headingTextStyle(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "mobile_number_enter".tr,
                      style: Style.subheadingTextStyle(16),
                    ),
                    const SizedBox(height: 80),
                    Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              padding: const EdgeInsets.only(left: 15, right: 15) ,
                              decoration: BoxDecoration(
                                border: Border.all(color: controller.isNumberError.value ? AppTheme.primaryColor : AppTheme.headingTextColor, width: 1),
                                borderRadius: BorderRadius.circular(25)
                              ),
                              child:   InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  print(number.phoneNumber);
                                  controller.number = number;
                                  controller.changeNumberText();
                                },
                                onInputValidated: (bool value) {
                                  // print(value);
                                  controller.isTextEdited = true;
                                  controller.isNumberError.value = !value;
                                },
                                selectorConfig: const SelectorConfig(
                                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                ),
                                hintText: "phone_number".tr,
                                keyboardType: TextInputType.phone,
                                ignoreBlank: false,
                                autoValidateMode: AutovalidateMode.disabled,
                                selectorTextStyle: const TextStyle(color: Colors.black),
                                initialValue: controller.number,
                                textFieldController: controller.phoneController,
                                inputBorder: InputBorder.none,
                                formatInput: false,
                                // keyboardType:
                                // const TextInputType.numberWithOptions(signed: true, decimal: true),
                                onSaved: (PhoneNumber number) {
                                  controller.number = number;
                                },
                              ),
                            ),
                            SizedBox(height: controller.isNumberError.value ? 4 :0,),
                            controller.isNumberError.value ?  Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("valid_number".tr,
                                style:  const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: AppTheme.primaryColor,
                                  fontSize: 11,
                                ),
                              ),
                            ) :   const SizedBox(height: 0,),
                            const SizedBox(height: 62,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: AppTheme.primaryColor,
                                        value: checkboxValue,
                                        shape: const CircleBorder(),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            checkboxValue = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Expanded(
                                    flex: 2,
                                    child: Text("i_agree_the".tr,
                                        style: Style.normalTextStyle(
                                            AppTheme.blackTextColor, 12)),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: InkWell(
                                      child: Text("terms_and_conditions".tr,
                                          style: Style.normalTextStyle(
                                              AppTheme.primaryColor, 12)),
                                      onTap: () {
                                        _showBottomSheet(context, false);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Text("and".tr,
                                        style: Style.normalTextStyle(
                                            AppTheme.blackTextColor, 12)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: InkWell(
                                      child: Text("privacy".tr,
                                          style: Style.normalTextStyle(
                                              AppTheme.primaryColor, 12)),
                                      onTap: () {
                                        _showBottomSheet(context, true);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                          AppButton("sign_up".tr,
                            height: 50,
                            radius: 25,
                            buttonBgColor: checkboxValue ? AppTheme.primaryColor : AppTheme.dividerColor,
                            onTap: () {
                            if(checkboxValue) {
                            //  controller. mobileSignup();
                             controller.checkSignUp();
                             //    bool isValid = controller.checkSignUp();
                             //    if (isValid) {
                             //      controller.signup();
                             //  }
                            }
                              // checkboxValue ?
                              //   : null;
                             //   controller.gotoOtp()
                            },

                          ),
                            // Container(
                            //   width: double.infinity,
                            //   height: 50,
                            //   padding: const EdgeInsets.only(left: 30, right: 30),
                            //   child: ElevatedButton(
                            //     onPressed: checkboxValue ? () {
                            //       // if (checkboxValue) {
                            //       //   bool isValid = controller.checkSignUp();
                            //       //   if (isValid) {
                            //       //     controller.signup();
                            //       //   }
                            //       // }
                            //       controller.gotoOtp();
                            //     } : null,
                            //     style: ElevatedButton.styleFrom(
                            //         elevation: 2,
                            //         onSurface: Colors.grey,
                            //         onPrimary: AppTheme.primaryColor,
                            //         shape: const RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.all(Radius.circular(25))
                            //         )
                            //     ),
                            //     // disabledColor: Colors.grey,
                            //     //   color: AppTheme.primaryColor,
                            //     child: Text("sign_up".tr,
                            //         style: Style.normalTextStyle(AppTheme.white, 14)),
                            //     //   shape: RoundedRectangleBorder(
                            //     //     borderRadius: BorderRadius.circular(32.0),
                            //     //   )
                            //   ),
                            // ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("already_have_an_account".tr + " ",
                                    style: Style.normalTextStyle(
                                        AppTheme.subheadingTextColor, 16)),
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Text("login".tr,
                                      style: Style.normalTextStyle(
                                          AppTheme.primaryColor, 16)),
                                )
                              ],
                            ),
                            const SizedBox(height: 10)


                          ],
                        );
                      }
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
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
              child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.arrow_left),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child:
                        Image.asset(ImageUtil.appLogo, height: 62, width: 189)),
                Text(
                  "welcome".tr,
                  style: Style.headingTextStyle(),
                ),
                const SizedBox(height: 5),
                Text(
                  "signup_to_continue".tr,
                  style: Style.subheadingTextStyle(16),
                ),
                const SizedBox(height: 15),
                Form(
                  key: controller.signupFormKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      Obx(() => _handleApiResponse(context)),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 30, left: 30, top: 20),
                        child: SizedBox(
                          child: TextFormField(
                            controller: controller.firstnameController,
                            validator: (value) {
                              return controller.validateTextField(value!);
                            },
                            decoration: Style.roundedTextFieldStyle("firstname".tr,
                                "enter".tr + " " + "firstname".tr, ImageUtil.userImg),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 30, left: 30, top: 20),
                        child: SizedBox(
                          child: TextFormField(
                            controller: controller.lastnameController,
                            validator: (value) {
                              return controller.validateTextField(value!);
                            },
                            decoration: Style.roundedTextFieldStyle("lastname".tr,
                                "enter".tr + " " + "lastname".tr, ImageUtil.userImg),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 30, left: 30, top: 20),
                        child: SizedBox(
                          child: TextFormField(
                            controller: controller.emailController,
                            validator: (value) {
                              return controller.validateEmail(value!);
                            },
                            decoration: Style.roundedTextFieldStyle(
                                "email".tr, "enter_email".tr, ImageUtil.emailIcon),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 30, left: 30, top: 20),
                        child: SizedBox(
                          child: TextFormField(
                            controller: controller.phoneController,
                            validator: (value) {
                              return controller.validateTextField(value!);
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              LengthLimitingTextInputFormatter(10)
                            ],
                            decoration: Style.roundedTextFieldStyle(
                                "phone_number".tr,
                                "enter".tr + " " + "phone_number".tr,
                                ImageUtil.phoneImg),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 30, left: 30, top: 20),
                        child: SizedBox(
                          child: TextFormField(
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
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 30, left: 30, top: 20),
                        child: SizedBox(
                          child: TextFormField(
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
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 30, left: 30, top: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Transform.scale(
                                scale: 1.2,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: AppTheme.primaryColor,
                                  value: checkboxValue,
                                  shape: const CircleBorder(),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkboxValue = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              flex: 2,
                              child: Text("i_agree_the".tr,
                                  style: Style.normalTextStyle(
                                      AppTheme.blackTextColor, 12)),
                            ),
                            Expanded(
                              flex: 4,
                              child: InkWell(
                                child: Text("terms_and_conditions".tr,
                                    style: Style.normalTextStyle(
                                        AppTheme.primaryColor, 12)),
                                onTap: () {
                                  _showBottomSheet(context, false);
                                },
                              ),
                            ),
                            Expanded(
                              child: Text("and".tr,
                                  style: Style.normalTextStyle(
                                      AppTheme.blackTextColor, 12)),
                            ),
                            Expanded(
                              flex: 2,
                              child: InkWell(
                                child: Text("privacy".tr,
                                    style: Style.normalTextStyle(
                                        AppTheme.primaryColor, 12)),
                                onTap: () {
                                  _showBottomSheet(context, true);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: 50,
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: ElevatedButton(
                          onPressed: checkboxValue ? () {
                            if (checkboxValue) {
                              bool isValid = controller.checkSignUp();
                              if (isValid) {
                                controller.signup();
                              }
                            }
                          } : null,
                            style: ElevatedButton.styleFrom(
                                elevation: 2,
                                onSurface: Colors.grey,
                                onPrimary: AppTheme.primaryColor,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(6))
                                )
                            ),
                          // disabledColor: Colors.grey,
                          //   color: AppTheme.primaryColor,
                          child: Text("sign_up".tr,
                              style: Style.normalTextStyle(AppTheme.white, 14)),
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(32.0),
                          //   )
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("already_have_an_account".tr + " ",
                              style: Style.normalTextStyle(
                                  AppTheme.subheadingTextColor, 16)),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Text("login".tr,
                                style: Style.normalTextStyle(
                                    AppTheme.primaryColor, 16)),
                          )
                        ],
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                )
              ],
            ),
          )),
        ));
  }

  _handleApiResponse(BuildContext context) {
    if (controller.state.value == Constants.failure) {
      Get.back();
      Future.delayed(Duration.zero, () async {
        Get.snackbar("message".tr, controller.error.value);
      });
    }
    if (controller.state.value == Constants.loading) {
      Future.delayed(Duration.zero, () async {
        _showLoadingDialog(context);
      });
    }

    if (controller.state.value == Constants.success) {
      Get.back();
      // Future.delayed(Duration.zero, () async {
      //   Get.offAll(const HomePage(),binding: HomeBinding());
      // });
    }
    return Container();
  }

  _showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 40,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0))
            ),
            child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(width: 15),
                    Text(
                      "signing_up".tr,
                      style: Style.normalTextStyle(AppTheme.primaryColor, 14),
                    ),
                  ],
                )
            ),
          ),
        );
      },
    );
  }

  _showBottomSheet(BuildContext context, bool isPrivacyPolicy) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => isPrivacyPolicy
          ? const Padding(
              padding: EdgeInsets.only(top: 35),
              child: PrivacyPolicy(),
            )
          : const Padding(
              padding: EdgeInsets.only(top: 35),
              child: TermsAndCondition(),
            ),
    );
  }
}
