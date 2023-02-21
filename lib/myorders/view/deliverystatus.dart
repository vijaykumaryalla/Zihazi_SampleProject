import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zihazi_sampleproject/myorders/model/order_details.dart';

import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';

class DeliveryStatus extends StatelessWidget {
  final int ticks;
  final Data orderDetail;
  const DeliveryStatus(this.ticks,this.orderDetail, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                tick1(),
                line1(),
                const SizedBox(height: 5,)
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("order_placed".tr, style: Style.normalTextStyle(AppTheme.blackTextColor, 14),),
                  Text("we_have_received_your_order".tr, style: Style.normalTextStyle(AppTheme.subheadingTextColor, 14),),
                ],
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                tick2(),
                line2(),
                const SizedBox(height: 5,)
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("confirmed".tr, style: Style.normalTextStyle(AppTheme.blackTextColor, 14),),
                  Text("your_order_has_been_confirmed".tr, style: Style.normalTextStyle(AppTheme.subheadingTextColor, 14),),
                ],
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                tick3(),
                line3(),
                const SizedBox(height: 5,)
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("order_shipped".tr, style: Style.normalTextStyle(AppTheme.blackTextColor, 14),),
                  Text("${"estimated_for".tr}  ${orderDetail.shippingDate}", style: Style.normalTextStyle(AppTheme.subheadingTextColor, 14),),
                ],
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                tick4(),
                line4(),
                const SizedBox(height: 5,)
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("out_for_delivery".tr, style: Style.normalTextStyle(AppTheme.blackTextColor, 14),),
                  Text("${"estimated_for".tr}  ${orderDetail.expectedDeliveryDate}", style: Style.normalTextStyle(AppTheme.subheadingTextColor, 14),),
                ],
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                tick5(),
                const SizedBox(height: 5)
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("delivered".tr, style: Style.normalTextStyle(AppTheme.blackTextColor, 14),),
                  Text("${"estimated_for".tr}  ${orderDetail.deliveryDate}", style: Style.normalTextStyle(AppTheme.subheadingTextColor, 14),),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget tick(bool isChecked){
    return isChecked?
    const Icon(
      Icons.circle,
      color: AppTheme.primaryColor,
      size: 12,
    ): const Icon(
        Icons.circle,
        color: AppTheme.dividerColor,
        size: 12
    );
  }

  Widget line(bool isChecked){
    return isChecked?
    Container(
      color: AppTheme.primaryColor,
      height: 50.0,
      width: 1.0,
    ): Container(
      color: AppTheme.dividerColor,
      height: 50.0,
      width: 1.0,
    );
  }

  Widget tick1() => ticks>0?tick(true):tick(false);
  Widget tick2() => ticks>1?tick(true):tick(false);
  Widget tick3() => ticks>2?tick(true):tick(false);
  Widget tick4() => ticks>3?tick(true):tick(false);
  Widget tick5() => ticks>4?tick(true):tick(false);

  Widget line1() => ticks>0?line(true):line(false);
  Widget line2() => ticks>1?line(true):line(false);
  Widget line3() => ticks>2?line(true):line(false);
  Widget line4() => ticks>3?line(true):line(false);
}
