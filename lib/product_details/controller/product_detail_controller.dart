


import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zihazi_sampleproject/baseclasses/basefailuremodel.dart';
import 'package:zihazi_sampleproject/product_details/model/product_detail_model.dart';
import 'package:zihazi_sampleproject/wishlist/model/wishlistmodel.dart';

import '../../baseclasses/basecontroller.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/utils/constants.dart';
import '../../review/binding/reviewbinding.dart';
import '../../review/view/reviewpage.dart';
import '../../service/networkerrors.dart';
import '../../wishlist/controller/wishlistcontroller.dart';
import '../repo/product_detail_repo.dart';

class ProductDetailController extends BaseController{
  var productId="";
  var productDetailResponse=ResponseInfo(responseStatus: Constants.loading).obs;
  var addRemoveFavItem=ResponseInfo(responseStatus: Constants.loading).obs;
  var storageService = Get.find<StorageService>();
  RxList<String> bottomDescList = List<String>.empty(growable: true).obs;
  RxList<MoreInfo> moreDescList = List<MoreInfo>.empty(growable: true).obs;
  RxList<ReviewsList> reviewList = List<ReviewsList>.empty(growable: true).obs;
  late List<ProductImageUrl> productImageUrlList = <ProductImageUrl>[].obs;
  var title = "".obs;
  var productStarts = "0.0".obs;
  var productPrice = "".obs;
  var totalRating = "".obs;
  var productTopDesc = "".obs;
  var isFavorite = false.obs;
  var isInStock = true.obs;
  var productBottomDesc = <String>[].obs;
  var productMoreInfo = <String>[].obs;

  var selectedItemNumber = 0.obs;

  var itemQuantity=1.obs;

  var repo = Get.find<ProductDetailRepo>();
  var wishListController=Get.find<WishListController>();

  ProductDetailController(){
    selectedItemNumber.value=1; //for the bottom items selection count
    productId = Get.arguments[0];
    isInStock.value = Get.arguments[1];

    callProductDetailApi(productId);
  }

  callProductDetailApi(String productId) async {

    var userId = await storageService.read(Constants.userId);
    var result = await repo.getProductDetails({
      "token":"62jfy7a465b22r2vnd0p3drkmcwr4r0a",
      "productid":productId,
      "userId":userId
    });
    try {
      if(result.error==null){
        var responseCode = result.response['SuccessCode'];
        print('====================${result.response}');
        if(responseCode==200){
          var successModel = ProductDetailModel.fromJson(result.response);

          productDetailResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode,respMessage: successModel.message);
          setDetailData(successModel);
        } else{
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          productDetailResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: baseFailureModel.responseCode,respMessage: baseFailureModel.message);
        }
      }
      else{
        productDetailResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      productDetailResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }
  }

  void navigateAndRefreshReview(BuildContext context) async {
    await Get.to( () =>
        ReviewPage(productId),
        binding: ReviewBinding()
    );
    callProductDetailApi(productId);
  }

  setDetailData(ProductDetailModel productDetailModel)
  {
    productImageUrlList.addAll(productDetailModel.data.productImageUrl);
    title.value=productDetailModel.data.title;
    if(productDetailModel.data.rating!=null){
      double rating = (int.parse(productDetailModel.data.rating) * 5 ) / 100 ;
      productStarts.value=rating.toString();
    }
    productPrice.value=productDetailModel.data.prodAmount;
    totalRating.value=productDetailModel.data.rating;
    productTopDesc.value=productDetailModel.data.topDesc;
    bottomDescList.addAll(productDetailModel.data.bottomDesc);
    reviewList.addAll(productDetailModel.data.reviewsList);
    moreDescList.addAll(productDetailModel.data.moreInfo);
    productId = productDetailModel.data.productId;
    isFavorite.value = productDetailModel.data.isFavorate;
  }

  bool setFavorite(RxList<CartData> favItems) {
    var isFav =false;
    for (var element in favItems) {
      if(productId.toLowerCase()==element.productId.toLowerCase()) {
        isFav=true;
      }
    }
    return isFav;
  }

}