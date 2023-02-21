import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../paymentmethod/binding/custombinding.dart';
import '../../paymentmethod/view/payment_method_page.dart';
import '../../service/networkerrors.dart';
import '../controller/checkout_info_controller.dart';
class CheckoutInfoPage extends StatefulWidget {

  @override
  _CheckoutInfoPageState createState() => _CheckoutInfoPageState();

}

class _CheckoutInfoPageState extends State<CheckoutInfoPage> {

  var controller=Get.find<CheckoutInfoController>();

  @override
  Widget build(BuildContext context) {
    controller.getUserAddressList();
    return Obx (() => (
     Scaffold (
       appBar: AppBar(
         backgroundColor: Colors.transparent,
         centerTitle: true,
         title: Text("checkout".tr,style: Style.customTextStyle(Colors.black, 16.0,FontWeight.bold,FontStyle.normal),),
         leading: IconButton(
           onPressed: () {
              Get.delete<CheckoutInfoController>();
              Get.back();
           },
           icon: const Icon(
             CupertinoIcons.arrow_left,
             color: AppTheme.black,
           ),
         ),
       ),
       backgroundColor: AppTheme.white,
       body: SafeArea(
         child:controller.isConnected.value? Stack(
             children: [
               SingleChildScrollView(
                 child: Padding(
                   padding: const EdgeInsets.all(10.0),
                   child: Column(
                     children: [
                       controller.buildUserAddressList(),
                       const SizedBox(height: 10.0,),
                       const Divider(color: Colors.black),
                       const SizedBox(height: 10.0,),
                       controller.productListView(),
                       const SizedBox(height: 10.0,),
                       const Divider(color: Colors.black),
                       const SizedBox(height: 10.0,),
                       controller.priceInfoView()
                     ],
                   ),
                 ),
               ),
               Align(
                   alignment: Alignment.bottomCenter,
                   child: Container(
                     padding: const EdgeInsets.all(10),
                     child: Obx(() => SizedBox(
                       width: double.infinity,
                       height: 50,
                       child: ElevatedButton(
                         style: ElevatedButton.styleFrom(
                           elevation: 2,
                           onSurface: Colors.grey,
                           onPrimary: AppTheme.primaryColor,
                             shape: const RoundedRectangleBorder(
                                 borderRadius: BorderRadius.all(Radius.circular(6))
                             )
                         ),
                         // elevation: 2,
                         // disabledColor: Colors.grey,
                         // color: AppTheme.primaryColor,
                         // shape: const RoundedRectangleBorder(
                         //     borderRadius: BorderRadius.all(Radius.circular(6))
                         // )
                          onPressed: controller.enableContinueButton.value ? () {
                           Get.to(const PaymentMethodPage(),binding:CustomBinding());
                       }: null,
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
                               "sar".tr+" "+controller.totalAmount.toStringAsFixed(2),
                               style: Style.titleTextStyle(Colors.white, 15),
                             ),
                             const SizedBox(width: 15,),
                           ],
                         ),
                       ),
                     )
                     ),
                   )
               ),
             ],
         ):
         PageErrorView((){}, NoInternetError()),
       ),


     )
    )
    );
  }

}