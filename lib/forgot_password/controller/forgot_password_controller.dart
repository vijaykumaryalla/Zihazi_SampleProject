import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../baseclasses/basecontroller.dart';
import '../repo/forgot_password_repo.dart';

class ForgotPwdController extends BaseController{
  var repo = Get.put(ForgotPwdRepo());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var email = '';
  late TextEditingController emailController;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
  }

  bool isValid() {
    final isValid = formKey.currentState!.validate();
    if(isValid) {
      formKey.currentState?.save();
      return true;
    }
    return false;
  }

  String? validateEmail(String value) {
    if(!GetUtils.isEmail(value)) {
      return "enter_valid_email_id".tr;
    }
    return null;
  }

  Future<String?> sendEmailData() async {

    var result = await repo.sendata({"email": emailController.value.text,"phonenumber":""});

    try {
      if(result.response!=null){
        var response = result.response;

        var successCode = response['SuccessCode'];
        print(successCode);
        if(successCode==200) {
          emailController.clear();
          var message =response['message'];

          return message;
        } else {
          var message =response['message'];

          return message;
        }
      }
      else if(result.error!=null){
        //Error
        return "";

      }
    } catch (e) {
      print(e);
    }
    return "";
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
  }

}