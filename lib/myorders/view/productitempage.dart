import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../model/order_details.dart';

class ProductItemPage extends StatefulWidget {
  Products productList;
  ProductItemPage(this.productList, {Key? key}) : super(key: key);

  @override
  State<ProductItemPage> createState() => _ProductItemPageState();
}

class _ProductItemPageState extends State<ProductItemPage> {
  @override
  Widget build(BuildContext context) {
    var product = widget.productList;
    return InkWell(
      onTap: () {
        Get.toNamed("/productdetail",arguments: [product.productId, true]);
      },
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    width: 61,
                    height: 63,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: AppTheme.lightGrey),
                  ),
                  const SizedBox(
                      width: 49,
                      height: 49,
                      child: Icon(CupertinoIcons.bag)
                  )
                ],
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Style.titleTextStyle(AppTheme.blackTextColor, 14),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${"qty".tr} - ${product.qtyOrdered[0]}",
                            style: Style.normalTextStyle(AppTheme.secondaryTextColor, 13),
                          ),
                          const Spacer(),
                          Text(
                            "SAR ${product.price}",
                            style: Style.normalTextStyle(AppTheme.primaryColor, 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          const SizedBox(
            width: double.infinity,
            child: Divider(
              color: AppTheme.dividerColor,
            ),
          )
        ],
      ),
    );
  }
}