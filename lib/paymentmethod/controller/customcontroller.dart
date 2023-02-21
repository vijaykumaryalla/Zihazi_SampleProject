import 'dart:convert';
import 'dart:io';


import 'package:crypto/crypto.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../account/controller/accountcontroller.dart';
import '../../baseclasses/basefailuremodel.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../../cart/controller/cartcontroller.dart';
import '../../checout_info/controller/checkout_info_controller.dart';
import '../../payment_status/binding/payment_status_binding.dart';
import '../../payment_status/view/payment_status_page.dart';
import '../model/createorderresmodel.dart';
import '../model/payforttokeresmodel.dart';
import '../model/payment_method_obj.dart';
import '../repo/repo.dart';



class CustomController extends GetxController{

  var sdkToken='';
  var deviceId='';
  var orderId='';
  var incrementalId='';
  var paymentMethodId=0.obs;
  var paymentMethodCode='';
  var submitButtonText = 'Pay Now'.obs;
  var loading=false.obs;
  var isEmailNeeded = false.obs;
  late TextEditingController emailController;
  final error = ''.obs;
  final errorEmail = false.obs;
  var isShowButton = false.obs;

  RxList<PaymentMethodObj> paymentMethodObj= [
    PaymentMethodObj(methodId: 1,methodName: "credit_debit".tr,methodCode: "aps_fort_cc",imgUrl: ImageUtil.madaIcon,isChecked: false,paymentText: "pay_now".tr),
    PaymentMethodObj(methodId: 3,methodName: "apple_pay".tr,methodCode: "aps_apple",imgUrl: ImageUtil.applePayIcon,isChecked: false,paymentText: "pay_now".tr),
    PaymentMethodObj(methodId:2,methodName: "cash_on_delivery".tr,methodCode: "cashondelivery",imgUrl: ImageUtil.codIcon,isChecked: false,paymentText: "place_order".tr),
  ].obs;

  var storageService = Get.find<StorageService>();
  var cartData = Get.find<CartController>().cartData;
  var totalAmount = Get.find<CheckoutInfoController>().totalAmount;
  var shippingAmount = Get.find<CartController>().shippingAmount;
  var shippingMethodCode = Get.find<CartController>().shippingMethod;
  var selectedAddress = Get.find<CheckoutInfoController>().address;
  static const platform = MethodChannel('mainChannelKey');



