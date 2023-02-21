import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../baseclasses/basecontroller.dart';
import '../../baseclasses/basefailuremodel.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/custome_loader/lodading_indicator.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../../service/networkerrors.dart';
import '../model/faqmodel.dart';
import '../repo/faqrepo.dart';

class FaqController extends BaseController{

  //var faqLit = List<Faqmodel>.empty(growable: true).obs;

  var currentVisibleindex = 0;
  var repo = Get.find<FaqReppo>();

  var faqResponseHtml = "".obs;

  var faqResponse=ResponseInfo(responseStatus: Constants.loading).obs;

  @override
  void onInit() {
    super.onInit();
    getFaq();
  }

  faqView() {
    if(faqResponse.value.responseStatus==Constants.loading){
      return const SizedBox(height: 100,
        child: Center(
          child: SizedBox(
            height: 40,
            child: LoadingIndicator(
              indicatorType: Indicator.ballRotateChase,
              colors:  [AppTheme.primaryColor],
              strokeWidth: 2,
            ),
          ),
        ),);
    }
    else if(faqResponse.value.responseStatus==Constants.failure){
      return  SizedBox(height: 100,child: Center(child: Text(faqResponse.value.respMessage,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppTheme.primaryColor,
        ),),),);
    }else {
     return Obx(() =>
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 200.0,
                color: AppTheme.greyf0f0f0,
                child: Center(
                  child: Image.asset(ImageUtil.faqImg, height: 200, width: 200,),
                ),

              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Html(data: faqResponseHtml.value),
              ),
            ],
          )
      );
    }

  }

  getFaq() async {
    var result = await repo.getFaq();
    try {

      if(result.error==null){
        var responseCode = result.response['SuccessCode'];
        if(responseCode==200){
          var successModel = FaqResponseModel.fromJson(result.response);
         faqResponseHtml.value=successModel.data;
         faqResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode,respMessage: successModel.message);
        } else{
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          faqResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: baseFailureModel.responseCode,respMessage: baseFailureModel.message);
        }
      }
      else{
        faqResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      faqResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "Something Went Wrong");
      printError(info: e.toString());
    }

  }

}