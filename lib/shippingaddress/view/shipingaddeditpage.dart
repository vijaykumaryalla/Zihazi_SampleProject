import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../service/networkerrors.dart';
import '../controller/addeditaddresscontroller.dart';

class AddEditShippingAddress extends StatefulWidget {
  dynamic data;
  AddEditShippingAddress(this.data,{Key? key}) : super(key: key);

  @override
  _AddEditShippingAddressState createState() => _AddEditShippingAddressState();
}

class _AddEditShippingAddressState extends State<AddEditShippingAddress> {
  var controller = Get.find<AddEditAddressController>();
  bool isEditPage = false;

  @override
  Widget build(BuildContext context) {
    controller.setData(widget.data);
    isEditPage = widget.data != null;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: (widget.data == null)? Text("add_new_address".tr,
              style: Style.titleTextStyle(AppTheme.blackTextColor, 16))
              :  Text("edit_address".tr,
              style: Style.titleTextStyle(AppTheme.blackTextColor, 16)),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(CupertinoIcons.arrow_left, color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: controller.isConnected.value? SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.only(right: 16, left: 16, top: 20),
                  child: SizedBox(
                    child: TextFormField(
                      controller: controller.firstnameController,
                      validator: (value) {
                        return controller.validateTextField(value!);
                      },
                      decoration: Style.textFieldWithoutIconStyle("firstname".tr,),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                        LengthLimitingTextInputFormatter(15)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(right: 16, left: 16, top: 20),
                  child: SizedBox(
                    child: TextFormField(
                      controller: controller.lastnameController,
                      validator: (value) {
                        return controller.validateTextField(value!);
                      },
                      decoration: Style.textFieldWithoutIconStyle("lastname".tr,),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                        LengthLimitingTextInputFormatter(15)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(right: 16, left: 16, top: 20),
                  child: SizedBox(
                    child: TextFormField(
                      controller: controller.companyController,
                      validator: (value) {
                        return controller.validateTextField(value!);
                      },
                      decoration: Style.textFieldWithoutIconStyle("company".tr,),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                        LengthLimitingTextInputFormatter(15)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(right: 16, left: 16, top: 20),
                  child: SizedBox(
                    child: TextFormField(
                      controller: controller.addressController,
                      validator: (value) {
                        return controller.validateTextField(value!);
                      },
                      decoration: Style.textFieldWithoutIconStyle("address".tr,),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(20)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(right: 16, left: 16, top: 20),
                  child: SizedBox(
                    child: TextFormField(
                      controller: controller.cityController,
                      validator: (value) {
                        return controller.validateTextField(value!);
                      },
                      decoration: Style.textFieldWithoutIconStyle("city".tr,),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                        LengthLimitingTextInputFormatter(15)
                      ],
                    ),
                  ),
                ),
                Obx(() => controller.buildCountryDropDown(context)),
                Obx(() => controller.buildStateDropDown(context)),
                Padding(
                  padding:
                  const EdgeInsets.only(right: 16, left: 16, top: 20),
                  child: SizedBox(
                    child: TextFormField(
                      controller: controller.postalController,
                      validator: (value) {
                        return controller.validateTextField(value!);
                      },
                      decoration: Style.textFieldWithoutIconStyle("zip_postal".tr),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(10)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(right: 16, left: 16, top: 20),
                  child: SizedBox(
                    child: TextFormField(
                      controller: controller.phoneController,
                      validator: (value) {
                        return controller.validatePhoneNumber(value!);
                      },
                      decoration: Style.textFieldWithoutIconStyle("phone".tr,),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(10)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => controller.buildCheckbox()),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              bool isValid = controller.isValid();
                              if (isValid) {
                                if(isEditPage){
                                  controller.editShippingAddress();
                                } else {
                                  controller.addShippingAddress();
                                }
                              }
                            },
                            child: Text("save".tr),
                            style: Style.rectangularRedButton(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Ink(
                              color: Colors.transparent,
                              child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Center(child: Text("cancel".tr, style: Style.titleTextStyle(AppTheme.subheadingTextColor, 14),))),
                            )
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Obx(()=> controller.handleApiResponse(context))
              ],
            ),
          ),
        ): PageErrorView((){}, NoInternetError())
    );
  }
}