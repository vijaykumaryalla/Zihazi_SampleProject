import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../baseclasses/basecontroller.dart';
import '../../baseclasses/basefailuremodel.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../../service/networkerrors.dart';
import '../repo/changepasswordrepo.dart';

class ChangePasswordController extends BaseController {
  var oldPassword = '';
  var newPassword = '';
  var confirmPassword = '';
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  var repo = Get.find<ChangePasswordRepo>();
  var changePwdResponse=ResponseInfo(responseStatus: Constants.loading).obs;
  var storageService = Get.find<StorageService>();
  @override
  void onInit() {
    super.onInit();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  changePasswordView() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 200.0,
          color: AppTheme.greyf0f0f0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SvgPicture.asset(ImageUtil.imgChangePwd),
              Image.asset(ImageUtil.imgChangePwd,height: 200,width: 200,)
            ],
          ),

        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20,width:0,),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: oldPasswordController,
                onChanged: (value) {
                  oldPassword = value;
                },
                validator: (value) {

                },
                decoration: Style.textFieldWithoutIconStyle(
                    "current_password".tr),
              ),
              SizedBox(height: 20,width:0,),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: newPasswordController,
                onChanged: (value) {
                  newPassword = value;
                },
                validator: (value) {

                },
                decoration: Style.textFieldWithoutIconStyle(
                    "new_password".tr),
              ),
              SizedBox(height: 20,width:0,),
              TextFormField(
                textInputAction: TextInputAction.done,
                controller: confirmPasswordController,
                onChanged: (value) {
                  confirmPassword = value;
                },
                validator: (value) {

                },
                decoration: Style.textFieldWithoutIconStyle(
                    "confirm_password".tr),
              ),
            ],
          ),
        ),

      ],
    );
  }

  Future<void> callChangePasswordApi() async {

    var userId = await storageService.read(Constants.userId);
    var result = await repo.requestChangePassword({
      "userid":userId,
      "currentpwd":oldPassword,
      "newpwd":newPassword
    });
    try {
      if(result.error==null){
        var responseCode = result.response['SuccessCode'];
        if(responseCode==200){
          var message = result.response['message'];
          Get.snackbar("message".tr, message);
          oldPasswordController.text="";
          newPasswordController.text="";
          confirmPasswordController.text="";

          changePwdResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: responseCode,respMessage: message);
        } else{
          var message = result.response['message'];
          Get.snackbar("message".tr, message);
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          changePwdResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: baseFailureModel.responseCode,respMessage: baseFailureModel.message);
        }
      }
      else{
        changePwdResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      changePwdResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }

  }

  void validateFields() {

    if(oldPassword.trim().isNotEmpty&&newPassword.trim().isNotEmpty&&confirmPassword.trim().isNotEmpty&&newPassword==confirmPassword){
      callChangePasswordApi();
      return;
    }

    if(oldPassword.trim().isEmpty){
      Get.snackbar("message".tr, "enter_current_password".tr);
      return;
    }

    if(newPassword.trim().isEmpty){
      Get.snackbar("message".tr, "enter_new_password".tr);
      return;
    }

    if(confirmPassword.trim().isEmpty){
      Get.snackbar("message".tr, "confirm_new_password".tr);
      return;
    }

    if(newPassword!=confirmPassword){
      Get.snackbar("message".tr, "password_mismatch".tr);
      return;
    }
  }

}