import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../service/networkerrors.dart';
import '../controller/wallet_page_controller.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();

}

class _WalletPageState extends State<WalletPage> {
  var controller = Get.find<WalletPageController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => (
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text("Wallet",style: Style.customTextStyle(Colors.black, 16.0,FontWeight.bold,FontStyle.normal),),
            leading: IconButton(
              onPressed: () {
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
            child:controller.isConnected.value? Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 200.0,
                  color: AppTheme.greyf0f0f0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("SAR 12344",style: Style.customTextStyle(Colors.black, 38.0, FontWeight.bold, FontStyle.normal),),
                      Text("Balance",style: Style.customTextStyle(AppTheme.subheadingTextColor, 14.0, FontWeight.bold, FontStyle.normal))
                    ],
                  ),
                ),
              Expanded(
                  child: Align(
                    alignment : Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: Style.elevatedNormalRedButton(),
                        onPressed: (){

                        },
                        child:Text("Add Gift Card",style: Style.normalTextStyle(Colors.white, 18.0),)
                      ),
                    ),
                  )
              )


              ],
            ):
            PageErrorView((){}, NoInternetError()),



          ),



        )

    )
    );
  }

}