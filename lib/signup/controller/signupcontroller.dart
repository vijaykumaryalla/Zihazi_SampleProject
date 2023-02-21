import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:otp_text_field/otp_field.dart';

import '../../baseclasses/basecontroller.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/utils/constants.dart';
import '../../home/binding/homebinding.dart';
import '../../home/view/homepage.dart';
import '../model/mobile_signup_model.dart';
import '../model/signupmodel.dart';
import '../repo/signuprepo.dart';

class SignupController extends BaseController {
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController phoneController;
  late TextEditingController confirmpwdController;
  var storageService = Get.find<StorageService>();

  var error = ''.obs;
  var repo = Get.find<SignupRepo>();
  Rx<String> state = ''.obs;
  String initialCountry = 'SA';
  PhoneNumber number = PhoneNumber(isoCode: 'SA');
  var isNumberError = false.obs;
  var isTextEdited = false;

  var loading=false.obs;



  //for otp page
  RxString phoneNumber = ''.obs;
  OtpFieldController otpController = OtpFieldController();
  String otpValue = '';
  late final Timer _resendTimer;
  RxString timerValue = "".obs;
  RxBool resendDisabled = true.obs;
  int resendTime = 60;
  final otpError = ''.obs;
  final resetPasswordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    phoneController = TextEditingController();
    confirmpwdController = TextEditingController();

  }

  String? validateEmail(String value) {
    if(!GetUtils.isEmail(value)) {
      return "enter_valid_email_id".tr;
    }
    return null;
  }

  String? validatePassword(String value) {
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if(value.isEmpty) {
      return "field_should_not_be_empty".tr;
    } else if(value.length < 8) {
      return "password_should_be_at_least_letters_long".tr;
    } else if(!regExp.hasMatch(value)) {
      return "password_constrain".tr;
    }
    return null;
  }

  String? validateConfirmPassword(String value) {
    if(value.compareTo(passwordController.value.text) == 0) {
      return null;
    }
    return "password_should_be_same".tr;
  }

  String? validateTextField(String value) {
    if(value.isEmpty) {
      return "field_should_not_be_empty".tr;
    }
    return null;
  }

  checkSignUp() {
    // final isValid = signupFormKey.currentState!.validate();
    // if(isValid) {
    //   signupFormKey.currentState?.save();
    //   return true;
    // }
    // return false;
    if(!isTextEdited){
      isNumberError.value = true;
    }

    if(!isNumberError.value) {
      mobileSignup();
    } else {
      print("not a valid number");
    }
    // if(number.phoneNumber != null) {
    //   isNumberError.value = false;
    //   mobileSignup();
    // } else {
    //   isNumberError.value = true;
    // }
  }

  changeNumberText() {
    isNumberError.value = false;
  }

  void mobileSignup() async {
    // state.value = Constants.loading;
    loading.value = true;
    var result = await repo.mobileSignup({
      "phonenumber": number.phoneNumber ?? "",
      "resend": 0
    });
    try {
      if(result.error==null) {
        var response = result.response;
        // var successCode = response['SuccessCode'];
        SignupResponse signupResponse = SignupResponse.fromJson(result.response);
        if (signupResponse.successCode == 200) {
          loading.value = false;
          // state.value = Constants.success;
          Get.snackbar("message".tr, signupResponse.message);
          gotoOtp();

        } else {
          loading.value = false;
          Get.snackbar("message".tr, signupResponse.message);
        }
      } else {
        loading.value = false;
        Get.snackbar("message".tr, "something_went_wrong".tr);
      }
    } catch(e) {
      loading.value = false;
      Get.snackbar("message".tr, "something_went_wrong".tr);
    }

    // Get.snackbar("message".tr, "signupResponse.message");
    // gotoOtp();
  }
  void signup() async {
    state.value = Constants.loading;
    var result = await repo.signup({
      "firstname":firstnameController.value.text,
      "lastname":lastnameController.value.text,
      "email": emailController.value.text,
      "password": passwordController.value.text,
      "phonenumber": phoneController.value.text
    });
    try {
      if(result.error==null) {
        var response = result.response;
        var successCode = response['SuccessCode'];
        if (successCode == 200) {
          SignupResponse signupResponse = SignupResponse.fromJson(result.response);
          if (signupResponse.data != "") {
            storageService.write(Constants.userId, signupResponse.data.userid.toString());
            storageService.write(Constants.userName, signupResponse.data.firstname);
            storageService.write(Constants.userEmail, signupResponse.data.email);
            state.value = Constants.success;
          }
        } else {
          var message =response['message'];
          error(message);
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

  void gotoOtp() {
    var model  = MobileSignupModel();
    model.mobileNumber = number.phoneNumber ?? "";
    model.type = RouteView.otp;
    Get.toNamed('/otp', arguments: model);
  }

  void gotoResetPassword() {
    var model  = MobileSignupModel();
    model.mobileNumber = number.phoneNumber ?? "";
    model.otp = otpValue;
    model.type = RouteView.resetPassword;
    Get.toNamed('/resetpassword', arguments: model);
  }

  void setOTP(){
    if(phoneNumber.isEmpty && Get.arguments != null) {
      MobileSignupModel model = Get.arguments;
      phoneNumber.value = model.mobileNumber;
      startTimerForOTP();
    }
  }


  void startTimerForOTP() {
    const oneSec = Duration(seconds: 1);
    _resendTimer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (resendTime == 0) {
          timer.cancel();
          resendDisabled.value = false;
        } else {
          resendTime--;
          timerValue.value = resendTime.toString();
        }
      },
    );
  }


  void resendOtp() async{
    loading.value = true;
    var result = await repo.mobileSignup({
      "phonenumber":  phoneNumber.value,
      "resend": 1
    });
    try {
      if(result.error==null) {

        var response = result.response;
        SignupResponse signupResponse = SignupResponse.fromJson(result.response);
        if (signupResponse.successCode == 200) {
          _resendTimer.cancel();
          loading.value = false;
          // if (signupResponse.data != "") {
          //   storageService.write(Constants.userId, signupResponse.data.userid.toString());
          //   storageService.write(Constants.userName, signupResponse.data.firstname);
          //   storageService.write(Constants.userEmail, signupResponse.data.email);
          //   state.value = Constants.success;
          // }
          Get.snackbar("message".tr, signupResponse.message);

        } else {
          loading.value = false;
          Get.snackbar("message".tr, signupResponse.message);
        }
      } else {
        loading.value = false;
        Get.snackbar("message".tr, "something_went_wrong".tr);
      }
    } catch(e) {
      loading.value = false;
      Get.snackbar("message".tr, "something_went_wrong".tr);
    }
  }



  void otpVerification() async {
    if(otpValue.isEmpty) {
      otpError.value = 'otp_empty'.tr;
    } else {
      // state.value = Constants.loading;
      loading.value = true;
      var result = await repo.otpVerification({
        "phonenumber": phoneNumber.value,
        "otp": otpValue
      });
      try {
        if(result.error==null) {
          loading.value = false;
          // var successCode = response['SuccessCode'];
          SignupResponse signupResponse = SignupResponse.fromJson(result.response);
          if (signupResponse.successCode == 200) {
            Get.snackbar("message".tr, signupResponse.message);
            gotoResetPassword();

          } else {
            // var message =response['message'];
            // error(message);
            // state.value = Constants.failure;
            loading.value = false;
            otpError.value = 'otp_invalid'.tr;
            otpController.clear();
            Get.snackbar("message".tr, signupResponse.message);
          }
        } else {
          loading.value = false;
          otpController.clear();
          Get.snackbar("message".tr, "something_went_wrong".tr);
          // loading.value = false;
          // error(result.error);
          // state.value = Constants.failure;
        }

      } catch(e) {
        loading.value = false;
        Get.snackbar("message".tr, "something_went_wrong".tr);
        // error("something_went_wrong".tr);
        // state.value = Constants.failure;
      }
    }
  }


  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    phoneController.dispose();
    confirmpwdController.dispose();
  }

  void resetPasswordCall() async {

    if(passwordController.text != confirmpwdController.text) {
      resetPasswordError.value = 'password_should_be_same'.tr;
    } else {
      // state.value = Constants.loading;
      loading.value = true;
      var result = await repo.resetPasswordCall({
        "phonenumber": phoneNumber.value,
        "otp": otpValue,
        "password": passwordController.text
      });
      try {
        if(result.error==null) {
          loading.value = false;
          // var successCode = response['SuccessCode'];
          SignupResponse signupResponse = SignupResponse.fromJson(result.response);
          if (signupResponse.successCode == 200) {
            Get.snackbar("message".tr, "signup_success".tr);
            storageService.write(Constants.userId, signupResponse.data.userid.toString());
            storageService.write(Constants.apiToken, signupResponse.data.token ?? '');
            Future.delayed(Duration.zero, () async {
              Get.offAll(const HomePage(),binding: HomeBinding());
            });
            // storageService.write(Constants.userName, signupResponse.data.firstname);
            // storageService.write(Constants.userEmail, signupResponse.data.email);

            // Get.offAll(const LoginPage(page: Constants.splash, productId: '0',), binding: LoginBinding());

          } else {
            // var message =response['message'];
            // error(message);
            // state.value = Constants.failure;
            loading.value = false;
            Get.snackbar("message".tr, signupResponse.message);
          }
        } else {
          loading.value = false;
          Get.snackbar("message".tr, "something_went_wrong".tr);
          // loading.value = false;
          // error(result.error);
          // state.value = Constants.failure;
        }

      } catch(e) {
        loading.value = false;
        Get.snackbar("message".tr, "something_went_wrong".tr);
        // error("something_went_wrong".tr);
        // state.value = Constants.failure;
      }
    }
  }

}