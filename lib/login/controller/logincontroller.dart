
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zihazi_sampleproject/baseclasses/basecontroller.dart';

import '../../baseclasses/sessions.dart';
import '../../baseclasses/utils/constants.dart';
import '../model/loginfailuremodel.dart';
import '../model/loginsuccessmodel.dart';
import '../repo/loginrepo.dart';

class LoginController extends BaseController{
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController passwordController;
  var repo = Get.find<LoginRepo>();
  var storageService = Get.find<StorageService>();
  var emailError = ''.obs;
  RxBool hidePassword = true.obs;

  var error = ''.obs;
  Rx<String> state = ''.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  LoginController() {
    checkConnection();
  }


  String? validateEmail(String value) {
    if(!GetUtils.isEmail(value)) {
      return "enter_valid_email_id".tr;
    }
    return null;
  }

  String? validatePassword(String value) {
    if(value.isEmpty) {
      return "password_cannot_be_empty".tr;
    }
    return null;
  }

  bool checkLogin() {
    final isValid = loginFormKey.currentState!.validate();
    if(isValid) {
      loginFormKey.currentState?.save();
      return true;
    }
    return false;
  }

  void login() async {
    state.value = Constants.loading;
    var result = await repo.login({
      "email": emailController.value.text,
      "password": passwordController.value.text,
      "os": _getOsName(),
    });
    try {
      if(result.error==null) {
        Map<String, dynamic> response = result.response;
        var successCode = response['SuccessCode'];
        if (successCode == 200) {
          LoginResponse loginResponse = LoginResponse.fromJson(result.response);
          if (loginResponse.data != null && loginResponse.data != "") {
            storageService.write(Constants.apiToken, loginResponse.token ?? '');
            storageService.write(Constants.userId, loginResponse.data?.userid ?? '');
            storageService.write(Constants.userName, loginResponse.data?.firstname ?? '');
            storageService.write(Constants.userPhone, loginResponse.data?.phone ?? '');
            storageService.write(Constants.userEmail, loginResponse.data?.email ?? '');
            state.value = Constants.success;
          }
          eventBus.fire(Constants.loginSuccess);
        } else {
          var baseResponse = LoginFailureResponse.fromJson(result.response);
          error(baseResponse.message);
          state.value = Constants.failure;
        }
      } else {
        error(result.error);
        state.value = Constants.failure;
      }
    } catch(e) {
      error("something_went_wrong".tr);
      state.value = Constants.failure;
    }
  }

  _getOsName() {
    if (Platform.isAndroid) {
      return 'android';
    } else {
      return 'ios';
    }
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
  }

}