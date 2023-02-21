import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../baseclasses/basecontroller.dart';
import '../../baseclasses/basefailuremodel.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../../service/networkerrors.dart';
import '../repo/contactusrepo.dart';


class ContactUsController extends BaseController{

  var contactUsRes=ResponseInfo(responseStatus: Constants.idle).obs;
  var email = '';
  var mobile = '';
  var message = '';

  late TextEditingController emailController;
  late TextEditingController mobileNumController;
  late TextEditingController messageController;
  var storageService = Get.find<StorageService>();
  var repo = Get.find<ContactUsRepo>();
  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    messageController = TextEditingController();
    mobileNumController = TextEditingController();
    initData();
  }

  initData() async {
    emailController.text = await storageService.read(Constants.userEmail);
    mobileNumController.text = await storageService.read(Constants.userPhone);
    email = emailController.value.text;
    mobile = mobileNumController.text;
  }

  contactUsView(){
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
                Image.asset(ImageUtil.contactpageimg,height: 200,width: 200,)
              ],
            ),

          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 20,width:0,),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: emailController,
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {

                  },
                  decoration: Style.textFieldWithoutIconStyle(
                      "contact_us_mail".tr),
                ),
                const  SizedBox(height: 20,width:0,),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: mobileNumController,
                  onChanged: (value) {
                    mobile = value;
                  },
                  validator: (value) {

                  },
                  decoration: Style.textFieldWithoutIconStyle(
                      "contact_us_phone".tr),
                ),
                const  SizedBox(height: 20,width:0,),
                SizedBox(
                  height: 170,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    maxLines: null,
                    textInputAction: TextInputAction.done,
                    controller: messageController,
                    onChanged: (value) {
                      message = value;
                    },
                    validator: (value) {

                    },
                    decoration: Style.textFieldWithoutIconStyle(
                        "contact_us_message".tr),
                  ),
                ),
              ],
            ),
          ),

        ],
      );
  }

  bottomView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Container(height: 1,width: 100,color: Colors.grey,),
              Text("or".tr,style: Style.customTextStyle(AppTheme.grey5B5E60FF, 18, FontWeight.bold, FontStyle.normal),),
              Container(height: 1,width: 100,color: Colors.grey,),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Text("call_us".tr,style: Style.customTextStyle(AppTheme.grey5B5E60FF, 14, FontWeight.bold, FontStyle.normal),),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: Style.elevatedNormalCustomButton(Colors.green),
              onPressed: (){
                requestPhonePermission();
              },
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height:30,width: 30,child: SvgPicture.asset(ImageUtil.phoneCallImg)),
                  SizedBox(width: 10,),
                  Align(alignment: Alignment.center,child: Text("3005 60000266",style: Style.customTextStyle(Colors.white, 18.0,FontWeight.bold,FontStyle.normal),)),
                ],
              )
          ),
        )

      ],
    );
  }

  Widget handleAPIResponse(BuildContext context) {
    if(contactUsRes.value.responseStatus==Constants.loading){
      Future.delayed(Duration.zero, () async {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
      });
    } else if(contactUsRes.value.responseStatus==Constants.success) {
      Future.delayed(Duration.zero, () async {
        Get.back();
        Get.snackbar("message".tr, contactUsRes.value.respMessage);
      });
    } else if(contactUsRes.value.responseStatus==Constants.failure) {
      Future.delayed(Duration.zero, () async {
        Get.back();
        Get.snackbar("message".tr, contactUsRes.value.respMessage);
      });
    }
    return Container();
  }

  void validateAndCallApi() {
    if(mobile.trim().isNotEmpty && message.trim().isNotEmpty) {
      sendData();

      return;
    }

    // if(email.trim().isEmpty){
    //   Get.snackbar("email_empty".tr, "enter_valid_email_id".tr);
    //
    //   return;
    // }

    if(mobile.trim().isEmpty){
      Get.snackbar("phone_empty".tr, "valid_number".tr);
      return;
    }

    if(message.trim().isEmpty){
      Get.snackbar("message_empty".tr, "enter_a_message".tr);

      return;
    }

    if(!GetUtils.isEmail(email)){
      Get.snackbar("email_not_valid".tr, "enter_valid_email_id".tr);

      return;
    }

  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  Future<void> requestPhonePermission() async {


    final Uri launchUri = Uri(
      scheme: 'tel',
      path: "300560000266",
    );
    await launch(launchUri.toString());

  }

  Future<void> sendData() async {
    contactUsRes.value = ResponseInfo(responseStatus: Constants.loading);
    var userId = await storageService.read(Constants.userId);
    var result = await repo.sendData({
      "userid":userId,
      "message":messageController.text,
       "mobile":mobileNumController.text,
      "email":emailController.text
    });
    try {
      if(result.error==null){
        var responseCode = result.response['SuccessCode'];
        print(responseCode);
        if(responseCode==200){
          var respMessage = result.response['message'];
          initData();
          messageController.text="";
          message = "";
          contactUsRes.value=ResponseInfo(responseStatus:  Constants.success,respCode: responseCode,respMessage: respMessage);
        } else{
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          contactUsRes.value=ResponseInfo(responseStatus:  Constants.failure,respCode: baseFailureModel.responseCode,respMessage: baseFailureModel.message);
        }
      }
      else{
        contactUsRes.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      contactUsRes.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }
  }

}