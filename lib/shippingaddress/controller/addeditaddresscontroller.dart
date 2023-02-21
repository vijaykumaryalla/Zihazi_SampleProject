import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../baseclasses/basecontroller.dart';
import '../../baseclasses/basefailuremodel.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../service/networkerrors.dart';
import '../model/add_address.dart';
import '../model/country.dart';
import '../model/shipping_address.dart';
import '../repo/shippingaddressrepo.dart';

class AddEditAddressController extends BaseController {
  ShippingAddressRepo repo = Get.find<ShippingAddressRepo>();
  var storageService = Get.find<StorageService>();
  var addAddressResponse = ResponseInfo(responseStatus: Constants.idle).obs;
  var editAddressResponse = ResponseInfo(responseStatus: Constants.idle).obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> stateKey = GlobalKey<FormState>();
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController countryController;
  late TextEditingController stateController;
  late TextEditingController companyController;
  late TextEditingController addressController;
  late TextEditingController postalController;
  late TextEditingController cityController;
  late TextEditingController phoneController;
  String addressId = "0";
  RxString chosenCountry = "select_country".tr.obs;
  RxString chosenState = "select_state".tr.obs;
  bool isEdit = false;
  RxBool isDefaultBilling = false.obs;
  RxBool isDefaultShipping = false.obs;
  RxBool isCountrySelected = false.obs;
  var countryLabel = "select_country".tr.obs;
  var stateLabel = "select_state".tr.obs;
  var sendStateField = false.obs;
  RxList<CountryCode> countryList = List<CountryCode>.empty(growable: true).obs;
  RxList<DropdownMenuItem> countryDropdownList = List<DropdownMenuItem>.empty(growable: true).obs;

  @override
  void onInit() {
    super.onInit();
    getCountryList();
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    countryController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    companyController = TextEditingController();
    postalController = TextEditingController();
  }

  getCountryList() async {
    var result = await repo.getCountry("");
    try {
      if (result.error == null) {
        var responseCode = result.response['SuccessCode'];
        if (responseCode == 200) {
          var successModel = Country.fromJson(result.response);
          countryList.addAll(successModel.data);
        }
      }
    } catch(e) {
      printError(info: e.toString());
    }
  }

