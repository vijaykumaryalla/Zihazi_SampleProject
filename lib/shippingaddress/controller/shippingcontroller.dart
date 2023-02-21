import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../baseclasses/basecontroller.dart';
import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/custome_loader/lodading_indicator.dart';
import '../../service/networkerrors.dart';
import '../model/shipping_address.dart';
import '../repo/shippingaddressrepo.dart';
import '../view/shippingaddressitem.dart';

class ShippingController extends BaseController {

  ShippingAddressRepo repo = Get.find<ShippingAddressRepo>();
  var storageService = Get.find<StorageService>();
  var shippingAddressResponse = ResponseInfo(responseStatus: Constants.idle).obs;
  var deleteAddressResponse = ResponseInfo(responseStatus: Constants.idle).obs;
  RxList<Address> addressList = List<Address>.empty(growable: true).obs;
  Address? selectedAddress;
  RxBool showSaveButton = false.obs;

  @override
  void onInit() {
    getShippingAddressList();
    super.onInit();
  }

  getShippingAddressList() async {
    deleteAddressResponse.value = ResponseInfo(responseStatus: Constants.idle);
    shippingAddressResponse.value = ResponseInfo(responseStatus: Constants.loading);
    var userId = await storageService.read(Constants.userId);
    var result = await repo.getShippingAddress({
      "userId": userId,
    });
    print(userId);
    print(result.response);
    if(result.response == null) {
      getShippingAddressList();
    } else {
      try {
        if (result.error == null) {
          var responseCode = result.response['SuccessCode'];
          var message = result.response['message'];
          if (responseCode == 200) {
            List<dynamic> data = result.response['data'];
            if(data.isNotEmpty) {
              var successModel = ShippingAddress.fromJson(result.response);
              addressList.clear();
              addressList.addAll(successModel.data);
              shippingAddressResponse.value = ResponseInfo(
                  responseStatus: Constants.success,
                  respCode: successModel.successCode,
                  respMessage: successModel.message);
            } else {
              shippingAddressResponse.value = ResponseInfo(
                  responseStatus: Constants.failure,
                  respCode: responseCode,
                  respMessage: message);
            }
          } else {
            shippingAddressResponse.value = ResponseInfo(
                responseStatus: Constants.failure,
                respCode: responseCode,
                respMessage: message);
          }
        } else {
          shippingAddressResponse.value = ResponseInfo(
              responseStatus: Constants.failure,
              respCode: 500,
              respMessage: result.error);
        }
      } catch (e) {
        shippingAddressResponse.value = ResponseInfo(
            responseStatus: Constants.failure,
            respCode: 500,
            respMessage: "something_went_wrong".tr);
        printError(info: e.toString());
      }
    }
  }

  deleteAddress(String addressId) async {
    deleteAddressResponse.value = ResponseInfo(responseStatus: Constants.loading);
    var userId = await storageService.read(Constants.userId);
    var result = await repo.deleteAddress({
      "userId": userId,
      "addressId": addressId
    });
    try {
      if (result.error == null) {
        var responseCode = result.response['SuccessCode'];
        if (responseCode == 200) {
          var message = result.response['message'];
          deleteAddressResponse.value = ResponseInfo(
              responseStatus: Constants.success,
              respCode: responseCode,
              respMessage: message);
        } else {
          var responseCode = result.response['SuccessCode'];
          var message = result.response['message'];
          deleteAddressResponse.value = ResponseInfo(
              responseStatus: Constants.failure,
              respCode: responseCode,
              respMessage: message);
        }
      } else {
        deleteAddressResponse.value = ResponseInfo(
            responseStatus: Constants.failure,
            respCode: 500,
            respMessage: result.error);
      }
    } catch (e) {
      deleteAddressResponse.value = ResponseInfo(
          responseStatus: Constants.failure,
          respCode: 500,
          respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }
  }

  Widget buildAddressList() {
    if (shippingAddressResponse.value.responseStatus == Constants.loading) {
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
    } else if (shippingAddressResponse.value.responseStatus == Constants.failure) {
      return Column(
        children: [
          SizedBox(
            height: 100,
            child: Center(
              child: Text(
                shippingAddressResponse.value.respMessage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30)
        ],
      );
    } else {
      if(addressList.isEmpty) {
        return Column(
          children: [
            PageErrorView((){}, NoData(msg: "no_address_found".tr)),
            const SizedBox(height: 30)
          ],
        );
      }
      return ShippingAddressItem(addressList);
    }
  }

  Widget handleDeleteAPIResponse(BuildContext context) {
    if (deleteAddressResponse.value.responseStatus == Constants.loading) {
      Future.delayed(Duration.zero, () async {
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
      });
    } else if (deleteAddressResponse.value.responseStatus == Constants.failure) {
      Future.delayed(Duration.zero, () async {
        Get.snackbar("message".tr, deleteAddressResponse.value.respMessage);
      });
    } else if(deleteAddressResponse.value.responseStatus == Constants.success) {
      Future.delayed(Duration.zero, () async {
        Get.snackbar("message".tr, "address_deleted".tr);
        getShippingAddressList();
      });
    }
    return Container();
  }
}