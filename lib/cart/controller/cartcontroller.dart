import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zihazi_sampleproject/baseclasses/basecontroller.dart';

import '../../baseclasses/basefailuremodel.dart';
import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/custome_loader/lodading_indicator.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../../login/binding/loginbinding.dart';
import '../../login/view/loginpage.dart';
import '../../service/networkerrors.dart';
import '../model/cart.dart';
import '../repo/cartrepo.dart';
import '../view/cartitem.dart';

class CartController extends BaseController{
  RxList<CartData> cartList = List<CartData>.empty(growable: true).obs;
  late Cart cartData;
  var totalAmount = 0.0.obs;
  var shippingAmount = 0.0.obs;
  var shippingMethod = "freeshipping".obs;
  var cartResponse = ResponseInfo(responseStatus: Constants.idle).obs;
  var removeItemResponse = ResponseInfo(responseStatus: Constants.idle).obs;
  var updateItemResponse = ResponseInfo(responseStatus: Constants.idle).obs;
  var removeCouponResponse = ResponseInfo(responseStatus: Constants.idle).obs;
  var repo = Get.find<CartRepo>();
  var storageService = Get.find<StorageService>();
  var isLoggedIn = false.obs;
  var isPromoApplied = false.obs;
  TextEditingController promoController = TextEditingController();
  var promoResponse = ResponseInfo(responseStatus: Constants.idle).obs;

