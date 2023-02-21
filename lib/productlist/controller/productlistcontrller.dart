import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zihazi_sampleproject/baseclasses/basecontroller.dart';
import 'package:zihazi_sampleproject/dashboard/model/categoryproductsuccessmodel.dart';
import 'package:zihazi_sampleproject/productlist/model/product_subcategory_model.dart';
import 'package:zihazi_sampleproject/productlist/model/product_subcategory_success_model.dart';

import '../../baseclasses/basefailuremodel.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/custome_loader/lodading_indicator.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../../baseclasses/utils/multistate_button/multi_state_button_controller.dart';
import '../../dashboard/view/categoryproductitem.dart';
import '../../login/binding/loginbinding.dart';
import '../../login/model/sub_cat_success_model.dart';
import '../../login/view/loginpage.dart';
import '../../service/networkerrors.dart';
import '../../wishlist/controller/wishlistcontroller.dart';
import '../../wishlist/model/removewishlistmodel.dart';
import '../../wishlist/model/wishlistmodel.dart';
import '../model/category_search_req_model.dart';
import '../model/category_search_resp_model.dart';
import '../model/filtercolorobj.dart';
import '../model/sortitem.dart';
import '../repo/productlistrepo.dart';

class ProductListController extends BaseController with SingleGetTickerProviderMixin{

  TextEditingController searchController= TextEditingController();
  TextEditingController priceStartController= TextEditingController();
  TextEditingController priceEndController= TextEditingController();
  final formKey = GlobalKey<FormState>();
  var searching = false.obs;
  var check = false;
  var lastPageNumber = 1.obs;
  late TabController tabController;
  var repo = Get.put(ProductListRepo());
  RxList<CategoryInSubCategoryModel> subCategoryList=List<CategoryInSubCategoryModel>.empty(growable: true).obs;
  var subCategoryResponse=ResponseInfo(responseStatus: Constants.loading).obs;

  RxList<Products> productList=List<Products>.empty(growable: true).obs;
  var productListResponse=ResponseInfo(responseStatus: Constants.loading).obs;
  var addToWishlistResponse=ResponseInfo(responseStatus: Constants.idle).obs;
  var removeFromWishlistResponse=ResponseInfo(responseStatus: Constants.loading).obs;

  var favProductIds = <String>[];//storing favorite product ids
  var wishListController=Get.find<WishListController>();// to add and remove items from fav and also add to cart

  var categoryId=''.obs;
  var subCategoryId=''.obs;
  var heading=''.obs;
  var fromWhere='';
  var sortName='not_applied'.tr.obs;
  var filterName='not_applied'.tr.obs;
  var currentTechnique=0; //1 for sorting , 2 for filter
  var pageSize=10;
  var pageNo=1.obs;
  var  loadMore = false.obs;
  bool hasMoreData=false;
  ScrollController _scrollController = ScrollController();
  var storageService = Get.find<StorageService>();
  String? token="";

  RxList<SortItem> sortList=List<SortItem>.empty(growable: true).obs;

  var filterObj=FilterObj(filterColorObj: [
    FilterColorObj(colorId: "21",colorName: "black".tr,isChecked: false),
    FilterColorObj(colorId: "22",colorName: "white".tr,isChecked: false),
    FilterColorObj(colorId: "23",colorName: "red".tr,isChecked: false),
    FilterColorObj(colorId: "24",colorName: "rose".tr,isChecked: false),
  ], filterpriceObj: FilterPriceObj(startPrice: "",endPrice: ""), isSelectedId: 0,filterName:"not_applied".tr).obs;





