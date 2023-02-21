
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../baseclasses/basecontroller.dart';
import '../../baseclasses/basefailuremodel.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../cart/controller/cartcontroller.dart';
import '../../service/networkerrors.dart';
import '../../shippingaddress/binding/altershippingbinding.dart';
import '../../shippingaddress/binding/shippingbinding.dart';
import '../../shippingaddress/controller/shippingcontroller.dart';
import '../../shippingaddress/model/shipping_address.dart';
import '../../shippingaddress/view/shipingaddeditpage.dart';
import '../../shippingaddress/view/shippinglistpage.dart';
import '../repo/checkout_info_repo.dart';

class CheckoutInfoController extends BaseController {

  var personName = "".obs;
  var personNumber = "".obs;
  var personAddress = "".obs;
  RxBool enableContinueButton = false.obs;

  var storageService = Get.find<StorageService>();
  var totalAmount = Get.find<CartController>().totalAmount.value;
  var shippingAmount = Get.find<CartController>().shippingAmount;
  var shippingMethod = Get.find<CartController>().shippingMethod;
  var isPromoApplied = Get.find<CartController>().isPromoApplied;
  var repo = Get.find<CheckoutInfoRepo>();
  var userAddressResponse=ResponseInfo(responseStatus: Constants.loading).obs;

  var cartProducts = Get.find<CartController>().cartList;
  var cartData = Get.find<CartController>().cartData;
  RxBool isAddressAvailable = false.obs;

  Address? selectedAddress = Get.find<ShippingController>().selectedAddress;
  Address? address;