  Widget buildCountryDropDown(BuildContext context) {
    if(countryList.isNotEmpty) {
      return Padding(
        padding:
        const EdgeInsets.only(right: 16, left: 16, top: 20),
        child: InkWell(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              padding: const EdgeInsets.only(right: 16, left: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28.0),
                border: Border.all(
                  width: 1,
                  color: AppTheme.grey5B5E60FF,
                  style: BorderStyle.solid,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 12.0),
                child: Text(
                  countryLabel.value,
                ),
              ),
            ),
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('country_list'.tr),
                    content: setupAlertDialogContainer(),
                  );
                });
          },
        ),
      );
    }
    return Container();
  }

  Widget setupAlertDialogContainer() {
    return SizedBox(
      height: 400.0,
      width: 300.0,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: countryList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: InkWell(
              child: Text(countryList[index].label),
              onTap: () {
                isCountrySelected.value = true;
                chosenCountry.value = countryList[index].value;
                countryController.text = countryList[index].label;
                countryLabel.value = countryList[index].label;
                Get.back();
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildStateDropDown(BuildContext context) {
    if(countryList.isNotEmpty) {
      return Padding(
        padding:
        const EdgeInsets.only(right: 16, left: 16, top: 20),
        child: InkWell(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              padding: const EdgeInsets.only(right: 16, left: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28.0),
                border: Border.all(
                  width: 1,
                  color: AppTheme.grey5B5E60FF,
                  style: BorderStyle.solid,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 12.0),
                child: Text(
                  stateLabel.value,
                ),
              ),
            ),
          ),
          onTap: () {
            if(isCountrySelected.value) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    for (var element in countryList) {
                      if (element.value == chosenCountry.value) {
                        if (element.states == "") {
                          sendStateField.value = true;
                          return AlertDialog(
                            title: Text("state_province".tr),
                            content: showManualStateDialog(),
                          );
                        }
                      }
                    }
                    return AlertDialog(
                      title: Text("state_province".tr),
                      content: setupStateDialogContainer(),
                    );
                  });
            } else {
              Get.snackbar("message".tr, "select_country_then_state".tr);
            }
          },
        ),
      );
    }
    return Container();
  }

  Widget showManualStateDialog() {
    return SizedBox(
      height: 150.0,
      width: 300.0,
      child: Column(
        children: [
          Form(
            key: stateKey,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 20),
              child: SizedBox(
                child: TextFormField(
                  controller: stateController,
                  validator: (value) {
                    return validateTextField(value!);
                  },
                  decoration: Style.textFieldWithoutIconStyle("state_province".tr),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                    LengthLimitingTextInputFormatter(15)
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                child: Text("cancel".tr),
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  primary: AppTheme.subheadingTextColor,
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                child: Text("save".tr),
                onPressed: () {
                  chosenState.value = "";
                  sendStateField.value = true;
                  stateLabel.value = stateController.value.text;
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  primary: AppTheme.primaryColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget setupStateDialogContainer() {
    sendStateField.value = false;
    List<States> states;
    for (var element in countryList) {
      if(element.value == chosenCountry.value) {
        if(element.states != "") {
          states = element.states;
          return SizedBox(
            height: 400.0,
            width: 300.0,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: states.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: InkWell(
                    child: Text(states[index].label),
                    onTap: () {
                      chosenState.value = states[index].value;
                      stateLabel.value = states[index].label;
                      Get.back();
                    },
                  ),
                );
              },
            ),
          );
        }
        break;
      }
    }

    return const SizedBox(
      height: 400.0,
      width: 300.0,
      child: Center(child: Text("Unable to load the states")),
    );

  }

  setData(dynamic data) {
    if (data != null) {
      isEdit = true;
      isCountrySelected.value = true;
      Address address = Address.fromJson(data);
      firstnameController.text = address.firstname;
      lastnameController.text = address.lastname;
      countryController.text = address.country;
      cityController.text = address.city;
      stateController.text = address.state?? "";
      addressController.text = address.location[0];
      phoneController.text = address.phone;
      companyController.text = address.company?? "";
      postalController.text = address.postcode;
      addressId = address.addressId;
      countryLabel.value = address.country;
      chosenCountry.value = address.country;
      chosenState.value = address.state ?? "";
      stateLabel.value = address.state?? "Please select label";
    } else {
      firstnameController.text = "";
      lastnameController.text = "";
      countryController.text = "";
      cityController.text = "";
      stateController.text = "";
      addressController.text = "";
      phoneController.text = "";
      companyController.text = "";
      postalController.text = "";
    }
  }

  String? validateTextField(String value) {
    if(value.isEmpty) {
      return "field_should_not_be_empty".tr;
    }
    return null;
  }

  String? validatePhoneNumber(String value) {
    if(value.isEmpty) {
      return "field_should_not_be_empty".tr;
    } else if(value.length < 10) {
      return "phone_number_should_have_ten_digits".tr;
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

  addShippingAddress() async {
    addAddressResponse.value = ResponseInfo(responseStatus: Constants.loading);
    var userId = await storageService.read(Constants.userId);
    var result = await repo.addAddress({
      "userId": userId,
      "country": chosenCountry.value,
      "city": cityController.value.text,
      "phone": phoneController.value.text,
      "postcode": postalController.value.text,
      "address": addressController.value.text,
      "firstname": firstnameController.value.text,
      "lastname": lastnameController.value.text,
      "state": sendStateField.value? stateLabel.value: "null",
      "regionId": chosenState.value,
      "company": companyController.value.text,
      "isDefaultBilling": isDefaultBilling.value ? "1": "0",
      "isDefaultShipping": isDefaultShipping.value ? "1": "0",
    });
    try {
      if (result.error == null) {
        var responseCode = result.response['SuccessCode'];
        if (responseCode == 200) {
          var successModel = AddAddress.fromJson(result.response);
          addAddressResponse.value = ResponseInfo(
              responseStatus: Constants.success,
              respCode: successModel.successCode,
              respMessage: successModel.message);
        } else {
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          addAddressResponse.value = ResponseInfo(
              responseStatus: Constants.failure,
              respCode: baseFailureModel.responseCode,
              respMessage: baseFailureModel.message);
        }
      } else {
        addAddressResponse.value = ResponseInfo(
            responseStatus: Constants.failure,
            respCode: 500,
            respMessage: result.error);
      }
    } catch (e) {
      addAddressResponse.value = ResponseInfo(
          responseStatus: Constants.failure,
          respCode: 500,
          respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }
  }

  editShippingAddress() async {
    addAddressResponse.value = ResponseInfo(responseStatus: Constants.loading);
    var userId = await storageService.read(Constants.userId);
    var result = await repo.editAddress({
      "userId": userId,
      "addressId": addressId,
      "country": chosenCountry.value,
      "city": cityController.value.text,
      "phone": phoneController.value.text,
      "postcode": postalController.value.text,
      "address": addressController.value.text,
      "firstname": firstnameController.value.text,
      "lastname": lastnameController.value.text,
      "state": sendStateField.value? stateLabel.value: "null",
      "regionId": chosenState.value,
      "company": companyController.value.text,
      "isDefaultBilling": isDefaultBilling.value ? "1": "0",
      "isDefaultShipping": isDefaultShipping.value ? "1": "0",
    });
    try {
      if (result.error == null) {
        var responseCode = result.response['SuccessCode'];
        var message = result.response['message'];
        if (responseCode == 200) {
          addAddressResponse.value = ResponseInfo(
              responseStatus: Constants.success,
              respCode: responseCode,
              respMessage: message);
        } else {
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          addAddressResponse.value = ResponseInfo(
              responseStatus: Constants.failure,
              respCode: baseFailureModel.responseCode,
              respMessage: baseFailureModel.message);
        }
      } else {
        addAddressResponse.value = ResponseInfo(
            responseStatus: Constants.failure,
            respCode: 500,
            respMessage: result.error);
      }
    } catch (e) {
      addAddressResponse.value = ResponseInfo(
          responseStatus: Constants.failure,
          respCode: 500,
          respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }
  }

  handleApiResponse(BuildContext context) {
    if (addAddressResponse.value.responseStatus == Constants.loading) {
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
    } else if (addAddressResponse.value.responseStatus == Constants.failure) {
      Future.delayed(Duration.zero, () async {
        Navigator.pop(context);
        Get.snackbar("message".tr, addAddressResponse.value.respMessage);
      });
    } else if (addAddressResponse.value.responseStatus == Constants.success) {
      Future.delayed(Duration.zero, () async {
        Navigator.pop(context);
        Get.snackbar("message".tr, addAddressResponse.value.respMessage);
      });
      Get.back();
    }
    return Container();
  }

  Widget buildCheckbox() {
    return Column(
      children: [
        Padding(
          padding:
          const EdgeInsets.only(right: 16, left: 16),
          child: Row(
            children: [
              SizedBox(
                child: Checkbox(
                  onChanged: (bool? value) {
                    isDefaultShipping.value = value!;
                  },
                  value: isDefaultShipping.value,
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                  "make_default_shipping_address".tr,
                  style: Style.normalTextStyle(
                      AppTheme.blackTextColor, 14
                  )
              )
            ],
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.only(right: 16, left: 16),
          child: Row(
            children: [
              SizedBox(
                child: Checkbox(
                  onChanged: (bool? value) {
                    isDefaultBilling.value = value!;
                  },
                  value: isDefaultBilling.value,
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              Text(
                  "make_default_billing_address".tr,
                  style: Style.normalTextStyle(
                      AppTheme.blackTextColor, 14
                  )
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    countryController.dispose();
    cityController.dispose();
    stateController.dispose();
    addressController.dispose();
    phoneController.dispose();
    companyController.dispose();
    postalController.dispose();
    super.dispose();
  }
}