  @override
  void onInit() async{
    recreateFilter();
    recreateSortList();
    tabController=TabController(length: 3, vsync: this);
    fromWhere=Get.arguments[0];
    heading.value=Get.arguments[1];
    token=await storageService.read(Constants.apiToken);
    if(fromWhere=="fromCat"){
      categoryId.value=Get.arguments[2];
      getSubCategory();
    }else{
      getCategorySearch();
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!loadMore.value && hasMoreData) {
          pageNo++;
          if (fromWhere == "fromCat") {
            getProdFromSubCategoryMore();
          } else {
            getCategorySearchMore();
          }
          if (!loadMore.value && hasMoreData) {
            pageNo++;
            if (fromWhere == "fromCat") {
              getProdFromSubCategoryMore();
            } else {
              getCategorySearchMore();
            }
          }
        }
      }
    });



    setFavorite(wishListController.wishListItemsForFilter);

    eventBus.on<String>().listen((event) {
      print("refreshProductListFav event called");
      if(event==Constants.refreshProductListFav){
        setFavorite(wishListController.wishListItemsForFilter);
      }

    });


    super.onInit();
  }

  void getSubCategory() async {

    var result = await repo.getSubCategory({
      "token":token??"",
      "categoryId":categoryId.value
    });
    try {
      if(result.error==null){
        var successModel = SubCategorySuccessModel.fromJson(jsonDecode(result.response));
        subCategoryList.clear();
        subCategoryList.addAll(successModel.data!.categoery!);
        if(subCategoryList.isNotEmpty){
          tabController=TabController(length: subCategoryList.length, vsync: this);
          subCategoryId.value=subCategoryList.first.subCategories!.catId!;
          pageNo.value=1;
          loadMore.value = false;
          hasMoreData=true;
          getProdFromSubCategory();
        }
        subCategoryResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode!,respMessage: successModel.message!);
      }
      else{
        productListResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "no_products".tr);
        subCategoryResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      productListResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "no_products".tr);
      subCategoryResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "no_products".tr);
      printError(info: e.toString());
    }
  }

  void getProdFromSubCategory() async {
    pageNo.value=1;
    print("catID :"+categoryId.value+"subcat ID :"+subCategoryId.value);
    productListResponse.value=ResponseInfo(responseStatus: Constants.loading);
    var result = await repo.getProdFromSubCategory(ProductFromSubCategoryReqModel(token: token??"",
        categoryId: categoryId.value!=''?int.parse(categoryId.value):0, subcategoryId: subCategoryId.value!=''?int.parse(subCategoryId.value):0, pageNo: pageNo.value, pageSize: pageSize, key: currentTechnique==2?getFilterKey():"null",value:  currentTechnique==2?getFilterValue():"null",
        sorder: currentTechnique==1?getSortItem().sortValue:"null",skey:  currentTechnique==1?getSortItem().sortId:"null" ));
    try {
      if(result.error==null){
        var successModel = ProdFromSubCatSuccessModel.fromJson(jsonDecode(result.response));
        lastPageNumber.value = successModel.data!.categoery![0].subCategories!.lastPageNumber!;
        productList.clear();
        productList.addAll(successModel.data!.categoery![0].subCategories!.products!);
        if(successModel.data!.categoery![0].subCategories!.products!.length<pageSize){
          hasMoreData=false;
        }else{
          hasMoreData=true;
        }

        if(productList.isNotEmpty){
          productListResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode!,respMessage: successModel.message!);
        }else{
          productListResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: successModel.successCode!,respMessage: "no_products".tr);
        }

      }
      else{
        productListResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      productListResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "server_error".tr);
      printError(info: e.toString());
    }
  }

  void getProdFromSubCategoryMore() async {
    if(pageSize <= lastPageNumber.value) {
      loadMore.value=true;

      var result = await repo.getProdFromSubCategory(ProductFromSubCategoryReqModel(token: token??"",
          categoryId: categoryId.value!=''?int.parse(categoryId.value):0, subcategoryId: subCategoryId.value!=''?int.parse(subCategoryId.value):0, pageNo: pageNo.value, pageSize: pageSize, key: currentTechnique==2?getFilterKey():'null',value:  currentTechnique==2?getFilterValue():'null',
          sorder: currentTechnique==1?getSortItem().sortValue:"null",skey:  currentTechnique==1?getSortItem().sortId:"null" ));
      try {
        loadMore.value=false;
        if(result.error==null){
          var successModel = ProdFromSubCatSuccessModel.fromJson(jsonDecode(result.response));
          if(successModel.data!.categoery![0].subCategories!.products!.length<pageSize){
            hasMoreData=false;
          }
          productList.addAll(successModel.data!.categoery![0].subCategories!.products!);
          productListResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode!,respMessage: successModel.message!);
          // if(productList.isNotEmpty){
          //
          // }
          productListResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode!,respMessage: successModel.message!);

        }
        else{
          productListResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
          //Error
        }
      } catch (e) {
        loadMore.value=false;
        productListResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "something_went_wrong".tr);
        printError(info: e.toString());
      }
    }
  }

  void getCategorySearch() async {
    pageNo.value=1;
    productListResponse.value=ResponseInfo(responseStatus: Constants.loading);
    var result = await repo.getCategorySearch(CategorySearchReqModel(token: token??"",
        categoryName: heading.value, pageNo: pageNo.value, pageSize: pageSize,
        key: currentTechnique==2?getFilterKey():"null", value: currentTechnique==2?getFilterValue():"null", skey: currentTechnique==1?getSortItem().sortId:"null", sorder: currentTechnique==1?getSortItem().sortValue:"null"));
    try {
      if(result.error==null){
        var responseCode = json.decode(result.response)["SuccessCode"];
        if(responseCode == 200) {
          var successModel = CategorySearchSuccessModel.fromJson(jsonDecode(result.response));
          productList.clear();
          productList.addAll(successModel.data.products);
          if(successModel.data.products.length<pageSize){
            hasMoreData=false;
          }else{
            hasMoreData=true;
          }
          productListResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode,respMessage: successModel.message);
        } else if(responseCode == 400){
          productListResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 400,respMessage: "no_products".tr);
        }
      }
      else{
        productListResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      productListResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "server_error".tr);
      printError(info: e.toString());
    }
  }

  void getCategorySearchMore() async {
    loadMore.value=true;
    var result = await repo.getCategorySearch(CategorySearchReqModel(token: token??"",
        categoryName: heading.value, pageNo: pageNo.value, pageSize: pageSize,
        key: currentTechnique==2?getFilterKey():"null", value: currentTechnique==2?getFilterValue():"null"
        , skey: currentTechnique==1?getSortItem().sortId:"null", sorder: currentTechnique==1?getSortItem().sortValue:"null"));


    try {
      loadMore.value=false;
      if(result.error==null){

        var successModel = CategorySearchSuccessModel.fromJson(jsonDecode(result.response));
        if(successModel.data.products.length<pageSize){
          hasMoreData=false;
        }
        productList.addAll(successModel.data.products);
        productListResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode,respMessage: successModel.message);

      }
      else{
        productListResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      loadMore.value=false;
      productListResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }
  }

  void addToWishlist(String prodId) async {
    addToWishlistResponse.value = ResponseInfo(responseStatus:  Constants.loading);
    print("add to wishlist"+storageService.read(Constants.userId).toString());
    var userId = await storageService.read(Constants.userId);
    var result = await repo.addToWishList({
      "userid":userId,
      "productid":prodId
    });
    try {

      if(result.error==null){
        var responseCode = result.response['SuccessCode'];
        if(responseCode==200){
          var successModel = RemoveWishlistRes.fromJson(result.response);
          Get.snackbar("message".tr,successModel.message);
          if(!favProductIds.contains(prodId.toLowerCase())){
            favProductIds.add(prodId);
          }
          wishListController.getWishlistItems();
          addToWishlistResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode,respMessage: successModel.message);
        } else{
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          Get.snackbar("message".tr,baseFailureModel.message);
          addToWishlistResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: baseFailureModel.responseCode,respMessage: baseFailureModel.message);
        }
      }
      else{
        Get.snackbar("message".tr,"something_went_wrong".tr);
        addToWishlistResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      Get.snackbar("message".tr,"something_went_wrong".tr);
      addToWishlistResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }

  }

  Widget editWishlist(BuildContext context) {
    if(addToWishlistResponse.value.responseStatus == Constants.loading) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Container();
  }

  void removeFromWishlist(String prodId) async {
    addToWishlistResponse.value = ResponseInfo(responseStatus:  Constants.loading);
    var userId = await storageService.read(Constants.userId);
    var result = await repo.removeFromWishList({
      "userid":userId,
      "productid":prodId
    });
    try {

      if(result.error==null){
        var responseCode = result.response['SuccessCode'];
        if(responseCode==200){
          var successModel = RemoveWishlistRes.fromJson(result.response);
          Get.snackbar("message".tr,successModel.message);
          if(favProductIds.contains(prodId.toLowerCase())){
            favProductIds.remove(prodId);
          }
          wishListController.getWishlistItems();
          addToWishlistResponse.value=ResponseInfo(responseStatus:  Constants.success,respCode: successModel.successCode,respMessage: successModel.message);
        } else{
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          Get.snackbar("message".tr,baseFailureModel.message);
          addToWishlistResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: baseFailureModel.responseCode,respMessage: baseFailureModel.message);
        }
      }
      else{
        Get.snackbar("message".tr,result.error);
        addToWishlistResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: result.error);
        //Error
      }
    } catch (e) {
      Get.snackbar("message".tr,"something_went_wrong".tr);
      addToWishlistResponse.value=ResponseInfo(responseStatus:  Constants.failure,respCode: 500,respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }

  }


  List<Widget> buildSubCategories(){
    final children = <Widget>[];
    for (CategoryInSubCategoryModel category in subCategoryList.toList()) {
      children.add(Text(category.subCategories!.catName!));
    }
    return children;
  }


  buildProductList(){
    if(productListResponse.value.responseStatus==Constants.loading){
      return const SizedBox(height: 180,
        child: Center(
          child: SizedBox(
            height: 50,
            child: LoadingIndicator(
              indicatorType: Indicator.ballRotateChase,
              colors:  [AppTheme.primaryColor],
              strokeWidth: 2,
            ),
          ),
        ),);
    }else if(productListResponse.value.responseStatus==Constants.failure){
      return  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(ImageUtil.noInternetIcon),
          ),
          const SizedBox(height: 15),
          Text(
            productListResponse.value.respMessage,
            style: Style.titleTextStyle(AppTheme.blackTextColor, 18),
          )
        ],
      );
    }else{
      if(productList.isNotEmpty) {
        return productGrid();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(ImageUtil.noInternetIcon),
          ),
          const SizedBox(height: 15),
          Text(
            "no_products".tr,
            style: Style.titleTextStyle(AppTheme.blackTextColor, 18),
          )
        ],
      );
    }
  }

  Widget productGrid() {
    return Stack(
      children: [
        Padding(
          padding: loadMore.value?const EdgeInsets.only(bottom: 40.0):const EdgeInsets.only(bottom: 0),
          child: GridView.builder(
              key: ObjectKey(productList[0]),
              gridDelegate:   const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 280
              ),
              itemCount: productList.length,
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext ctx, index) {
                checkIsFavoriteInProduct(productList[index]);
                MultiStateButtonController multiStateController = MultiStateButtonController(initialStateName:Constants.idle);
                print(productList[index].isFavorite);
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0,10,0,10),
                  child: CategoryProductItem(
                    productItem: Products(prodName: productList[index].prodName,
                        isFavorite: productList[index].isFavorite,
                        price: productList[index].price,
                        prodAmount: productList[index].prodAmount,
                        prodId: productList[index].prodId,
                        prodImage:productList[index].prodImage ),
                    isInStock: productList[index].isInStock,
                    isFavorite: productList[index].isFavorite,
                    multiStateButtonController: multiStateController,
                    onAddToCart: (productId) async {
                      bool isLoggedIn = await storageService.checkLogin();
                      if(!isLoggedIn) {
                        Get.to(LoginPage(page: Constants.productList, productId: productId,), binding: LoginBinding())!.then((value){

                        });
                      }else{
                        wishListController.addProductToCart(productId);// we are using wish list controller api for add to cart to reduce code usage
                      }

                    },
                    onFavoriteClicked: (productId,isFavorite)async{
                      bool isLoggedIn = await storageService.checkLogin();
                      if(!isLoggedIn) {
                        Get.to(LoginPage(page: Constants.productList, productId: productId,), binding: LoginBinding())!.then((value){

                        });
                      }else{
                        if(productList[index].isFavorite){
                          removeFromWishlist(productId);
                        }else{
                          addToWishlist(productId);
                        }
                      }
                    },),
                );
              }),
        ),
        loadMore.value?const Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height:40,
            width: 40,
            child: LoadingIndicator(
              indicatorType: Indicator.ballRotateChase,
              colors:  [AppTheme.primaryColor],
              strokeWidth: 2,
            ),
          ),
        ):Container(),
      ],
    );
  }

  buildColorList(){
    return SizedBox(
      height: 80,
      child: Obx(()=>
          ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: filterObj.value.filterColorObj.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: (){
                  // recreateFilter();
                  priceStartController.clear();
                  priceEndController.clear();
                  for (var element in filterObj.value.filterColorObj) {
                    if(element.isChecked==true){
                      element.isChecked=false;
                    }
                  }
                  filterObj.value.filterColorObj[index].isChecked=true;
                  filterObj.value.isSelectedId=1;
                  filterObj.value.filterName="color".tr;
                  filterName.value=filterObj.value.filterName;
                  sortName.value="not_applied".tr;
                  sortName.refresh();
                  // recreateSortList();
                  sortList.refresh();
                  currentTechnique=2;
                  filterObj.refresh();
                  if(fromWhere=="fromCat"){
                    getProdFromSubCategory();
                  }else{
                    getCategorySearch();
                    Get.focusScope!.canRequestFocus=false;
                  }
                  Get.back();


                },
                child: Column(
                  children: [
                    Container(
                      child: filterObj.value.filterColorObj[index].isChecked
                          ? const Icon(
                        Icons.check_circle,
                        size: 30.0,
                        color: AppTheme.primaryColor,
                      )
                          :
                      const Icon(
                        Icons.circle_outlined,
                        size: 30.0,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(filterObj.value.filterColorObj[index].colorName),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          ),
      ),
    );
  }

  Widget buildPriceRangeWidget() {
    return Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              Expanded(
                child: TextFormField(
                  autofocus: false,
                  controller: priceStartController,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(priceStartController.text==""){
                      return "you_must_enter_a_value".tr;
                    }
                    if(priceEndController.text!=""){
                      if(double.parse(priceStartController.text)>double.parse(priceEndController.text)){
                        return "end_price_should_be_greater_than_Start_Price".tr;
                      }
                    }


                    return null;
                  },
                  decoration: Style.normalTextFieldStyle(
                      "start_price".tr, "start_price".tr),
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: TextFormField(
                  autofocus: false,
                  controller: priceEndController,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(priceEndController.text==""){
                      return "you_must_enter_a_value".tr;
                    }
                    if(priceStartController.text!=""){
                      if(double.parse(priceStartController.text)>double.parse(priceEndController.text)||priceEndController.text==""){
                        return "end_price_should_be_greater_than_Start_Price".tr;
                      }
                    }


                    return null;
                  },
                  decoration: Style.normalTextFieldStyle(
                      "end_price".tr, "end_price".tr),
                ),

              ),
              const SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      style: Style.rectangularRedButton(),
                      onPressed: () async {
                        // recreateFilter();
                        if(formKey.currentState!.validate()){
                          filterObj.value.isSelectedId=2;
                          filterObj.value.filterName="price".tr;
                          filterName.value=filterObj.value.filterName;
                          sortName.value="not_applied".tr;
                          sortName.refresh();
                          // recreateSortList();
                          sortList.refresh();
                          filterObj.value.filterpriceObj.startPrice=priceStartController.text;
                          filterObj.value.filterpriceObj.endPrice=priceEndController.text;
                          currentTechnique=2;
                          if(fromWhere=="fromCat"){
                            getProdFromSubCategory();
                          }else{
                            getCategorySearch();
                            Get.focusScope!.canRequestFocus=false;
                          }
                          Get.back();
                        }
                      },
                      child:  Text("apply".tr)
                  ),
                ),
              ),

            ],
          ),
        )
    );
  }

  SortItem getSortItem(){
    return sortList.value.firstWhere((sortitem) => sortitem.isChecked);
  }

  String getFilterValue(){
    var value="";
    if(filterObj.value.isSelectedId==1){
      value = filterObj.value.filterColorObj.firstWhere((item) => item.isChecked).colorId;
    }else{
      if(filterObj.value.filterpriceObj.startPrice=="0"&&filterObj.value.filterpriceObj.endPrice=="0"){
        value="";
      }else{
        value = filterObj.value.filterpriceObj.startPrice+"-"+filterObj.value.filterpriceObj.endPrice;
      }

    }
    return value;
  }
  String getFilterKey(){
    var key="";
    if(filterObj.value.isSelectedId==1){
      key = "colorsmva";
    }else{
      key = "price";
    }
    return key;
  }

  void setFavorite(RxList<CartData> favItems) {
    favProductIds.clear();

    if(favItems.isEmpty){
      productList.refresh();
      return;
    }
    for (var element in favItems) {
      favProductIds.add(element.productId.toLowerCase());
      productList.refresh();
    }
  }

  checkIsFavoriteInProduct(Products products){
    // Here checking each item is fav or not
    print("product id length  "+favProductIds.length.toString());

    if(favProductIds.isEmpty){
      products.isFavorite=false;
      print("no fav all empty");
    }else{
      if(favProductIds.contains(products.prodId.toLowerCase())){
        products.isFavorite=true;
        print("fav found  "+products.prodId.toLowerCase());
      }else{
        products.isFavorite=false;
        print("not favv  "+products.prodId.toLowerCase());
      }
    }

  }

  refreshFilter(){
    priceStartController.clear();
    priceEndController.clear();
    // recreateFilter();
    currentTechnique=0;
    filterName.value="not_applied".tr;
    filterName.refresh();
    if(fromWhere=="fromCat"){
      getProdFromSubCategory();
    }else{
      getCategorySearch();
    }
  }


  void recreateSortList(){
    sortList.clear();
    sortList.add(SortItem(sortId: "name",sortName: "name".tr,sortValue: "0",isChecked: false));
    sortList.add(SortItem(sortId: "price",sortName: "price".tr,sortValue: "0",isChecked: false));
    sortList.add(SortItem(sortId: "Accessory_Type",sortName: "accessory_type".tr,sortValue: "0",isChecked: false));
    sortList.add(SortItem(sortId: "batterysize",sortName: "battery_size".tr,sortValue: "0",isChecked: false));
    sortList.add(SortItem(sortId: "cabletype",sortName: "cable_type".tr,sortValue: "0",isChecked: false));
    sortList.add(SortItem(sortId: "supportQc3",sortName: "support_qc3",sortValue: "0",isChecked: false));
    sortList.add(SortItem(sortId: "compatiblewith",sortName: "compatible_with".tr,sortValue: "0",isChecked: false));
    sortList.add(SortItem(sortId: "inputport",sortName: "input_port".tr,sortValue: "0",isChecked: false));
    sortList.add(SortItem(sortId: "outputport",sortName: "output_port".tr,sortValue: "0",isChecked: false));
    sortList.add(SortItem(sortId: "Connectivity",sortName: "connectivity".tr,sortValue: "0",isChecked: false));
    sortList.add(SortItem(sortId: "weightsmva",sortName: "weight".tr,sortValue: "0",isChecked: false));
    sortList.add(SortItem(sortId: "batterytype",sortName: "battery_type".tr,sortValue: "0",isChecked: false));
    sortList.add(SortItem(sortId: "length",sortName: "length".tr,sortValue: "0",isChecked: false));
  }

  recreateFilter(){
    filterObj=FilterObj(filterColorObj: [
      FilterColorObj(colorId: "21",colorName: "black".tr,isChecked: false),
      FilterColorObj(colorId: "22",colorName: "white".tr,isChecked: false),
      FilterColorObj(colorId: "23",colorName: "red".tr,isChecked: false),
      FilterColorObj(colorId: "24",colorName: "rose".tr,isChecked: false),
    ], filterpriceObj: FilterPriceObj(startPrice: "",endPrice: ""), isSelectedId: 0,filterName:"not_applied".tr).obs;
    filterObj.refresh();

  }
}