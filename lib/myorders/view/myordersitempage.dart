import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../model/my_orders.dart';

class MyOrdersItemPage extends StatefulWidget {
  Orders order;

  MyOrdersItemPage(this.order, {Key? key}) : super(key: key);

  @override
  _MyOrdersItemPageState createState() => _MyOrdersItemPageState();
}

class _MyOrdersItemPageState extends State<MyOrdersItemPage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    width: 36,
                    height: 39,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: AppTheme.lightGrey),
                  ),
                  SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(ImageUtil.cartIcon))
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 8),
                    child: Text(
                      "${"order_id".tr} ${widget.order.orderName}",
                      style: Style.titleTextStyle(AppTheme.blackTextColor, 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Text("${widget.order.deliveryDate} | ${widget.order.noOfItems} items",
                      style: Style.normalTextStyle(AppTheme.textColor, 12),
                    ),)
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  child: Text (
                      widget.order.status,
                      style: Style.normalTextStyle(Colors.white, 12)
                  ),
                  decoration: const BoxDecoration (
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      color: AppTheme.primaryColor
                  ),
                  padding: const EdgeInsets.fromLTRB(16.0, 4, 16.0, 4),
                ),
              ),
            ],
          )),
      const SizedBox(height: 10),
      const Divider(color: AppTheme.dividerColor)
    ]);
  }
}