import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zihazi_sampleproject/baseclasses/styles.dart' as app_style;
import 'package:zihazi_sampleproject/product_details/model/product_detail_model.dart';
import 'package:zihazi_sampleproject/product_details/view/product_slider.dart';

import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/custome_loader/lodading_indicator.dart';
import '../../dashboard/view/favoritebutton.dart';
import '../../login/binding/loginbinding.dart';
import '../../login/view/loginpage.dart';
import '../../service/networkerrors.dart';
import '../../wishlist/controller/wishlistcontroller.dart';
import '../controller/product_detail_controller.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  _PageState createState() {
    return _PageState();
  }
}

class _PageState extends State<ProductDetailPage> {
  var wishlistController = Get.find<WishListController>();
  var productDetailController = Get.find<ProductDetailController>();
  var storageService = Get.find<StorageService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: FavoriteButton(
              valueChanged: (_isFavorite) async {
                bool isLoggedIn = await storageService.checkLogin();
                if (isLoggedIn) {
                  if (_isFavorite) {
                    wishlistController
                        .addWishlistItems(productDetailController.productId);
                  } else {
                    wishlistController
                        .removeWishlistItems(productDetailController.productId);
                  }
                  productDetailController.callProductDetailApi(productDetailController.productId);
                } else {
                  Get.to(
                      LoginPage(
                        page: Constants.productDetail,
                        productId: productDetailController.productId,
                      ),
                      binding: LoginBinding());
                }
              },
              iconColor: AppTheme.primaryColor,
              iconSize: 40,
              iconDisabledColor: AppTheme.headingTextColor,
              isFavorite: productDetailController
                  .setFavorite(wishlistController.wishListItemsForFilter),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: productDetailController.isConnected.value
            ? Obx(() => (_mainBody()))
            : PageErrorView(() {}, NoInternetError()),
      ),
    );
  }

  Widget _mainBody() {
    if (productDetailController.productDetailResponse.value.responseStatus ==
        Constants.loading) {
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
    } else if (productDetailController
        .productDetailResponse.value.responseStatus ==
        Constants.failure) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            productDetailController.productDetailResponse.value.respMessage,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      );
    } else {
      return Obx(() => (Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[productSlider(), productDetails()],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: productDetailController.isInStock.value
                    ? Obx(
                      () => Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: app_style.Style
                              .elevatedNormalRedButton(),
                          onPressed: () async {
                            bool isLoggedIn =
                            await storageService.checkLogin();
                            if (isLoggedIn) {
                              if (wishlistController.addToCartResponse
                                  .value.responseStatus !=
                                  Constants.loading) {
                                wishlistController.addProductToCart(
                                    productDetailController
                                        .productId);
                              }
                            } else {
                              Get.to(
                                  LoginPage(
                                    page: Constants.productDetail,
                                    productId: productDetailController
                                        .productId,
                                  ),
                                  binding: LoginBinding());
                            }
                          },
                          child: wishlistController.addToCartResponse
                              .value.responseStatus ==
                              Constants.loading
                              ? showAddToCartLoading()
                              : Text("add_to_cart".tr),
                        ),
                      )
                    ],
                  ),
                )
                    : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style:
                        app_style.Style.disabledButton(),
                        onPressed: () {

                        },
                        child: wishlistController.addToCartResponse
                            .value.responseStatus ==
                            Constants.loading
                            ? showAddToCartLoading()
                            : Text("out_of_stock".tr),
                      ),
                    )
                  ],
                ),
              )),
        ],
      )));
    }
  }

  Widget showAddToCartLoading() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(color: Colors.white)),
            const SizedBox(width: 10),
            Text("adding_to_cart".tr)
          ],
        ),
      ),
    );
  }

  Widget productSlider() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Align(
          alignment: Alignment.topCenter,
          child: ProductSlider(
              items: productDetailController.productImageUrlList)),
    );
  }

  Widget productDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(productDetailController.title.value,
              style: app_style.Style.titleTextStyle(AppTheme.black, 18)),
          const SizedBox(height: 10),
          reviewWidget(),
          const SizedBox(height: 10),
          Text(
              "sar".tr+" "+
                  double.parse(productDetailController.productPrice.value)
                      .toStringAsFixed(2),
              style: app_style.Style.titleTextStyle(AppTheme.redce171f, 16.0)),
          const SizedBox(height: 10),
          Text(
            productDetailController.productTopDesc.value,
            style: app_style.Style.normalTextStyle(AppTheme.black, 14),
          ),
          const SizedBox(height: 10),
          // deliveryDetailsList(),
          const SizedBox(height: 10),
          productDetailsTitle(),
          productDescriptionView(),
          productMoreDetailsView(),
          productReviewView(),
        ],
      ),
    );
  }

  reviewWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AbsorbPointer(
          child: Row(
            children: [
              starRating(
                  productDetailController.productStarts.value != "0.0"
                      ? double.parse(
                      productDetailController.productStarts.value)
                      : 0.0,
                  1.0,
                  12,
                  false,
                  5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  productDetailController.productStarts.value,
                  style: app_style.Style.normalTextStyle(
                      AppTheme.orangeDD780CFF, 12),
                ),
              )
            ],
          ),
        ),
        InkWell(
            onTap: () async {
              bool isLoggedIn = await storageService.checkLogin();
              if (isLoggedIn) {
                productDetailController.navigateAndRefreshReview(context);
              } else {
                Get.to(
                    LoginPage(
                      page: Constants.productDetail,
                      productId: productDetailController.productId,
                    ),
                    binding: LoginBinding());
              }
            },
            child: Container(
                padding: const EdgeInsets.only(
                  bottom: 5, // Space between underline and text
                ),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                          color: Colors.amber,
                          width: 1.0, // Underline thickness
                        ))),
                child: Text("write_a_review".tr,
                    style: app_style.Style.normalTextStyle(
                        AppTheme.orangeDD780CFF, 14.0)))),
      ],
    );
  }

  Widget starRating(double initialRating, double minRating, double itemSize,
      bool allowHalfRating, int itemCount) {
    return RatingBar.builder(
      initialRating: initialRating,
      minRating: minRating,
      itemSize: itemSize,
      direction: Axis.horizontal,
      allowHalfRating: allowHalfRating,
      itemCount: itemCount,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: AppTheme.orangeDD780CFF,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }

  Widget timelineRow(String title, String subTile, bool isLastItem) {
    var color = AppTheme.black;
    if (isLastItem) {
      color = Colors.transparent;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 2,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.rectangle,
                ),
                child: Text(""),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${title}\n ${subTile}',
                  style: const TextStyle(
                      fontFamily: "regular",
                      fontSize: 14,
                      color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }

  Widget deliveryDetailsList() {
    // return Obx(()=>
    var isLastItem = false;
    var initialItemTopPadding = 0.0;

    return Container(
      margin: const EdgeInsets.all(10.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            initialItemTopPadding = 5.0;
          } else {
            initialItemTopPadding = 0.0;
          }

          if (index == 1) {
            isLastItem = true;
          }
          return Container(
            decoration: const BoxDecoration(color: AppTheme.greyf0f0f0),
            padding: EdgeInsets.only(
              top: initialItemTopPadding,
              left: 0.0,
              bottom: 0.0,
            ),
            child: Column(
              children: <Widget>[
                timelineRow(
                    "order_confirmed".tr, "orderDateTime".tr, isLastItem)
              ],
            ),
          );
        },
        itemCount: 2,
      ),
    );
  }

  Widget productDetailsTitle() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              productDetailController.selectedItemNumber.value = 1;
            },
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: productDetailController.selectedItemNumber == 1
                        ? AppTheme.primaryColor
                        : null,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text("description".tr,
                        style: TextStyle(
                            color: productDetailController
                                .selectedItemNumber ==
                                1
                                ? AppTheme.white
                                : AppTheme.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'opensans')),
                  ),
                )),
          ),
        ),
        Container(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              productDetailController.selectedItemNumber.value = 2;
            },
            child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: productDetailController.selectedItemNumber == 2
                        ? AppTheme.primaryColor
                        : null,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0))),
                child: Center(
                  child: Text("more_info".tr,
                      style: TextStyle(
                          color:
                          productDetailController.selectedItemNumber ==
                              2
                              ? AppTheme.white
                              : AppTheme.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'opensans')),
                )),
          ),
        ),
        Container(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              productDetailController.selectedItemNumber.value = 3;
            },
            child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: productDetailController.selectedItemNumber == 3
                        ? AppTheme.primaryColor
                        : null,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0))),
                child: Center(
                  child: Text("review".tr,
                      style: TextStyle(
                          color:
                          productDetailController.selectedItemNumber ==
                              3
                              ? AppTheme.white
                              : AppTheme.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'opensans')),
                )),
          ),
        ),
      ],
    ));
  }

  productDescriptionView() {
    return Obx(
          () => Visibility(
        visible: productDetailController.selectedItemNumber == 1 ? true : false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0, top: 20),
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Text(".",
                        style:
                        app_style.Style.normalTextStyle(Colors.black, 25)),
                    Expanded(
                      child: Html(
                          data: productDetailController
                              .bottomDescList.value[index]),
                    ),
                  ],
                );
              },
              itemCount: productDetailController.bottomDescList.length),
        ),
      ),
    );
  }

  Widget productMoreDetailsView() {
    return Obx(
          () => Visibility(
        visible: productDetailController.selectedItemNumber == 2 ? true : false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0, top: 20),
          child: productDetailController.moreDescList.isNotEmpty
              ? ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Text(".",
                        style: app_style.Style.normalTextStyle(
                            Colors.black, 25)),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                          child: Text(
                            productDetailController
                                .moreDescList[index].label +" : " +productDetailController
                                .moreDescList[index].value,
                            maxLines: 50,
                          ),
                        )),
                  ],
                );
              },
              itemCount: productDetailController.moreDescList.length)
              : Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(child: Text("no_more_detail".tr)),
          ),
        ),
      ),
    );
  }

  Widget productReviewView() {
    return Obx(
          () => Visibility(
        visible: productDetailController.selectedItemNumber == 3 ? true : false,
        child: Container(
          padding: const EdgeInsets.only(bottom: 100.0, top: 20),
          child: productDetailController.reviewList.isNotEmpty
              ? ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        child: reviewListItem(
                            productDetailController.reviewList[index])),
                    if (productDetailController.reviewList.length - 1 !=
                        index)
                      Container(
                        width: double.infinity,
                        height: 2,
                        color: AppTheme.greyf0f0f0,
                      )
                  ],
                );
              },
              itemCount: productDetailController.reviewList.length)
              : Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(child: Text("no_reviews".tr)),
          ),
        ),
      ),
    );
  }

  Widget reviewListItem(ReviewsList reviewsList) {
    var title = reviewsList.title;
    var starsRating = reviewsList.rating;
    var personName = reviewsList.customerName;
    var date = reviewsList.date;
    var commentsDesc = reviewsList.description;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 5),
        AbsorbPointer(
          child: Row(
            children: [
              starRating(double.parse(starsRating), 1.0, 15, true, 5),
              const SizedBox(width: 10.0),
              Text(
                "by".tr + personName + " " + date,
                style: app_style.Style.customTextStyle(AppTheme.grey5B5E60FF,
                    12, FontWeight.normal, FontStyle.italic),
              )
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(commentsDesc)
      ],
    );
  }
}
