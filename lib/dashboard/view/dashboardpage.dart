import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zihazi_sampleproject/baseclasses/pageloaderror.dart';
import 'package:zihazi_sampleproject/baseclasses/theme.dart';
import 'package:zihazi_sampleproject/dashboard/controller/dashboardcontroller.dart';
import 'package:zihazi_sampleproject/productlist/view/productlistpage.dart';
import 'package:zihazi_sampleproject/service/networkerrors.dart';

import '../../baseclasses/customsliverpersistence.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../../baseclasses/utils/scrolling_indicator/scrolling_indicator.dart';
import '../../baseclasses/utils/scrolling_indicator/scrolling_indicator_effect.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var controller=Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {


    return Obx(()=>(
        Scaffold(
          backgroundColor: AppTheme.white,
          body: SafeArea(
            child:controller.isConnected.value? CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14,right: 14,top:14),
                    child: SizedBox(
                      width: double.infinity,
                      child: Align(alignment: Alignment.center,child: Image.asset(ImageUtil.appLogo,height: 40,)),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: CustomPersistentHeader(
                    backgroundColor: AppTheme.white,
                    widget: Padding(
                      padding: const EdgeInsets.only(left: 14,right: 14,top: 25,bottom: 14),
                      child: TextFormField(
                        autofocus: false,
                        controller: controller.searchController,
                        onEditingComplete: (){
                          FocusScope.of(context).unfocus();
                        },
                        onFieldSubmitted: (String value){
                          if(controller.searchController.text!=""){
                            Get.to(ProductListPage(),arguments: ["fromSearch",controller.searchController.text]);
                            controller.searchController.clear();
                          }

                        },
                        decoration: Style.searchTextFieldStyle(
                            "search_for_items".tr,  ImageUtil.searchIcon, (bool){
                          controller.searchController.clear();
                        }),
                      ),
                    ),
                  ),

                ),
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [

                      Obx(()=>(
                          controller.buildCarousel()
                      ),
                      ),
                      Obx(()=>
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnimatedSmoothIndicator(
                                activeIndex: controller.currentCarousel.value,
                                count:  controller.bannerList.length,
                                effect: const ScrollingDotsEffect(
                                    activeStrokeWidth: 1.2,
                                    activeDotScale: 1.2,
                                    maxVisibleDots: 5,
                                    radius: 6,
                                    spacing: 10,
                                    dotHeight: 6,
                                    dotWidth: 6,
                                    activeDotColor: AppTheme.primaryColor,
                                    dotColor: AppTheme.carouselGrey
                                )
                            ),
                          )
                      ),
                      Obx(()=>controller.buildCategories()),
                      Obx(()=>controller.buildCategoryProducts()),
                      Obx(()=>controller.buildTopBrands()),
                      const SizedBox(height: 28,),
                    ],
                  ),
                )
              ],


            ):
            PageErrorView((){}, NoInternetError()),
          ),
        )),
    );
  }

}