  getUserAddressList() async {
    userAddressResponse.value=ResponseInfo(responseStatus:  Constants.loading);
    var userId = await storageService.read(Constants.userId);
    if(selectedAddress == null) {
      var result = await repo.getUserAddress({
        "userId":userId
      });
      try {
        if(result.error==null){
          var responseCode = result.response['SuccessCode'];
          if(responseCode==200){
            var successModel = ShippingAddress.fromJson(result.response);
            if(successModel.data.isNotEmpty) {
              for (var element in successModel.data) {
                if(element.isDefaultShipping=="1") {
                  isAddressAvailable.value = true;
                  address = element;
                  enableContinueButton.value = true;
                  userAddressResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode,respMessage: successModel.message);
                }
              }
              if(isAddressAvailable.value == false) {
                var element = successModel.data[0];
                address = element;
                enableContinueButton.value = true;
                userAddressResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode,respMessage: successModel.message);
              }
            } else {
              enableContinueButton.value = false;
              userAddressResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
            }
          } else{
            enableContinueButton.value = false;
            var baseFailureModel = BaseFailureModel.fromJson(result.response);
            userAddressResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: baseFailureModel.responseCode,respMessage: baseFailureModel.message);
          }
        }
        else{
          enableContinueButton.value = false;
          userAddressResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        }
      } catch (e) {
        enableContinueButton.value = false;
        userAddressResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "Something Went Wrong");
        printError(info: e.toString());
      }
    } else {
      address = selectedAddress;
      if(selectedAddress != null) {
        enableContinueButton.value = true;
        userAddressResponse.value = ResponseInfo(responseStatus:  Constants.success,respCode: 200,respMessage: "address found");
      } else {
        enableContinueButton.value = false;
        userAddressResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "No Address Found");
      }
    }
  }

  Widget buildUserAddressList() {
    if (userAddressResponse.value.responseStatus == Constants.loading) {
      return const CircularProgressIndicator();
    } else if (userAddressResponse.value.responseStatus == Constants.failure) {
      return Column(
        children: [
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("shipping_address".tr,style: Style.customTextStyle(AppTheme.black, 18, FontWeight.bold, FontStyle.normal),),
          InkWell(
            child: const Icon(CupertinoIcons.arrow_right),
            onTap: (){
              _navigateToShippingListAndRefresh();
            },)
        ]),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: ElevatedButton(
                onPressed: () {
                  _navigateAndRefresh();
                },
                child: Text("add_new_address".tr),
                style: Style.rectangularRedButton(),
              ),
            ),
          ),
        ],
      );
    } else if (userAddressResponse.value.responseStatus == Constants.success) {
      return userInfoView();
    }
    return Container();
  }

  void _navigateAndRefresh() async {
    await Get.to( () =>
        AddEditShippingAddress(null),
        binding: AlterShippingBinding()
    );
    getUserAddressList();
  }

  userInfoView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("shipping_address".tr,style: Style.customTextStyle(AppTheme.black, 18, FontWeight.bold, FontStyle.normal),),
            InkWell(
              child: const Icon(CupertinoIcons.arrow_right),
              onTap: (){
                _navigateToShippingListAndRefresh();
              },)
          ],
        ),
        const SizedBox(height: 10.0,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(address!.firstname + " " + address!.lastname,style: Style.customTextStyle(AppTheme.black, 12, FontWeight.bold, FontStyle.normal)),
            const SizedBox(height: 5.0,),
            Text(address!.phone,style: Style.customTextStyle(AppTheme.black, 12, FontWeight.bold, FontStyle.normal)),
            const SizedBox(height: 5.0,),
            Text(address!.location[0] + "\n" + address!.city + "\n" + address!.country,style: Style.customTextStyle(AppTheme.black, 12, FontWeight.bold, FontStyle.normal))
          ],
        ),
      ],
    );
  }

  _navigateToShippingListAndRefresh() async {
      await Get.to( () =>
      const ShippingListPage(),
          binding: ShippingBinding()
      );
      selectedAddress = Get.find<ShippingController>().selectedAddress;
      if(selectedAddress != null) {
       address = selectedAddress;
       userAddressResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: 200,respMessage: "Address Found");
      } else if(address == null){
        userAddressResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "Something Went Wrong");
      }
  }

  productListView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0,),
          Text("products".tr,style: Style.customTextStyle(AppTheme.black, 18.0, FontWeight.bold, FontStyle.normal),),
          const SizedBox(height: 10.0,),
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(cartProducts[index].image,width: 49.0,height: 49.0,),
                  const SizedBox(width: 15.0,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cartProducts[index].name,style: Style.customTextStyle(Colors.black, 14.0, FontWeight.bold, FontStyle.normal),),
                        const SizedBox(height: 10.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${"qty".tr} - ${cartProducts[index].qty}",style: Style.customTextStyle(Colors.black, 14.0, FontWeight.w200, FontStyle.normal),),
                            Text("sar".tr+" "+"${cartProducts[index].subtotal}",style: Style.normalTextStyle(AppTheme.redce171f, 14.0),)
                          ],
                        ),
                        const SizedBox(height: 25.0,)
                      ],
                    ),
                  )
                ],
              );
            },
            itemCount: cartProducts.length,
          )
        ],
      ),
    );

  }

  priceInfoView() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("price_details".tr,style: Style.customTextStyle(AppTheme.black, 18.0, FontWeight.bold, FontStyle.normal),),
          const SizedBox(height: 10.0,),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text("tax".tr,style: Style.customTextStyle(AppTheme.black, 14.0, FontWeight.normal, FontStyle.normal),),
          //     Row(
          //       children: [
          //         Text("SAR",style: Style.customTextStyle(AppTheme.black, 14.0, FontWeight.normal, FontStyle.normal),),
          //         const SizedBox(width: 5.0,),
          //         Text("${cartData.tax}",style: Style.customTextStyle(AppTheme.redce171f, 14.0, FontWeight.normal, FontStyle.normal),),
          //       ],
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("delivery_charge".tr,style: Style.customTextStyle(AppTheme.black, 14.0, FontWeight.normal, FontStyle.normal),),
              Text("FREE",style: Style.customTextStyle(AppTheme.greenButtonColor, 14.0, FontWeight.normal, FontStyle.normal),),
            ],
          ),
          Visibility(
            visible: isPromoApplied.value,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("discount".tr, style: Style.titleTextStyle(AppTheme.textColor, 15),),
                    const Spacer(),
                    Text("${cartData.discountAmount}", style: Style.titleTextStyle(AppTheme.greenButtonColor, 15),),
                  ],
                ),
              ],
            ),
          ),
          getShippingChargeWidget(),
          const SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("total".tr,style: Style.customTextStyle(AppTheme.black, 14.0, FontWeight.normal, FontStyle.normal),),
              Row(
                children: [
                  Text("sar".tr,style: Style.customTextStyle(AppTheme.black, 14.0, FontWeight.normal, FontStyle.normal),),
                  const SizedBox(width: 5.0,),
                  Text(totalAmount.toStringAsFixed(2),style: Style.customTextStyle(AppTheme.redce171f, 14.0, FontWeight.normal, FontStyle.normal),),
                ],
              ),
            ],
          ),
          const SizedBox(height: 60.0,),
        ],
      ),
    );
  }

  String getCodPrice() {
    if(cartData.cODPrice == 0) {
      return "free".tr;
    }
    return "sar".tr+" "+"${cartData.cODPrice}";
  }

  Widget getShippingChargeWidget() {
    if(cartData.shippingMethods.isNotEmpty) {
      shippingMethod.value = cartData.shippingMethods[0].carrierCode;
    }

    if(shippingMethod.value == "flatrate") {
      shippingAmount.value = cartData.shippingMethods[0].amount.toDouble();
      return Column(
        children: [
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("shipping_charge".tr, style: Style.titleTextStyle(AppTheme.textColor, 15),),
              const Spacer(),
              Text("sar".tr+" "+"${shippingAmount.value}", style: Style.titleTextStyle(AppTheme.greenButtonColor, 15),),
            ],
          ),
        ],
      );
    }
    return Container();
  }
}