  CartController(){
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent
    ));
    checkConnection();

    isConnected.listen((value) async {
      var loggedIn = await storageService.checkLogin();
      if(value&&loggedIn){
        getCartItems();
      }
    });

    eventBus.on<String>().listen((event) {
      print("refresh Cart event called");
      if(event==Constants.refreshCart||event==Constants.paymentCompleted || event==Constants.loginSuccess){
        getCartItems();
      }
    });
  }

  Future<void> getCartItems() async {
    totalAmount.value = 0.0;
    shippingAmount.value = 0.0;
    cartResponse.value = ResponseInfo(responseStatus: Constants.loading);
    updateItemResponse.value = ResponseInfo(responseStatus: Constants.idle);
    removeItemResponse.value = ResponseInfo(responseStatus: Constants.idle);
    var userId = await storageService.read(Constants.userId);
    var loggedIn = await storageService.checkLogin();
    if(loggedIn) {
      var result = await repo.getCartItems({"userid": userId});
      print(result.response);
      try {
        if (result.error == null && result.response != null) {
          var responseCode = json.decode(result.response)["SuccessCode"];
          var data = json.decode(result.response)['data'];
          if (responseCode == 200) {
            if(data is! List) {
              var successModel = Cart.fromJson(json.decode(result.response));
              cartData = successModel;
              cartList.clear();
              cartList.addAll(successModel.data.cartData);
              cartResponse.value = ResponseInfo(
                  responseStatus: Constants.success,
                  respCode: successModel.successCode,
                  respMessage: successModel.message);
            } else {
              //Empty List
              cartList.clear();
              cartResponse.value = ResponseInfo(
                  responseStatus: Constants.success,
                  respCode: 200,
                  respMessage: "empty_cart".tr);
            }
          } else if(responseCode == 400) {
            var data = json.decode(result.response)['data'];
            var cartData = data['Cart Data'];
            if(cartData.isEmpty) {
              cartList.clear();
              cartResponse.value = ResponseInfo(
                  responseStatus: Constants.empty,
                  respCode: 400,
                  respMessage: "empty_cart".tr);
            }
          } else {
            var baseFailureModel = BaseFailureModel.fromJson(result.response);
            cartResponse.value = ResponseInfo(
                responseStatus: Constants.failure,
                respCode: baseFailureModel.responseCode,
                respMessage: baseFailureModel.message);
          }
        } else {
          cartResponse.value = ResponseInfo(
              responseStatus: Constants.failure,
              respCode: 500,
              respMessage: result.error);
        }
      } catch (e) {
        cartResponse.value = ResponseInfo(
            responseStatus: Constants.failure,
            respCode: 500,
            respMessage: "something_went_wrong".tr);
        printError(info: e.toString());
      }
    } else {
      cartResponse.value = ResponseInfo(responseStatus: Constants.notLoggedIn);
    }
  }

  Widget buildCartList() {
    if (cartResponse.value.responseStatus == Constants.loading) {
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
    } else if(cartResponse.value.responseStatus == Constants.empty) {
      return  GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.direction > 0) {
            getCartItems();
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                SvgPicture.asset(ImageUtil.noInternetIcon),
                const SizedBox(height: 15),
                Text(
                  cartResponse.value.respMessage,
                  style: Style.titleTextStyle(AppTheme.blackTextColor, 18),
                )
              ],
            ),
          ),
        ),
      );
    } else if (cartResponse.value.responseStatus == Constants.failure) {
      return Column(
        children: [
          const SizedBox(height: 150),
          PageErrorView((){}, NoData(msg: cartResponse.value.respMessage)),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              style: Style.elevatedNormalRedButton(),
              onPressed: (){
                getCartItems();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("retry".tr,style: Style.normalTextStyle(Colors.white, 18.0),),
                ],

              ),

            ),
          )
        ],
      );
    } else if(cartResponse.value.responseStatus == Constants.success) {
      if(cartList.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 150),
            PageErrorView((){}, NoData(msg: "cart_is_empty".tr)),
          ],
        );
      }
      getTotalPrice();
      return SingleChildScrollView (
        child: Column(
          children: [
            GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.direction > 0) {
                  getCartItems();
                }
              },
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: cartList.length,
                itemBuilder: (context, index) {
                  return CartItem(cartList[index]);
                },
              ),
            ),
            getChargesWidget()
          ],
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("please_login_to_see_cart".tr,style: Style.customTextStyle(AppTheme.black, 14.0, FontWeight.normal, FontStyle.normal),),
          const SizedBox(height: 10,),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              style: Style.elevatedNormalRedButton(),
              onPressed: (){
                Get.to( const LoginPage(page: Constants.cart, productId: "",), binding: LoginBinding());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("login".tr,style: Style.normalTextStyle(Colors.white, 18.0),),
                ],

              ),

            ),
          )
        ],
      );
    }
  }

  Widget getChargesWidget() {
    if (cartResponse.value.responseStatus == Constants.success) {
      if(cartData.discountAmount < 0) {
        isPromoApplied.value = true;
      } else {
        isPromoApplied.value = false;
      }
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("promo_code".tr, style: Style.titleTextStyle(AppTheme.blackTextColor, 16)),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 190,
                      height: 43,
                      child: TextFormField(
                        controller: promoController,
                        validator: (value) {
                          return validatePromo(value!);
                        },
                        maxLines: 1,
                        autofocus: false,
                        decoration:  InputDecoration(
                          fillColor: AppTheme.inputFillColor,
                          filled: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppTheme.inputFillColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppTheme.inputFillColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: SizedBox(
                        height: 43,
                        child: ElevatedButton(
                          onPressed: () {
                            if(promoController.text.isNotEmpty) {
                              applyCoupon();
                            } else {
                              Get.snackbar("message".tr, "promo_can_not_be_empty".tr);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Text(
                              "apply_coupon".tr,
                              style: Style.titleTextStyle(Colors.white, 14),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(AppTheme.greenButtonColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: isPromoApplied.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 211,
                        decoration:  const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(ImageUtil.couponContainer),
                              fit: BoxFit.fill
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40.0, bottom: 8, top: 8, right:16),
                          child: Text("promo_applied".tr, style: Style.titleTextStyle(AppTheme.primaryColor, 14)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: InkWell(
                            onTap: (){
                              removeCouponCode();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'remove'.tr,
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: AppTheme.primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: AppTheme.dividerColor,
                )
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("price_details".tr, style: Style.titleTextStyle(AppTheme.blackTextColor, 16)),
                      const SizedBox(height: 20),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text("tax".tr, style: Style.titleTextStyle(AppTheme.textColor, 15),),
                      //     const Spacer(),
                      //     Text("SAR", style: Style.titleTextStyle(AppTheme.secondaryTextColor, 15),),
                      //     const SizedBox(width: 5),
                      //     Text("${cartData.tax}", style: Style.titleTextStyle(AppTheme.primaryColor, 15),),
                      //   ],
                      // ),
                      // const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("delivery_charge".tr, style: Style.titleTextStyle(AppTheme.textColor, 15),),
                          const Spacer(),
                          Text("FREE", style: Style.titleTextStyle(AppTheme.greenButtonColor, 15),),
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
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("total".tr, style: Style.titleTextStyle(AppTheme.textColor, 15),),
                          const Spacer(),
                          Text("sar".tr, style: Style.titleTextStyle(AppTheme.secondaryTextColor, 15),),
                          const SizedBox(width: 5),
                          Text(getTotalPrice(), style: Style.titleTextStyle(AppTheme.primaryColor, 15),),
                        ],
                      ),
                      const SizedBox(height: 100)
                    ],
                  ),
                  _placeOrderButton()
                ],
              )
          ),
        ],
      );
    }
    return Container();
  }

  _placeOrderButton() {
    return Column(
      children: [
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FloatingActionButton(
            elevation: 2,
            backgroundColor: AppTheme.primaryColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6))
            ), onPressed: () {
            Get.toNamed('/checkoutinfopage');
          },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  "continue".tr,
                  style: Style.titleTextStyle(Colors.white, 15),
                ),
                const SizedBox(width: 50,),
                Text(
                  "sar".tr+" "+getTotalPrice(),
                  style: Style.titleTextStyle(Colors.white, 15),
                ),
                const SizedBox(width: 15,),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  String getTotalPrice() {
    totalAmount.value = 0.0;
    if(totalAmount.value < 200) {
      totalAmount.value = (shippingAmount.value).toDouble();
    }
    for (var element in cartList) {
      totalAmount.value += element.subtotal;
    }
    // totalAmount.value = totalAmount.value + (cartData.discountAmount) + (cartData.tax).toDouble();
    totalAmount.value = totalAmount.value + (cartData.discountAmount);
    return totalAmount.value.toStringAsFixed(2);
  }

  void updateCart(String productId, int qty) async {
    updateItemResponse.value = ResponseInfo(responseStatus: Constants.loading);
    var userId = await storageService.read(Constants.userId);
    var result = await repo.updateQuantity({
      "userid": userId,
      "productid": productId,
      "qty": qty
    });
    try {
      if (result.error == null) {
        var responseCode = result.response['SuccessCode'];
        var message = result.response['message'];
        if (responseCode == 200) {
          updateItemResponse.value = ResponseInfo(
              responseStatus: Constants.success,
              respCode: responseCode,
              respMessage: message);
        } else {
          updateItemResponse.value = ResponseInfo(
              responseStatus: Constants.failure,
              respCode: responseCode,
              respMessage: message);
        }
      } else {
        updateItemResponse.value = ResponseInfo(
            responseStatus: Constants.failure,
            respCode: 500,
            respMessage: "something_went_wrong".tr);
      }
    } catch (e) {
      updateItemResponse.value = ResponseInfo(
          responseStatus: Constants.failure,
          respCode: 500,
          respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }
  }

  void removeItem(String productId) async {
    removeItemResponse.value = ResponseInfo(responseStatus: Constants.loading);
    var userId = await storageService.read(Constants.userId);
    var result = await repo.removeItem({
      "userid": userId,
      "productid": productId
    });
    try {
      if (result.error == null) {
        var responseCode = result.response['SuccessCode'];
        var message = result.response['message'];
        if (responseCode == 200) {
          removeItemResponse.value = ResponseInfo(
              responseStatus: Constants.success,
              respCode: responseCode,
              respMessage: message);
        } else {
          removeItemResponse.value = ResponseInfo(
              responseStatus: Constants.failure,
              respCode: responseCode,
              respMessage: message);
        }
      } else {
        removeItemResponse.value = ResponseInfo(
            responseStatus: Constants.failure,
            respCode: 500,
            respMessage: result.error);
      }
    } catch (e) {
      removeItemResponse.value = ResponseInfo(
          responseStatus: Constants.failure,
          respCode: 500,
          respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }
  }

  Widget handleRemoveItemResponse(BuildContext context) {
    if (removeItemResponse.value.responseStatus == Constants.loading) {
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
    } else if (removeItemResponse.value.responseStatus == Constants.failure) {
      Future.delayed(Duration.zero, () async {
        Get.back();
        Get.snackbar("message".tr, removeItemResponse.value.respMessage);
      });
    } else if (removeItemResponse.value.responseStatus == Constants.success) {
      Future.delayed(Duration.zero, () async {
        Get.back();
        Get.snackbar("message".tr, "product_removed".tr);
        getCartItems();
      });
    }
    return Container();
  }

  Widget handleUpdateItemResponse(BuildContext context) {
    if (updateItemResponse.value.responseStatus == Constants.loading) {
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
    } else if (updateItemResponse.value.responseStatus == Constants.failure) {
      Future.delayed(Duration.zero, () async {
        Get.back();
        Get.snackbar("message".tr, updateItemResponse.value.respMessage);
      });
    } else if (updateItemResponse.value.responseStatus == Constants.success) {
      Future.delayed(Duration.zero, () async {
        Get.back();
        Get.snackbar("message".tr, "product_updated".tr);
        getCartItems();
      });
    }
    return Container();
  }

  String getCodPrice() {
    if(cartData.cODPrice == 0) {
      return "free".tr;
    }
    return "sar".tr+" "+"${cartData.cODPrice}";
  }

  void applyCoupon() async {
    promoResponse.value = ResponseInfo(responseStatus: Constants.loading);
    var userId = await storageService.read(Constants.userId);
    var result = await repo.applyCoupon({
      "userid": userId,
      "couponCode": promoController.value.text
    });
    print(result.response);
    try {
      if (result.error == null) {
        var responseCode = result.response['SuccessCode'];
        var message = result.response['message'];
        if (responseCode == 200) {
          promoResponse.value = ResponseInfo(
              responseStatus: Constants.success,
              respCode: responseCode,
              respMessage: message);
        } else {
          promoResponse.value = ResponseInfo(
              responseStatus: Constants.failure,
              respCode: responseCode,
              respMessage: message);
        }
      } else {
        promoResponse.value = ResponseInfo(
            responseStatus: Constants.failure,
            respCode: 500,
            respMessage: result.error);
      }
    } catch (e) {
      promoResponse.value = ResponseInfo(
          responseStatus: Constants.failure,
          respCode: 500,
          respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }
  }

  Widget handlePromoResponse(BuildContext context) {
    if (promoResponse.value.responseStatus == Constants.loading) {
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
    } else if (promoResponse.value.responseStatus == Constants.failure) {
      Future.delayed(Duration.zero, () async {
        Get.back();
        isPromoApplied.value = false;
        Get.snackbar("message".tr, promoResponse.value.respMessage);
      });
    } else if (promoResponse.value.responseStatus == Constants.success) {
      Future.delayed(Duration.zero, () async {
        Get.back();
        promoController.clear();
        isPromoApplied.value = true;
        Get.snackbar("message".tr, promoResponse.value.respMessage);
        getCartItems();
      });
    }
    return Container();
  }

  validatePromo(String value) {
    if(value.isEmpty) {
      return "promo_can_not_be_empty".tr;
    }
    return null;
  }

  removeCouponCode() async{
    removeCouponResponse.value = ResponseInfo(responseStatus: Constants.loading);
    var userId = await storageService.read(Constants.userId);
    var result = await repo.removeCoupon({
      "userid": userId,
    });
    try {
      if (result.error == null) {
        var responseCode = result.response['SuccessCode'];
        var message = result.response['message'];
        if (responseCode == 200) {
          removeCouponResponse.value = ResponseInfo(
              responseStatus: Constants.success,
              respCode: responseCode,
              respMessage: message);
        } else {
          removeCouponResponse.value = ResponseInfo(
              responseStatus: Constants.failure,
              respCode: responseCode,
              respMessage: message);
        }
      } else {
        removeCouponResponse.value = ResponseInfo(
            responseStatus: Constants.failure,
            respCode: 500,
            respMessage: result.error);
      }
    } catch (e) {
      removeCouponResponse.value = ResponseInfo(
          responseStatus: Constants.failure,
          respCode: 500,
          respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }
  }

  Widget handleRemovePromoResponse(BuildContext context) {
    if (removeCouponResponse.value.responseStatus == Constants.loading) {
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
    } else if (removeCouponResponse.value.responseStatus == Constants.failure) {
      Future.delayed(Duration.zero, () async {
        Get.back();
        isPromoApplied.value = true;
        Get.snackbar("message".tr, promoResponse.value.respMessage);
      });
    } else if (removeCouponResponse.value.responseStatus == Constants.success) {
      Future.delayed(Duration.zero, () async {
        Get.back();
        isPromoApplied.value = false;
        Get.snackbar("message".tr, removeCouponResponse.value.respMessage);
        getCartItems();
      });
    }
    return Container();
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