import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zihazi_sampleproject/baseclasses/common_indicator.dart';

import 'package:zihazi_sampleproject/cart/model/cart.dart';
import 'package:zihazi_sampleproject/dashboard/model/categoryproductsuccessmodel.dart';

import '../../baseclasses/basecontroller.dart';
import '../../baseclasses/basefailuremodel.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/custome_loader/lodading_indicator.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../../baseclasses/utils/multistate_button/multi_state_button_controller.dart';
import '../../login/binding/loginbinding.dart';
import '../../login/view/loginpage.dart';
import '../../service/networkerrors.dart';
import '../../wishlist/controller/wishlistcontroller.dart';
import '../model/bannersuccessmodel.dart';
import '../model/categorysuccessmodel.dart';
import '../model/topbrandsuccessmodel.dart';
import '../repo/dashboardrepo.dart';
import '../view/categoryproductitem.dart';
class DashboardController extends BaseController{

  TextEditingController searchController= TextEditingController();

  var currentCarousel = 0.obs;
  final CarouselController carouselController = CarouselController();
  var repo = Get.find<DashboardRepo>();
  var storageService = Get.find<StorageService>();
  //BannerList
  RxList<BannerList> bannerList = List<BannerList>.empty(growable: true).obs;
  var bannerResponse=ResponseInfo(responseStatus: Constants.loading).obs;
  //CategoryList
  RxList<Categories> categoryList=List<Categories>.empty(growable: true).obs;
  var categoryResponse=ResponseInfo(responseStatus: Constants.loading).obs;
  //CategoryProduct
  var categoryProductObj=CategoryProductSuccessModel.fromCatProdSuccess().obs;
  var categoryProdResponse=ResponseInfo(responseStatus: Constants.loading).obs;
  var products = List<Products>.empty(growable: true).obs;
  //Top Brands
  RxList<Brands> topBrandList=List<Brands>.empty(growable: true).obs;
  var topBrandResponse=ResponseInfo(responseStatus: Constants.loading).obs;
  var prodId="";
  var token='';


  var favProductIds = <String>[];//storing favorite product ids
  var wishListController=Get.find<WishListController>();// to add and remove items from fav and also add to cart

  DashboardController(){
    checkConnection();
    isConnected.listen((value) {
      if(value){
        callAPIs();
      }
    });
  }

  callAPIs(){

    getBanner();
    getCategories();
    getCategoryProducts();
    getTopBrands();

    eventBus.on<RxList<CartData>>().listen((event) {
      print("event called");
      setFavorite(event); // storing product id to above list
    });

  }

  @override
  void onInit() async{
    if(Get.arguments!=null){
      prodId=Get.arguments as String;
    }
    token = await storageService.read(Constants.apiToken)??"";
    eventBus.on<String>().listen((event) {
      if(event==Constants.refreshDashboard){
        print("Entered HERE..");
        callAPIs();
      }
    });
    super.onInit();
  }

