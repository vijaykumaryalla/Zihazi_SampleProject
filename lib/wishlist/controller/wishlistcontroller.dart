import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zihazi_sampleproject/baseclasses/basecontroller.dart';

import '../../baseclasses/basefailuremodel.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/custome_loader/lodading_indicator.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../../baseclasses/utils/multistate_button/multi_state_button_controller.dart';
import '../../login/binding/loginbinding.dart';
import '../../login/view/loginpage.dart';
import '../../service/networkerrors.dart';
import '../model/addtocart.dart';
import '../model/removewishlistmodel.dart';
import '../model/wishlistmodel.dart';
import '../repo/wishlistrepo.dart';
import '../view/wishlistproductitem.dart';

class WishListController extends BaseController{
  var wishlistResponse=ResponseInfo(responseStatus: Constants.loading).obs;
  var addToCartResponse = ResponseInfo(responseStatus: Constants.success).obs;
  var addWishlistResponse = ResponseInfo(responseStatus: Constants.idle).obs;
  var removeWishlistResponse = ResponseInfo(responseStatus: Constants.idle).obs;
  var wishlistItemsModel= <CartData>[].obs;

  var isWishListApiCalled = false.obs;


  var wishListItemsForFilter = <CartData>[].obs;
  var storageService = Get.find<StorageService>();


  TextEditingController searchController= TextEditingController();

  var isOpenSearchBox = false.obs;
  var isLoggedIn = false.obs;


  var repo = Get.put(WishlistRepo());