  Future<void> callPayFort(int paymentMethodId) async {
    String? deviceId;
    try {
      // deviceId = await PlatformDeviceId.getDeviceId;
      deviceId = await getDeviceId();
      var signature = await generateSha256(deviceId,paymentMethodId);
      getToken(deviceId,signature , paymentMethodId);
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
  }


  Future<String> getDeviceId() async {
    try {
      var result = await platform.invokeMethod('getDeviceId');
      return result;
    } on PlatformException catch (e) {
      if (e.code == "onCancel") {
        print(e.details);
        return e.details;
      } else {
        print(e.details);
        return e.details;
      }
    }
  }

  void getToken(String deviceId,String signature, int paymentMethodId) async {
    loading.value=true;
    var result = await Get.find<Repo>().callPayfortToken({
      "service_command":"SDK_TOKEN",
      "access_code":paymentMethodId==1?Constants.accessCode:Constants.accessCodeApple,
      "merchant_identifier":paymentMethodId==1?Constants.merchantIdentifier:Constants.merchantIdentifierApple,
      "language":storageService.getLocale().languageCode,
      "device_id":deviceId,
      "signature":signature
    });
    try {
      loading.value=false;
      if(result.error==null){
        var model = PayFortTokenResModel.fromJson(result.response);
        sdkToken=model.sdkToken;
        createOrder();
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  void updatePaymentInfo(String orderId,Object data) async {
    loading.value=true;
    var result = await Get.find<Repo>().updatePaymentInfo({
      "orderid": orderId,
      "data":data.toString()
    });
    try {
      if(result.error==null){
        loading.value=false;
        var responseCode = result.response['SuccessCode'];
        print(responseCode);
        if(responseCode==200) {
          var message = result.response['message'];
          Get.snackbar("message".tr, message);
        }
      } else{
        var baseFailureModel = BaseFailureModel.fromJson(result.response);
        Get.snackbar("message".tr, baseFailureModel.message);
      }
    } catch (e) {
      Get.snackbar("message".tr, "something_went_wrong".tr);
      printError(info: e.toString());
    }
  }

  void updateStatusName(String orderId,String paymentStatus) async {
    loading.value=true;
    var result = await Get.find<Repo>().updateStatus({
      "orderid": orderId,
      "paymentStatus":paymentStatus
    });
    try {
      if(result.error==null){
        loading.value=false;
        var responseCode = result.response['SuccessCode'];
        print(responseCode);
        if(responseCode==200) {
          var message = result.response['message'];
          Get.snackbar("message".tr, message);
        }
      } else{
        var baseFailureModel = BaseFailureModel.fromJson(result.response);
        Get.snackbar("message".tr, baseFailureModel.message);
      }
    } catch (e) {
      Get.snackbar("message".tr, "something_went_wrong".tr);
    }
  }

  void createOrder() async {
    loading.value=true;
   // var userName = await storageService.read(Constants.userName);
    String userEmail = isEmailNeeded.value ? emailController.text : await storageService.read(Constants.userEmail);
    var userId = await storageService.read(Constants.userId);
    Map<String, dynamic> model;
    if(isEmailNeeded.value) {
       model = {
        "shipping_method":shippingMethodCode.value,
        "payment_method":paymentMethodCode,
        "userid":userId,
        "address_id": selectedAddress?.addressId,
         "email": emailController.text
      };
    } else {
      model = {
        "shipping_method":shippingMethodCode.value,
        "payment_method":paymentMethodCode,
        "userid":userId,
        "address_id": selectedAddress?.addressId,
      };
    }

    var result = await Get.find<Repo>().createOrder(model);
    print("Create Order");
    print(result);
    print(result.response);
    try {
      loading.value=false;
      if(result.error==null){
        var model = result.response;
        print("Create Order "+ model.toString());
        incrementalId= model.data.incrementId;
        orderId=model.data.orderId;
        if(userEmail.isEmpty) {
         await storageService.write(Constants.userEmail, emailController.text);
         userEmail = await storageService.read(Constants.userEmail);
        }

        var amount = calculateTotalAmount().toStringAsFixed(2).replaceAll(".", "");
        var appleAmount = calculateTotalAmount().toStringAsFixed(2);
        if(paymentMethodId.value==1){
          // PayfortPlugin.performPaymentRequest(
          //     incrementalId,
          //     sdkToken,
          //     userName,
          //     storageService.getLocale().languageCode,
          //     userEmail,
          //     amount.toString(),
          //     'PURCHASE',
          //     'SAR',
          //     Constants.environment // 0 for test mode and 1 for production
          // ).then((value)  {
          //   // value object contains payfort response, such card number, transaction reference, ...
          //   // print("card number ${value?["card_number"]}");
          //   Get.snackbar("payment",value?["response_message"]);
          //   if(value?["response_code"]=='14000'){
          //     updateStatusCod(orderId, Constants.orderSuccess);
          //     Get.to(PaymentStatusPage(status: 1,orderId: incrementalId,),binding: PaymentStatusBinding());
          //   }else{
          //     updateStatusCod(orderId, Constants.orderCancelled);
          //     Get.to(const PaymentStatusPage(status: 2,orderId: "",),binding: PaymentStatusBinding());
          //   }
          // });

          try {
            var result = await platform.invokeMethod('callPayFort', {
              "isShowResponsePage": true,
              "isEnvironment":Constants.environment,
              "requestParam": {
                "amount": amount.toString(),
                "merchant_reference": incrementalId,
                "sdk_token": sdkToken,
                "currency": "SAR",
                "command": "PURCHASE",
                "language": storageService.getLocale().languageCode,
                "customer_email": userEmail
              }
            }).then((value){
              Get.snackbar("payment",value?["response_message"]);
              if(value?["response_code"]=='14000'){
                updateStatusName(orderId, Constants.orderSuccess);
                updatePaymentInfo(orderId, value);
                Get.to(PaymentStatusPage(status: 1,orderId: incrementalId,),binding: PaymentStatusBinding());
              }else{
                updateStatusName(orderId, Constants.orderCancelled);
                updatePaymentInfo(orderId, value);
                Get.to(const PaymentStatusPage(status: 2,orderId: "",),binding: PaymentStatusBinding());
              }
            });
          } on PlatformException catch (e) {
            if (e.code == "onCancel") {
              print(e.details);
            } else {
              print(e.details);
            }
          }
        }else if (paymentMethodId.value==3){
          final ipv4 = await Ipify.ipv4();

          try {
            var result = await platform.invokeMethod('openApplePay', {
              "isShowResponsePage": true,
              "isEnvironment":Constants.environmentApple,
              "appleAmount":appleAmount.toString(),
              "requestParam": {
                "amount": amount.toString(),
                "merchant_reference": incrementalId,
                "sdk_token": sdkToken,
                "currency": "SAR",
                "command": "PURCHASE",
                "language": storageService.getLocale().languageCode,
                "customer_email": userEmail,
                "digital_wallet" : "APPLE_PAY",
                "customer_ip":ipv4
              }
            });
          } on PlatformException catch (e) {
            if (e.code == "onCancel") {
              print(e.details);
            } else {
              print(e.details);
            }
          }
        }else{
          Get.snackbar("message".tr,model.message);
          Get.to(PaymentStatusPage(status: 1,orderId: incrementalId,),binding: PaymentStatusBinding());
        }

      }
      else{
        Get.snackbar("message".tr, "something_went_wrong".tr);
        Get.to(const PaymentStatusPage(status: 2,orderId: "",),binding: PaymentStatusBinding());
      }
    } catch (e) {
      Get.snackbar("message".tr, "something_went_wrong".tr);
      Get.to(const PaymentStatusPage(status: 2,orderId: "",),binding: PaymentStatusBinding());
      printError(info: e.toString());
    }
  }

  Future<String> generateSha256(String deviceId, int paymentMethodId) async {
    String value="";
    if(paymentMethodId==1){
      value=Constants.merchantShaPhrase + "access_code=" +Constants.accessCode
          + "device_id=" + deviceId + "language=" + storageService.getLocale().languageCode + "merchant_identifier=" +
          Constants.merchantIdentifier+ "service_command=SDK_TOKEN"+Constants.merchantShaPhrase ;
    }else{
      value=Constants.merchantShaPhraseApple + "access_code=" +Constants.accessCodeApple
          + "device_id=" + deviceId + "language=" + storageService.getLocale().languageCode + "merchant_identifier=" +
          Constants.merchantIdentifierApple+ "service_command=SDK_TOKEN"+Constants.merchantShaPhraseApple ;
    }

    var data =  utf8.encode(value); // data being hashed
    var hashValue =  sha256.convert(data);
    return hashValue.toString();
  }




  priceInfoView() {
    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("price_details".tr,style: Style.customTextStyle(AppTheme.black, 18.0, FontWeight.bold, FontStyle.normal),),
            SizedBox(height: 10.0,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text("tax".tr,style: Style.customTextStyle(AppTheme.black, 14.0, FontWeight.normal, FontStyle.normal),),
            //     Row(
            //       children: [
            //         Text("sar".tr,style: Style.customTextStyle(AppTheme.black, 14.0, FontWeight.normal, FontStyle.normal),),
            //         SizedBox(width: 5.0,),
            //         Text(cartData.tax.toString(),style: Style.customTextStyle(AppTheme.redce171f, 14.0, FontWeight.normal, FontStyle.normal),),
            //       ],
            //     ),
            //   ],
            // ),
            // SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("delivery_charge".tr,style: Style.customTextStyle(AppTheme.black, 14.0, FontWeight.normal, FontStyle.normal),),
                Text(paymentMethodId.value==2?"sar".tr+" "+cartData.cODPrice.toString():"FREE",style: Style.customTextStyle(AppTheme.greenButtonColor, 14.0, FontWeight.normal, FontStyle.normal),),
              ],
            ),
            const SizedBox(height: 10),
            shippingMethodCode.value=="flatrate"?Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("shipping_charge".tr, style: Style.titleTextStyle(AppTheme.textColor, 15),),
                const Spacer(),
                Text("sar".tr+" "+"${shippingAmount.value}", style: Style.titleTextStyle(AppTheme.greenButtonColor, 15),),
              ],
            ):Container(),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("total".tr,style: Style.customTextStyle(AppTheme.black, 14.0, FontWeight.normal, FontStyle.normal),),
                Row(
                  children: [
                    Text("sar".tr,style: Style.customTextStyle(AppTheme.black, 14.0, FontWeight.normal, FontStyle.normal),),
                    SizedBox(width: 5.0,),
                    Text(calculateTotalAmount().toStringAsFixed(2),style: Style.customTextStyle(AppTheme.redce171f, 14.0, FontWeight.normal, FontStyle.normal),),
                  ],
                ),
              ],
            ),
            SizedBox(height: 60.0,),
          ],
        ),
      ),
    );
  }

  double calculateTotalAmount(){
    if(paymentMethodId.value==2){
      return totalAmount.toDouble()+cartData.cODPrice.toDouble();
    }else{
      return totalAmount.toDouble();
    }
  }

  @override
  void onInit() {
    emailController = TextEditingController();
    handlePlatformChannelMethods();
    if(!Platform.isIOS){
      paymentMethodObj.removeWhere((element) => element.methodId==3);
    }
    super.onInit();
  }

  Future<dynamic> handlePlatformChannelMethods() async {
    platform.setMethodCallHandler((methodCall) async {
      if (methodCall.method == "applePayResult") {
        if (methodCall.arguments != null) {
          if(methodCall.arguments=="cancelled"){
            updateStatusName(orderId, Constants.orderCancelled);
            Get.to(const PaymentStatusPage(status: 2,orderId: "",),binding: PaymentStatusBinding());
            if(Get.isRegistered<AccountController>()){
              var controller = Get.find<AccountController>();
              controller.writeLog("APPLEPAY", "CANCELLED");
            }
          }else{
            Get.snackbar("payment",methodCall.arguments?["response_message"]);
            if(methodCall.arguments?["response_code"]=='14000'){
              updateStatusName(orderId, Constants.orderSuccess);
              updatePaymentInfo(orderId, methodCall.arguments);
              Get.to(PaymentStatusPage(status: 1,orderId: incrementalId,),binding: PaymentStatusBinding());
              if(Get.isRegistered<AccountController>()){
                var controller = Get.find<AccountController>();
                controller.writeLog("APPLEPAY", methodCall.arguments.toString());
              }
            }else{
              updateStatusName(orderId, Constants.orderCancelled);
              updatePaymentInfo(orderId, methodCall.arguments);
              Get.to(const PaymentStatusPage(status: 2,orderId: "",),binding: PaymentStatusBinding());
              if(Get.isRegistered<AccountController>()){
                var controller = Get.find<AccountController>();
                controller.writeLog("APPLEPAY", methodCall.arguments.toString());
              }
            }
          }

        }
      }
    });
  }


  void paymentMethodTapped(int index) async{
   submitButtonText.value = paymentMethodObj[index].paymentText;
   paymentMethodObj[index].isChecked=true;
   paymentMethodId.value = paymentMethodObj[index].methodId;
   paymentMethodCode = paymentMethodObj[index].methodCode;
   paymentMethodObj.refresh();

   if(paymentMethodObj[index].methodName != "cash_on_delivery".tr) {
     // String email =  await storageService.getUserEmail();
     // isShowButton.value = email.isEmpty ? false : true;
     // isEmailNeeded.value = email.isEmpty ? true : false;
   } else {
     isEmailNeeded.value = false;
     isShowButton.value = true;
   }
  }


  void checkEmailNeeded() {
    if(isEmailNeeded.value) {
      if(!GetUtils.isEmail(emailController.text)) {
         error.value = 'Please enter a valid email';
         errorEmail.value = true;
      } else {
        checkPressed();
      }
    } else {
      checkPressed();
    }
  }
  checkPressed(){

    var paymentObj;
    for (int i=0;i<paymentMethodObj.length;i++) {
      if(paymentMethodObj[i].isChecked){
        paymentObj = paymentMethodObj[i];
      }
    }
    if(paymentObj!=null){

        if(paymentMethodId.value==2) {
          // PayfortPlugin.getID.then((value) {
          //   //use this call to get device id and send it to server
          //   if(value!=null){
          //     controller.deviceId=value;
          //     controller.getToken(value, controller.generateSha256(value));
          //   }
          // });
          createOrder();
        }else{
          callPayFort(paymentMethodId.value);
        }
    }else{
      return null;
    }
  }



}