  void getBanner() async {

    var result = await repo.getBanner({
      "identifier":"slider"
    });
    try {
      if(result.error==null){
        var responseCode = result.response['SuccessCode'];
        if(responseCode==200){
          var bannerModel = BannerSuccessModel.fromJson(result.response);
          bannerList.clear();
          bannerList.addAll(bannerModel.data.bannerList);
          bannerResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: bannerModel.successCode,respMessage: bannerModel.message);
        } else{
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          bannerResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: baseFailureModel.responseCode,respMessage: baseFailureModel.message);
        }
      }
      else{
        bannerResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      bannerResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: e.toString());
      printError(info: e.toString());
    }
  }

  void getCategories() async {

    categoryResponse.value=ResponseInfo(responseStatus: Constants.loading);
    var result = await repo.getCategories();
    try {
      if(result.error==null){
        var responseCode = result.response['SuccessCode'];
        if(responseCode==200){
          var successModel = CategorySuccessModel.fromJson(result.response);
          categoryList.clear();
          categoryList.addAll(successModel.data.categories);
          categoryResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.SuccessCode,respMessage: successModel.message);
        } else{
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          categoryResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: baseFailureModel.responseCode,respMessage: baseFailureModel.message);
        }
      }
      else{
        categoryResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      categoryResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }
  }

  void getCategoryProducts() async {
    categoryProdResponse.value=ResponseInfo(responseStatus: Constants.loading);
    var result = await repo.getCategoryProducts({
      "token":token
    });
    print(result.response);
    try {
      if(result.error==null){
        var responseCode = result.response['SuccessCode'];
        if(responseCode==200){
          var successModel = CategoryProductSuccessModel.fromJson(result.response);
          categoryProductObj.value=successModel;
          categoryProdResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.SuccessCode,respMessage: successModel.message);
        } else{
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          categoryProdResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: baseFailureModel.responseCode,respMessage: baseFailureModel.message);
        }
      }
      else{
        categoryProdResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      categoryProdResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }
  }

  void getTopBrands() async {

    topBrandResponse.value=ResponseInfo(responseStatus: Constants.loading);
    var result = await repo.getTopBrands();
    try {
      if(result.error==null){
        var responseCode = result.response['SuccessCode'];
        if(responseCode==200){
          var successModel = TopBrandSuccessModel.fromJson(result.response);
          topBrandList.clear();
          topBrandList.addAll(successModel.data.brands);
          topBrandResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode,respMessage: successModel.message);
        } else{
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          topBrandResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: baseFailureModel.responseCode,respMessage: baseFailureModel.message);
        }
      }
      else{
        topBrandResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      topBrandResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }
  }

  Widget buildCarousel(){
    if(bannerResponse.value.responseStatus==Constants.loading){
      return const SizedBox(height: 180,
        child: Center(
          child: SizedBox(
            height: 50,
            child:CommonIndicator(indicatorType: IndicatorType.CubeGrid)
            // LoadingIndicator(
            //   indicatorType: Indicator.ballRotateChase,
            //   colors:  [AppTheme.primaryColor],
            //   strokeWidth: 2,
            // ),
          ),
        ),);
    }else if(bannerResponse.value.responseStatus==Constants.failure){
      // return  SizedBox(height: 180,child: Center(child: Text(bannerResponse.value.respMessage,
      //   style: const TextStyle(
      //     fontSize: 16,
      //     fontWeight: FontWeight.w400,
      //     color: AppTheme.primaryColor,
      //   ),),),);
      return const SizedBox(width: 0,height: 0,);
    }else{
      return CarouselSlider.builder(
        itemCount: bannerList.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
            Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Image.network(bannerList[itemIndex].bannerImg,fit: BoxFit.fill,),
                ),
              ),
            ),
        options: CarouselOptions(
            height: 180,
            autoPlay: true,
            viewportFraction: 1.0,
            enlargeCenterPage: true,
            pageSnapping: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              currentCarousel.value = index;
            }
        ),

      );
    }
  }

  Widget buildCategories(){
    if(categoryResponse.value.responseStatus==Constants.loading){
      return const SizedBox(height: 100,
        child: Center(
          child: SizedBox(
            height: 40,
            child: CommonIndicator(indicatorType: IndicatorType.Wave)
            // LoadingIndicator(
            //   indicatorType: Indicator.ballRotateChase,
            //   colors:  [AppTheme.primaryColor],
            //   strokeWidth: 2,
            // ),
          ),
        ),);
    }else if(categoryResponse.value.responseStatus==Constants.failure){
      // return  SizedBox(height: 100,child: Center(child: Text(categoryResponse.value.respMessage,
      //   style: const TextStyle(
      //     fontSize: 16,
      //     fontWeight: FontWeight.w400,
      //     color: AppTheme.primaryColor,
      //   ),),),);
      return const SizedBox(width: 0,height: 0,);
    }else{
      return Padding(
        padding: const EdgeInsets.only(bottom: 24.0, top: 24),
        child: SizedBox(
          height: 30,
          width: double.infinity,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryList.length,
              itemBuilder: (context, pos) {
                return InkWell(
                  onTap: (){
                    Get.toNamed('/product_list',arguments: ["fromCat",categoryList[pos].categoryName,categoryList[pos].categoryId]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: AppTheme.bottomStripGrey,
                          borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(categoryList[pos].categoryName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.blackTextColor,
                              ),),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      );
    }
  }

  Widget buildCategoryProducts(){
    if(categoryProdResponse.value.responseStatus==Constants.loading){
      return const SizedBox(height: 100,
        child: Center(
          child: SizedBox(
            height: 40,
            child:CommonIndicator(indicatorType: IndicatorType.Circle)
            // LoadingIndicator(
            //   indicatorType: Indicator.ballRotateChase,
            //   colors:  [AppTheme.primaryColor],
            //   strokeWidth: 2,
            // ),
          ),
        ),);
    }else if(categoryProdResponse.value.responseStatus==Constants.failure){
      // return  SizedBox(height: 100,child: Center(child: Text(categoryProdResponse.value.respMessage,
      //   style: const TextStyle(
      //     fontSize: 16,
      //     fontWeight: FontWeight.w400,
      //     color: AppTheme.primaryColor,
      //   ),),),);
      return const SizedBox(width: 0,height: 0,);
    }else{
      return ListView.separated(
        itemCount: categoryProductObj.value.data.category.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, pos) {
          products.clear();
          for (var element in categoryProductObj.value.data.category[pos].topCategories.products) {
            if(element.isInStock) {
              products.add(element);
            }
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14.0,0,14,14),
                child: Stack(
                  children:  [
                    Align(alignment: Alignment.centerLeft,child: Text(categoryProductObj.value.data.category[pos].topCategories.catName,style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.blackTextColor
                    ),)),
                    InkWell(
                      onTap: (){
                        Get.toNamed('/product_list',arguments: ["fromCat",categoryProductObj.value.data.category[pos].topCategories.catName,categoryProductObj.value.data.category[pos].topCategories.catId]);
                      },
                      child: Align(alignment: Alignment.centerRight,child:Text('view_all'.tr,style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor
                      ),
                      )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 280,
                width: double.infinity,
                child: GridView.builder(
                  key: UniqueKey(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisExtent: (Get.width/2),
                  ),
                  scrollDirection: Axis.horizontal,
                  physics: const PageScrollPhysics(),
                  itemBuilder: (BuildContext ctx, index) {
                    products.clear();
                    for (var element in categoryProductObj.value.data.category[pos].topCategories.products) {
                      if(element.isInStock) {
                        products.add(element);
                      }
                    }

                    setFavInProducts(products[index]);  // Here checking item is fav or not

                    MultiStateButtonController multiStateController = MultiStateButtonController(initialStateName:Constants.idle);
                    if(products[index].isInStock) {
                      return CategoryProductItem(
                        productItem: products[index],
                        multiStateButtonController: multiStateController, isInStock: products[index].isInStock,
                        isFavorite: products[index].isFavorite,
                        onAddToCart: (productId) async {
                          bool isLoggedIn = await storageService.checkLogin();
                          if(!isLoggedIn) {
                            Get.to( () => LoginPage(page: Constants.productDetail, productId: productId,), binding: LoginBinding());
                          }else{
                            wishListController.addProductToCart(productId);
                          }
                          printInfo(info: ""+productId);
                        },
                        onFavoriteClicked: (productId,isFavorite) async {
                          bool isLoggedIn = await storageService.checkLogin();
                          if(!isLoggedIn) {
                            Get.to( () => LoginPage(page: Constants.productDetail, productId: productId,), binding: LoginBinding());
                          }else{
                            if(isFavorite){
                              print("add to wishlist");
                              wishListController.addWishlistItems(productId);
                            }else{
                              wishListController.removeWishlistItems(productId);
                            }
                            getCategoryProducts();
                          }

                        },);
                    }
                    return const SizedBox(height: 0, width: 0);
                  },
                  itemCount: products.length,
                ),
              ),
            ],
          );
        }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 8,); },);
    }
  }

  Widget buildTopBrands(){
    if(topBrandResponse.value.responseStatus==Constants.loading){
      return const SizedBox(height: 100,
        child: Center(
          child: SizedBox(
            height: 40,
            child: CommonIndicator(indicatorType: IndicatorType.FoldingCube)
            // LoadingIndicator(
            //   indicatorType: Indicator.ballRotateChase,
            //   colors:  [AppTheme.primaryColor],
            //   strokeWidth: 2,
            // ),
          ),
        ),);
    }else if(topBrandResponse.value.responseStatus==Constants.failure){
      // return  SizedBox(height: 100,child: Center(child: Text(topBrandResponse.value.respMessage,
      //   style: const TextStyle(
      //     fontSize: 16,
      //     fontWeight: FontWeight.w400,
      //     color: AppTheme.primaryColor,
      //   ),),),);
      return const SizedBox(width: 0,height: 0,);
    }else{
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Stack(
              children:  [
                Align(alignment: Alignment.centerLeft,child: Text('brands'.tr,style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.blackTextColor
                ),)),
                // Align(alignment: Alignment.centerRight,child:Text('View All',style: TextStyle(
                //     fontSize: 13,
                //     fontWeight: FontWeight.w600,
                //     color: AppTheme.primaryColor
                // ),
                // )),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: GridView.builder(
                gridDelegate:   SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: (Get.width/2),
                    crossAxisSpacing: 14
                ),
                itemCount: topBrandList.length,
                physics: const PageScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 14,right: 14),
                    child: Image.network(topBrandList[index].brandImage,fit: BoxFit.cover,
                      errorBuilder: ( context, exception, stackTrace) {
                        return Center(child: SvgPicture.asset(ImageUtil.noImageIcon),);
                      },),
                  );
                }),
          ),
        ],
      );
    }
  }

  void setFavorite(RxList<CartData> favItems) {
    favProductIds.clear();
    print("setFavInDashboard  setting");
    for (var element in favItems) {
      favProductIds.add(element.productId.toLowerCase());
    }
    categoryProductObj.refresh();

  }

  setFavInProducts(Products products){
    if(favProductIds.isEmpty){
      products.isFavorite=false;
    }else{
      if(favProductIds.contains(products.prodId.toLowerCase())){
        products.isFavorite=true;
      }else{
        products.isFavorite=false;
      }
    }
  }

}