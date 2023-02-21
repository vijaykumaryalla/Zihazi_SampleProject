import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zihazi_sampleproject/baseclasses/theme.dart';
import 'package:zihazi_sampleproject/baseclasses/utils/search_bar.dart';

import '../../baseclasses/styles.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../controller/productlistcontrller.dart';


class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {


  @override
  Widget build(BuildContext context) {

    var controller= Get.put(ProductListController());
    return Obx(()=>(
        Scaffold(
          backgroundColor: AppTheme.white,
          appBar: AppBar(
            leading:  IconButton(
              icon:  const Icon(Icons.arrow_back),iconSize: 30,
              onPressed: () => Get.back(),
            ),
            titleSpacing: 0,
            title: Center(
                child:  SearchBar(
                  isSearching: controller.searching.value, headingText: controller.heading.value,
                  onSubmitted: (value){
                    controller.heading.value=value;
                  },
                )),
            actions: <Widget>[

              InkWell(
                onTap: (){
                  if(controller.searching.value){
                    Get.focusScope!.previousFocus();
                    controller.fromWhere="fromSearch";
                    controller.getCategorySearch();
                  }else{
                    FocusScope.of(context).unfocus();
                    Get.focusScope!.nextFocus();
                  }
                  setState(() {
                    controller.searching.value = !controller.searching.value;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(controller.searching.value?ImageUtil.arrowIcon:ImageUtil.searchIcon,
                    height: controller.searching.value?30:24,width: controller.searching.value?30:24,),
                ) ,
              ),

              Visibility(
                visible: false,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(ImageUtil.cartIcon,height: 24,width: 24,),
                ),
              ),
              const SizedBox(width: 8,)
            ],
          ),
          bottomNavigationBar:  Wrap(
            children: [
              Obx(()=>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            Get.bottomSheet(
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Obx(()=>(
                                        ListView.separated(
                                          padding: const EdgeInsets.all(8),
                                          itemCount: controller.sortList.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return InkWell(
                                              onTap: (){
                                                for (var element in controller.sortList) {
                                                  if(element.isChecked==true){
                                                    element.isChecked=false;
                                                  }
                                                }
                                                controller.sortList[index].isChecked=true;
                                                controller.sortName.value=controller.sortList[index].sortName;
                                                controller.sortList.refresh();
                                                controller.filterName.value="not_applied".tr;
                                                controller.filterName.refresh();
                                                controller.recreateFilter();
                                                controller.currentTechnique=1;
                                                if(controller.fromWhere=="fromCat"){
                                                  controller.getProdFromSubCategory();
                                                }else{
                                                  controller.getCategorySearch();
                                                  Get.focusScope!.canRequestFocus=false;
                                                }
                                                Get.back();

                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    child: controller.sortList[index].isChecked
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
                                                  Expanded(child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(controller.sortList[index].sortName),
                                                  )),
                                                  InkWell(
                                                    onTap: (){
                                                      if(controller.sortList[index].sortValue=="0"){
                                                        controller.sortList[index].sortValue="1";
                                                      }else{
                                                        controller.sortList[index].sortValue="0";
                                                      }
                                                      controller.sortList.refresh();
                                                    },
                                                    child: AnimatedContainer(
                                                        duration: const Duration(milliseconds: 500),
                                                        child: controller.sortList[index].sortValue=="0"? const Icon(Icons.arrow_circle_down_sharp,size: 34,):
                                                        const Icon(Icons.arrow_circle_up_sharp,size: 34,)
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (BuildContext context, int index) => const Divider(),
                                        )
                                    ),
                                    )
                                ),
                                elevation: 20.0,
                                enableDrag: false,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                    )
                                )

                            );
                          },
                          child: Container(
                            color: AppTheme.bottomStripGrey,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(ImageUtil.sortIcon),
                                  const SizedBox(width: 14,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("sort_by".tr,
                                        style: Style.titleTextStyle(AppTheme.blackTextColor, 16),),
                                      const SizedBox(height: 5,),
                                      Text(controller.sortName.value,
                                        style: Style.normalTextStyle(AppTheme.blackTextColor, 12),)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 2,),
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            controller.priceStartController=TextEditingController(text: controller.filterObj.value.filterpriceObj.startPrice);
                            controller.priceEndController=TextEditingController(text: controller.filterObj.value.filterpriceObj.endPrice);

                            Get.bottomSheet(
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 16, left: 16, bottom: 16),
                                          child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text("color".tr, style: Style.titleTextStyle(AppTheme.blackTextColor, 16),)),
                                        ),
                                        controller.buildColorList(),
                                        SizedBox(
                                          height: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 16, left: 16, bottom: 16),
                                            child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text("price_range".tr, style: Style.titleTextStyle(AppTheme.blackTextColor, 16),)),
                                          ),
                                        ),
                                        controller.buildPriceRangeWidget(),
                                        InkWell(
                                          onTap: (){
                                            controller.refreshFilter();
                                            Get.back();
                                          },
                                          child: Text("clear".tr,
                                            style: Style.titleTextStyle(AppTheme.primaryColor, 16),),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                                elevation: 20.0,
                                enableDrag: false,
                                backgroundColor: Colors.white,

                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                    )
                                )
                            ).whenComplete(() {
                              controller.priceStartController.clear();
                              controller.priceEndController.clear();
                            });
                          },
                          child: Container(
                            color: AppTheme.bottomStripGrey,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(ImageUtil.filterIcon),
                                  const SizedBox(width: 14,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("filter".tr,
                                        style: Style.titleTextStyle(AppTheme.blackTextColor, 16),),
                                      const SizedBox(height: 5,),
                                      Text(controller.filterName.value,
                                        style: Style.normalTextStyle(AppTheme.blackTextColor, 12),)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(

              children: [
                controller.fromWhere=="fromCat"?DefaultTabController(
                  length: controller.subCategoryList.length,
                  initialIndex: 0,
                  child: Column(
                    children: <Widget>[
                      Obx(() => controller.editWishlist(context)),
                      Container(
                        constraints: const BoxConstraints.expand(height: 50),
                        child:  TabBar(tabs: controller.buildSubCategories(),
                          indicatorColor: AppTheme.primaryColor,
                          isScrollable: true,
                          unselectedLabelColor: AppTheme.primaryColor,
                          labelColor: AppTheme.primaryColor,
                          indicatorSize: TabBarIndicatorSize.tab,

                          onTap: (index){
                            controller.tabController.animateTo(index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut);
                            controller.subCategoryId.value=controller.subCategoryList[index].subCategories!.catId!;
                            controller.getProdFromSubCategory();
                          },),
                      ),

                    ],
                  ),
                ):const SizedBox(width: 0,height: 0,),
                Expanded(
                  child: controller.buildProductList(),
                )

              ],
            ),
          ),
        )
    ),
    );


  }

}
