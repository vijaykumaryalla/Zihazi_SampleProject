import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zihazi_sampleproject/home/binding/homebinding.dart';
import 'package:zihazi_sampleproject/home/view/homepage.dart';

import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../../service/networkerrors.dart';
import '../controller/logincontroller.dart';

class LoginPage extends StatefulWidget {
  final String productId;
  final String page;

  const LoginPage({Key? key, required this.productId, required this.page})
      : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController controller = Get.find<LoginController>();
  var data = Get.arguments;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
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
          body: controller.isConnected.value
              ? SingleChildScrollView(
                  child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Form(
                          key: controller.loginFormKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            children: [
                              Obx(() => _handleApiResponse(context)),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, bottom: 50),
                                  child: Image.asset(ImageUtil.appLogo,
                                      height: 62, width: 189)),
                              Text(
                                "welcome_back".tr,
                                style: Style.headingTextStyle(),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "login_to_continue".tr,
                                style: Style.subheadingTextStyle(16),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 30, left: 30, top: 30),
                                child: SizedBox(
                                  child: TextFormField(
                                    controller: controller.emailController,
                                    // validator: (value) {
                                    //   return controller.validateEmail(value!);
                                    // },
                                    decoration: Style.roundedTextFieldStyle(
                                        "email_address".tr,
                                        "enter_email".tr,
                                        ""),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 30, left: 30, top: 25),
                                child: SizedBox(
                                  child: TextFormField(
                                    controller: controller.passwordController,
                                    obscureText: controller.hidePassword.value,
                                    validator: (value) {
                                      return controller
                                          .validatePassword(value!);
                                    },
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 10.0),
                                        labelText: "password".tr,
                                        prefixIcon: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: IconButton(
                                            icon: SvgPicture.asset('',
                                                height: 16, width: 16),
                                            onPressed: null,
                                          ),
                                        ),
                                        suffix: TextButton(
                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent)),
                                          onPressed: () {
                                            controller.hidePassword.toggle();
                                          },
                                          child: Text(
                                              controller.hidePassword.value
                                                  ? "Show"
                                                  : "Hide",style: const TextStyle(color: AppTheme.primaryColor),),
                                        ),
                                        hintText: "enter_password".tr,
                                        errorMaxLines: 3,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(28.0),
                                          borderSide: const BorderSide(
                                            color: AppTheme.headingTextColor,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(28.0),
                                          borderSide: const BorderSide(
                                            color: AppTheme.headingTextColor,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(28.0),
                                          borderSide: const BorderSide(
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(28.0),
                                          borderSide: const BorderSide(
                                            color: AppTheme.primaryColor,
                                          ),
                                        )),

                                    // InputDecoration(
                                    //   suffix: TextButton(onPressed: () {
                                    //     controller.hidePassword.value= !controller.hidePassword.value;
                                    //   }, child: Text(controller.hidePassword.value?"Show":"hide"),
                                    //
                                    //   ),
                                    //   labelText: "password".tr,
                                    //   hintText: "enter_password".tr
                                    // ),
                                    // Style.roundedTextFieldStyle("password".tr,
                                    //     "enter_password".tr, ''),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(20),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: InkWell(
                                    onTap: () {
                                      Get.toNamed("/forgotpwd");
                                    },
                                    child: Text("forgot_password".tr + "?",
                                        style: Style.normalTextStyle(
                                            AppTheme.blackTextColor, 16)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                height: 50,
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // bool isValid = controller.checkLogin();
                                    // if (isValid) {
                                    //   controller.login();
                                    // }
                                    controller.login();
                                  },
                                  child: Text("login".tr,
                                      style: Style.normalTextStyle(
                                          AppTheme.white, 14)),
                                  style: Style.primaryButtonStyle(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("dont_have_an_account".tr,
                                      style: Style.normalTextStyle(
                                          AppTheme.subheadingTextColor, 16)),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed("/signup");
                                    },
                                    child: Text("sign_up".tr,
                                        style: Style.normalTextStyle(
                                            AppTheme.primaryColor, 16)),
                                  )
                                ],
                              ),
                              const SizedBox(height: 50),
                              Visibility(
                                  visible: false,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        child: Divider(
                                            thickness: 1,
                                            color: AppTheme.dividerColor),
                                        width: 100,
                                      ),
                                      Padding(
                                        child: Text("or Login with",
                                            style: Style.normalTextStyle(
                                                AppTheme.dividerColor, 16)),
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                      ),
                                      const SizedBox(
                                        child: Divider(
                                            thickness: 1,
                                            color: AppTheme.dividerColor),
                                        width: 100,
                                      )
                                    ],
                                  )),
                              const SizedBox(height: 30),
                              Visibility(
                                  visible: false,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: SvgPicture.asset(
                                            ImageUtil.gmailIcon),
                                        onPressed: () {},
                                        iconSize: 56,
                                      ),
                                      const SizedBox(width: 60),
                                      IconButton(
                                        icon: SvgPicture.asset(
                                            ImageUtil.facebookIcon),
                                        onPressed: () {},
                                        iconSize: 43,
                                      )
                                    ],
                                  )),
                            ],
                          ))))
              : PageErrorView(() {}, NoInternetError()),
        ));
  }

  _showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 40,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            child: Center(
                child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 15),
                Text(
                  "logging_in".tr,
                  style: Style.normalTextStyle(AppTheme.primaryColor, 14),
                ),
              ],
            )),
          ),
        );
      },
    );
  }

  _handleApiResponse(BuildContext context) {
    if (controller.state.value == Constants.failure) {
      Navigator.of(context).pop();
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
      Navigator.of(context).pop();
      Future.delayed(Duration.zero, () async {
        if (widget.page == Constants.splash) {
          Get.offAll(const HomePage(), binding: HomeBinding());
        } else if (widget.page == Constants.productList) {
          Get.close(1);
        } else if (widget.page == Constants.cart) {
          Get.close(1);
        } else {
          Get.offAndToNamed("/${widget.page}", arguments: widget.productId);
        }
      });
    }
    return Container();
  }
}
