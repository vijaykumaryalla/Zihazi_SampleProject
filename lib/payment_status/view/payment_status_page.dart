import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../baseclasses/basecontroller.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/imageutils.dart';

class PaymentStatusPage extends StatefulWidget {

  final status;
  final orderId;
  const PaymentStatusPage({Key? key,required this.status, required this.orderId}) : super(key: key);

  @override
  _PaymentStatusPageState createState() => _PaymentStatusPageState();
}

class _PaymentStatusPageState extends State<PaymentStatusPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.close(3);
        eventBus.fire(Constants.paymentCompleted);
        return true;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(child: Image(image: AssetImage(widget.status==1?ImageUtil.paymentSuccessIcon:ImageUtil.paymentFailureIcon)), height: 100,),
              const SizedBox(height: 15,),
              Text(widget.status==1?"order_placed_successfully".tr:"order_failure".tr,
                style:widget.status==1? Style.titleTextStyle(AppTheme.paymentTextGreen, 20):Style.titleTextStyle(AppTheme.primaryColor, 20),),
              const SizedBox(height: 15,),
              widget.status==1?Text("${"order_id".tr} ${widget.orderId.toString()}",
                style:Style.titleTextStyle(AppTheme.paymentTextGreen, 20),):Container(),
              widget.status==1?const SizedBox(height: 15,):Container(),
              Text(widget.status==1?"thank_you".tr:"payment_try_again".tr,
              style: widget.status==1?Style.titleTextStyle(AppTheme.paymentTextGreen, 15):Style.titleTextStyle(AppTheme.primaryColor, 15),),
            ],
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.close(3);
              eventBus.fire(Constants.paymentCompleted);
            },
            icon: const Icon(
              CupertinoIcons.clear,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