  WishListController(){
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent
    ));

    checkConnection();

    isConnected.listen((value) async {
      isLoggedIn.value = await storageService.checkLogin();
      if(value&&isLoggedIn.value){
        callAPIs();
      }
    });

    eventBus.on<String>().listen((event) {
      if(event==Constants.refreshWishlist){
        callAPIs();
      }
    });

    eventBus.on<String>().listen((event) { // listening for login callback to load data again
      print("login event called");
      if(event==Constants.loginSuccess){
        isLoggedIn.value=true;
        callAPIs();
      }

    });
  }

  callAPIs(){
    getWishlistItems();

    eventBus.on<String>().listen((event) {
      print("refresh wishlist event called");
      if(event==Constants.refreshWishList){
        getWishlistItems();
      }
    });
  }

  Widget buildWishlistItems(){
    if(isLoggedIn.value==false){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("login_to_view_wishlist".tr,style: Style.customTextStyle(AppTheme.black, 14.0, FontWeight.normal, FontStyle.normal),),
          SizedBox(height: 10,),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              style: Style.elevatedNormalRedButton(),
              onPressed: (){
                Get.to( LoginPage(page: Constants.wishlist, productId: "",), binding: LoginBinding());
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
    }else
    if(wishlistResponse.value.responseStatus==Constants.loading){
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
    else if(wishlistResponse.value.responseStatus==Constants.failure){
      return  Center(
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
                wishlistResponse.value.respMessage,
                style: Style.titleTextStyle(AppTheme.blackTextColor, 18),
              )
            ],
          ),
        ),
      );
    }else{
      return Expanded(
        child: GridView.builder(
            key: UniqueKey(),
            shrinkWrap: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            gridDelegate:   SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: (Get.width/2),
            ),
            itemCount: wishlistItemsModel.length,
            scrollDirection: Axis.vertical,
            physics: const PageScrollPhysics(),
            itemBuilder: (BuildContext ctx, index) {
              MultiStateButtonController multiStateController = MultiStateButtonController(initialStateName:Constants.idle);
              return InkWell(
                onTap: () {
                  Get.toNamed("/productdetail",arguments: [wishlistItemsModel[index].productId, wishlistItemsModel[index].isInStock]);
                },
                child: WishlistProductItem(productItem: wishlistItemsModel[index],
                  multiStateButtonController: multiStateController,
                  onAddToCart: (productId){
                    addProductToCart(productId);
                  },
                  onFavoriteClicked: (productId,isFavorite){
                    wishlistResponse.value.responseStatus=Constants.loading;
                    wishlistResponse.refresh();
                    removeWishlistItems(productId);
                  },),
              );
            }),
      );

    }
  }

  getWishlistItems() async {
    print("length");
    wishlistResponse.value = ResponseInfo(responseStatus:  Constants.loading);
    print(wishlistItemsModel.length);
    wishlistItemsModel.clear();
    wishListItemsForFilter.clear();
    var userId = await storageService.read(Constants.userId);
    var result = await repo.getWishlistItems({
      "userid":userId,
    });
    print(result.response);
    try {
      if(result.error==null){
        var responseCode = result.response['SuccessCode'];
        if(responseCode==200){

          var successModel = WishlistModel.fromJson(result.response);

          if(successModel.data.cartData.isNotEmpty){
            wishlistItemsModel.clear();
            wishListItemsForFilter.clear();
            wishlistItemsModel.value.addAll(successModel.data.cartData);
            wishListItemsForFilter.value=successModel.data.cartData;
            isWishListApiCalled.value=true;
          }
          print("getWishlistItems ========>");
          eventBus.fire(wishListItemsForFilter);
          eventBus.fire(Constants.refreshProductListFav);


          wishlistResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode,respMessage: successModel.message);
        } else{
          eventBus.fire(wishListItemsForFilter);
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          wishlistResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: baseFailureModel.responseCode,respMessage: baseFailureModel.message);
        }
      }
      else{
        wishlistResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      wishlistResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }

  }

  removeWishlistItems(String productId) async {


    var userId = await storageService.read(Constants.userId);
    var result = await repo.removeWishlistItems({
      "userid":userId,
      "productid":productId
    });
    try {

      if(result.error==null){
        var responseCode = result.response['SuccessCode'];
        if(responseCode==200){
          var successModel = RemoveWishlistRes.fromJson(result.response);
          Get.snackbar("message".tr,successModel.message);
          getWishlistItems();
          removeWishlistResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode,respMessage: successModel.message);
        } else{
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          removeWishlistResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: baseFailureModel.responseCode,respMessage: baseFailureModel.message);
        }
      }
      else{
        removeWishlistResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      removeWishlistResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "Something Went Wrong");
      printError(info: e.toString());
    }

  }

  Widget handleRemoveWishlistAPI() {
    if(removeWishlistResponse.value.responseStatus==Constants.loading){
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
    else if(removeWishlistResponse.value.responseStatus==Constants.failure) {
      Get.snackbar("message".tr, removeWishlistResponse.value.respMessage);
    } else if(removeWishlistResponse.value.responseStatus==Constants.success) {
      Get.snackbar("message".tr, removeWishlistResponse.value.respMessage);
    }
    return Container();
  }

  // this function can be called from other pages
  addWishlistItems(String productId) async {


    var userId = await storageService.read(Constants.userId);
    print(userId.toString()+"  user id");
    var result = await repo.addWishlistItems({
      "userid":userId,
      "productid":productId
    });
    try {

      if(result.error==null){
        var responseCode = result.response['SuccessCode'];
        var message = result.response['message'];
        if(responseCode==200){
          Get.snackbar("message".tr,message);
          getWishlistItems();
          addWishlistResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: responseCode,respMessage: message);
        } else{
          Get.snackbar("message".tr,message);
          addWishlistResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: responseCode,respMessage: message);
        }
      }
      else{
        Get.snackbar("message".tr,result.response['message']);
        addWishlistResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      Get.snackbar("message".tr,"something_went_wrong".tr);
      addWishlistResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }

  }



  void onSearchWishlist(String searchValue) {
    print(searchValue);
    if(searchValue.isEmpty){
      wishlistItemsModel.addAll(wishListItemsForFilter);

    }else if(searchValue.isNotEmpty){
      wishlistItemsModel.clear();
      wishListItemsForFilter.forEach((element) {
        if(element.name.toLowerCase().contains(searchValue.toLowerCase())){
          wishlistItemsModel.add(element);
        }
      });
    }



  }

  Future<void> addProductToCart(String productId) async {
    addToCartResponse.value=ResponseInfo(responseStatus:  Constants.loading,respCode: 0,respMessage: "");
    var userId = await storageService.read(Constants.userId);
    var result = await repo.addProductToCart({
      "userid":userId,
      "productid":productId
    });
    try {

      if(result.error==null){
        var responseCode = result.response['SuccessCode'];
        if(responseCode==200){
          eventBus.fire(Constants.refreshCart);
          var successModel = AddWishListToCart.fromJson(result.response);
          Get.snackbar("message".tr,successModel.message);
          getWishlistItems();
          addToCartResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode,respMessage: successModel.message);
        } else{
          var message = result.response['message'];
          Get.snackbar("message".tr,message);
          addToCartResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: responseCode,respMessage: message);
        }
      }
      else{
        Get.snackbar("message".tr,"something_went_wrong".tr);
        addToCartResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "something_went_wrong".tr);
        //Error
      }
    } catch (e) {
      Get.snackbar("message".tr,"something_went_wrong".tr);
      addToCartResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }

  }
}