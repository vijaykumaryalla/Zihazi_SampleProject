import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../baseclasses/basecontroller.dart';
import '../../baseclasses/basefailuremodel.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/custome_loader/lodading_indicator.dart';
import '../../service/networkerrors.dart';
import '../repo/reviewrepo.dart';

class ReviewController extends BaseController {
  final GlobalKey<FormState> reviewFormKey = GlobalKey<FormState>();

  late TextEditingController headlineController;
  late TextEditingController reviewController;

  var repo = Get.find<ReviewRepo>();
  var storageService = Get.find<StorageService>();
  var reviewResponse = ResponseInfo(responseStatus: Constants.idle).obs;
  var rating = 0;

  @override
  void onInit() {
    super.onInit();
    headlineController = TextEditingController();
    reviewController = TextEditingController();
  }

  String? validateField(String value) {
    if (value.isEmpty) {
      return "field_should_not_be_empty".tr;
    }
    return null;
  }

  bool isValid() {
    final isValid = reviewFormKey.currentState!.validate();
    if (isValid) {
      reviewFormKey.currentState?.save();
      return true;
    }
    return false;
  }

  void postReview(String productId) async {
    reviewResponse.value = ResponseInfo(responseStatus: Constants.loading);
    var userName = await storageService.read(Constants.userName);
    var userId = await storageService.read(Constants.userId);
    var result = await repo.postReview({
      "headline": headlineController.value.text,
      "review": reviewController.value.text,
      "rating": rating,
      "userid": userId,
      "productid": productId,
      "nickname": userName
    });
    try {
      if (result.error == null) {
        var responseCode = result.response['SuccessCode'];
        if (responseCode == 200) {
          var message = result.response['message'];
          reviewResponse.value = ResponseInfo(
              responseStatus: Constants.success,
              respCode: responseCode,
              respMessage: message);
        } else {
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          reviewResponse.value = ResponseInfo(
              responseStatus: Constants.failure,
              respCode: baseFailureModel.responseCode,
              respMessage: baseFailureModel.message);
        }
      } else {
        reviewResponse.value = ResponseInfo(
            responseStatus: Constants.failure,
            respCode: 500,
            respMessage: result.error);
      }
    } catch (e) {
      reviewResponse.value = ResponseInfo(
          responseStatus: Constants.failure,
          respCode: 500,
          respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }
  }

  Widget handleResponse() {
    if (reviewResponse.value.responseStatus == Constants.loading) {
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
    } else if (reviewResponse.value.responseStatus == Constants.failure) {
      Future.delayed(Duration.zero, () async {
        Get.snackbar("message".tr, reviewResponse.value.respMessage);
      });
    } else if (reviewResponse.value.responseStatus == Constants.success) {
      Future.delayed(Duration.zero, () async {
        Get.snackbar("message".tr, reviewResponse.value.respMessage);
        headlineController.text="";
        reviewController.text="";
        Get.snackbar("message".tr, reviewResponse.value.respMessage);
      });
    }
    return Container();
  }

  @override
  void onClose() {
    super.onClose();
    headlineController.dispose();
    reviewController.dispose();
  }
}
