
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zihazi_sampleproject/baseclasses/basecontroller.dart';

import '../../baseclasses/basefailuremodel.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/custome_loader/lodading_indicator.dart';
import '../../service/networkerrors.dart';
import '../../shippingaddress/binding/altershippingbinding.dart';
import '../../shippingaddress/view/shipingaddeditpage.dart';
import '../model/account_settings.dart';
import '../repo/account_settings_repo.dart';

class AccountSettingController extends BaseController{
  var storageService = Get.find<StorageService>();
  var repo = Get.find<AccountSettingRepo>();
  var accountResponse = ResponseInfo(responseStatus: Constants.loading).obs;
  var editResponse = ResponseInfo(responseStatus: Constants.idle).obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late AccountSettings accountSettings;
  late BillingAddress billingAddress;
  RxInt selectedIndex = 0.obs;
  var showAddress = false.obs;
  final RxBool _switchValue = true.obs;
  late TextEditingController emailController;
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;

  @override
  void onInit() {
    super.onInit();
    getAccountDetail();
    emailController = TextEditingController();
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
  }

  void getAccountDetail() async {
    accountResponse.value = ResponseInfo(responseStatus: Constants.loading);
    var userId = await storageService.read(Constants.userId);
    var result = await repo.getAccountDetails({
      "userid": userId
    });
    try {
      if(result.error==null){
        var responseCode = result.response['SuccessCode'];
        if(responseCode==200){
          var successModel = AccountSettings.fromJson(result.response);
          accountSettings = successModel;
          await storageService.write(Constants.userPhone, accountSettings.data.mobilenumber);
          if(accountSettings.data.billingAddress.id.isEmpty) {
            showAddress.value = false;
          } else {
            showAddress.value = true;
            billingAddress = accountSettings.data.billingAddress;
          }
          setInputValues();
          accountResponse.value = ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode,respMessage: successModel.message);
        } else{
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          accountResponse.value = ResponseInfo(responseStatus:  Constants.failure,respCode: baseFailureModel.responseCode,respMessage: baseFailureModel.message);
        }
      }
      else{
        accountResponse.value = ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
      }
    } catch(e) {
      accountResponse.value = ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: e.toString());
      printError(info: e.toString());
    }
  }

  void setInputValues() {
    if(accountSettings.data.gender == "Male") {
      selectedIndex.value = 1;
    } else {
      selectedIndex.value = 2;
    }

    if(accountSettings.data.notification == "enabled") {
      _switchValue.value = true;
    }
    if(accountSettings.data.mobilenumber.isNotEmpty) {
      emailController.text = accountSettings.data.mobilenumber;
    } else {
      emailController.text = accountSettings.data.email;
    }
    firstnameController.text = accountSettings.data.firstname;
    lastnameController.text = accountSettings.data.lastname;
  }

  Widget buildView(BuildContext context) {
    if (accountResponse.value.responseStatus == Constants.loading) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: SizedBox(
            height: 40,
            child: LoadingIndicator(
              indicatorType: Indicator.ballRotateChase,
              colors: [AppTheme.primaryColor],
              strokeWidth: 2,
            ),
          ),
        ),
      );
    } else if (accountResponse.value.responseStatus == Constants.failure) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            accountResponse.value.respMessage,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      );
    } else if (accountResponse.value.responseStatus == Constants.success) {
      return Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: AppTheme.lightGrey),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                SizedBox(
                  height: 87,
                  width: 87,
                  child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                      NetworkImage(accountSettings.data.profileImage)),
                ),
                const SizedBox(height: 10),
                Text(accountSettings.data.displayName,
                    style: Style.titleTextStyle(AppTheme.blackTextColor, 23)),
                const SizedBox(height: 5),
                Text(accountSettings.data.email,
                    style:
                    Style.titleTextStyle(AppTheme.subheadingTextColor, 14)),
                const SizedBox(height: 24),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              child: TextFormField(
                controller: emailController,
                validator: (value) {
                  return validateEmail(value!);
                },
                decoration: Style.textFieldWithoutIconStyle("email_address".tr),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              child: TextFormField(
                controller: firstnameController,
                validator: (value) {
                  return validateInput(value!);
                },
                decoration: Style.textFieldWithoutIconStyle("name".tr),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: SizedBox(
          //     child: TextFormField(
          //       controller: lastnameController,
          //       validator: (value) {
          //         return validateInput(value!);
          //       },
          //       decoration: Style.textFieldWithoutIconStyle("lastname".tr),
          //     ),
          //   ),
          // ),
          Visibility(
            visible: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 45, right: 45),
              child: Text("gender".tr, style: Style.subheadingTextStyle(14)),
            ),
          ),
          Visibility(
            visible: false,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.grey5B5E60FF,
                          ),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform.scale(
                              alignment: Alignment.topLeft,
                              scale: 1.2,
                              child: Checkbox(
                                checkColor: Colors.white,
                                activeColor: AppTheme.primaryColor,
                                value: (selectedIndex.value == 1) ? true : false,
                                shape: const CircleBorder(),
                                onChanged: (bool? value) {
                                  if (value == true) {
                                    selectedIndex.value = 1;
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 18.0,
                                left: 8,
                                bottom: 18.0,
                              ),
                              child: Text("male".tr,
                                  style: Style.titleTextStyle(
                                      AppTheme.blackTextColor, 14)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.grey5B5E60FF,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.scale(
                            alignment: Alignment.topLeft,
                            scale: 1.2,
                            child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: AppTheme.primaryColor,
                              value: (selectedIndex.value == 2) ? true : false,
                              shape: const CircleBorder(),
                              onChanged: (bool? value) {
                                if (value == true) {
                                  selectedIndex.value = 2;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 18.0,
                              left: 8,
                              bottom: 18.0,
                            ),
                            child: Text("female".tr,
                                style: Style.titleTextStyle(
                                    AppTheme.blackTextColor, 14)),
                          ),
                        ],
                      ),
                    ),
                  )
                ])),
          ),
          Visibility(
            visible: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text("notification".tr,
                      style: Style.titleTextStyle(AppTheme.blackTextColor, 16)),
                  const Spacer(),
                  CupertinoSwitch(
                    value: _switchValue.value,
                    onChanged: (value) {
                      _switchValue.value = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          buildBillingAddress(context),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: ElevatedButton(
                onPressed: () {
                  if(isValid()) {
                    editAccountDetail();
                  }
                },
                child: Text("submit".tr),
                style: Style.rectangularRedButton(),
              ),
            ),
          ),
          const SizedBox(height: 20)
        ]),
      );
    }
    return Container();
  }

  Widget buildBillingAddress(BuildContext context) {
    if(showAddress.value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text("billing_address".tr,
                style: Style.titleTextStyle(AppTheme.blackTextColor, 16)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              color: AppTheme.lightGrey,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(billingAddress.firstName,
                            style: Style.normalTextStyle(
                                AppTheme.blackTextColor, 16)),
                        const SizedBox(height: 8),
                        Text(billingAddress.phone,
                            style: Style.normalTextStyle(
                                AppTheme.blackTextColor, 16)),
                        const SizedBox(height: 8),
                        Text(billingAddress.city,
                            style: Style.normalTextStyle(
                                AppTheme.blackTextColor, 16)),
                        const SizedBox(height: 8),
                        Text(billingAddress.country,
                            style: Style.normalTextStyle(
                                AppTheme.blackTextColor, 16)),
                        const SizedBox(height: 10),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                        onTap: () {
                          var address = billingAddress;
                          var data = {
                            "addressId": address.id,
                            "name": address.firstName,
                            // "lastname": address.lastName,
                            "country": address.country,
                            "postcode": address.postcode,
                            "city": address.city,
                            "location": address.address,
                            "state": address.state,
                            "isDefaultBilling": "0",
                            "isDefaultShipping": "0",
                            "phone": address.phone,
                            "company": address.company
                          };
                          _navigateAndRefresh(context, data);
                        },
                        child: const Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 24,
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      );
    }
    return Container();
  }

  void _navigateAndRefresh(BuildContext context, dynamic data) async {
    await Get.to( () =>
        AddEditShippingAddress(data),
        binding: AlterShippingBinding()
    );
    onInit();
  }

  validateEmail(String value) {

    if(!(value.isEmail) && !(value.isPhoneNumber)) {
      return "valid_email_phone".tr;
    }
    return null;
  }

  validateInput(String value) {
    if(value.isEmpty) {
      return "field_should_not_be_empty".tr;
    }
    return null;
  }

  bool isValid() {
    final isValid = formKey.currentState!.validate();
    if(isValid) {
      formKey.currentState?.save();
      return true;
    }
    return false;
  }

  void editAccountDetail() async {
    editResponse.value = ResponseInfo(responseStatus: Constants.loading);
    var userId = await storageService.read(Constants.userId);
    var result = await repo.editAccountDetails({
      "userid": userId,
      "name": firstnameController.value.text,
      // "lastname": lastnameController.value.text,
      "notification": (_switchValue.isTrue)? "enabled": "disabled",
      "gender": (selectedIndex.value == 1)? "Male": "Female",
      "email": emailController.value.text,
      "profilepic": ""
    });
    print(result.response);
    try {
      var message = result.response['message'];
      var responseCode = result.response['SuccessCode'];
      if(result.error==null){
        if(responseCode==200){
          editResponse.value = ResponseInfo(responseStatus:  Constants.success,respCode: responseCode,respMessage: message);
        } else{
          editResponse.value = ResponseInfo(responseStatus:  Constants.failure,respCode: responseCode,respMessage: message);
        }
      }
      else{
        editResponse.value = ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
      }
    } catch(e) {
      editResponse.value = ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: e.toString());
      printError(info: e.toString());
    }
  }

  handleEditApiResponse(BuildContext context) {
    if (editResponse.value.responseStatus == Constants.loading) {
      Future.delayed(Duration.zero, () async {
        return showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.transparent,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
      });
    } else if (editResponse.value.responseStatus == Constants.failure) {
      Future.delayed(Duration.zero, () async {
        Navigator.pop(context);
        Get.snackbar("message".tr, editResponse.value.respMessage);
      });
    } else if (editResponse.value.responseStatus == Constants.success) {
      Future.delayed(Duration.zero, () async {
        Navigator.pop(context);
        Get.snackbar("message".tr, editResponse.value.respMessage);
      });
    }
    return Container();
  }
}