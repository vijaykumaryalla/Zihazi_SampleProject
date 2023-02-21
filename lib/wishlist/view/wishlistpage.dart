import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../../service/networkerrors.dart';
import '../controller/wishlistcontroller.dart';

class WishListPage extends StatefulWidget{
  @override
  _WishListPageState createState() => _WishListPageState();


}

class _WishListPageState extends State<WishListPage>{
  var controller=Get.find<WishListController>();


  // var controller=Get.find<DashboardController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => (
        Scaffold(
          backgroundColor: AppTheme.white,
          body: SafeArea(
            child:controller.isConnected.value? Container(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.direction > 0) {
                    controller.getWishlistItems();
                  }
                },
                child: Column(
                  children: [
                    Visibility(
                      visible: controller.isOpenSearchBox.value==true,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 14,right: 14,top: 25,bottom: 14),
                        child:  Row(
                            children:[

                              Expanded(
                                child: TextFormField(
                                  autofocus: false,
                                  controller: controller.searchController,
                                  onChanged: (value){
                                    controller.onSearchWishlist(value);
                                  },
                                  onEditingComplete: (){
                                    FocusScope.of(context).unfocus();
                                  },
                                  decoration: Style.searchTextFieldStyle(
                                      "search_for_items".tr,
                                      ImageUtil.searchIcon, (bool){

                                  }),
                                ),
                              ),
                              const SizedBox(width: 5.0,height: 0.0,),
                              Align(alignment: Alignment.centerRight,child:InkWell(child:SvgPicture.asset(ImageUtil.closeIconCross) ,onTap:(){
                                controller.isOpenSearchBox.value=false;
                                controller.searchController.text="";
                                controller.onSearchWishlist("");
                              },
                              ),)

                            ]

                        ),
                      ),
                    ),
                    Visibility(
                        visible: controller.isOpenSearchBox.value==false,
                        child:
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text('my_wishlist'.tr,style: Style.titleTextStyle(Colors.black, 20),),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(onPressed: (){
                                        controller.isOpenSearchBox.value=true;
                                      }, icon: SvgPicture.asset(ImageUtil.searchIcon,height: 18,width: 18,)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                    ),
                    const SizedBox(height: 10.0,),
                    Obx(()=>  controller.buildWishlistItems()),
                    Obx(() => controller.handleRemoveWishlistAPI())
                  ],
                ),
              ),
            ):
            PageErrorView((){}, NoInternetError()),



          ),



        )

    )
    );
  }
}
