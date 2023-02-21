import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zihazi_sampleproject/cart/model/cart.dart';

import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../controller/cartcontroller.dart';

class CartItem extends StatefulWidget {
  CartData cartItem;

  CartItem(this.cartItem, {Key? key}) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  var controller = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed("/productdetail",arguments: [widget.cartItem.productId, true]);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
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
                    SizedBox(
                        width: 49,
                        height: 49,
                        child: Image.network(widget.cartItem.image)
                    )
                  ],
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      widget.cartItem.name,
                      style: Style.titleTextStyle(AppTheme.blackTextColor, 14),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 35
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                        backgroundColor: Colors.white,
                      ),

                      // focusColor: AppTheme.primaryColor,
                      // highlightColor: Colors.red[50],
                      // highlightedBorderColor: AppTheme.primaryColor,

                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                width: 20,
                                height: 16,
                                child: SvgPicture.asset(ImageUtil.deleteIcon)
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "remove".tr,
                              style: Style.titleTextStyle(AppTheme.primaryColor, 14),
                            )
                          ],
                        ),
                      ),
                      onPressed: (){
                        controller.removeItem(widget.cartItem.productId);
                      },
                    )
                ),
                const SizedBox(width: 20),
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                      color: AppTheme.headingTextColor,
                      borderRadius: BorderRadius.all(Radius.circular(6.0))),
                  child: InkWell(
                    onTap: () {
                      controller.updateCart(widget.cartItem.productId, widget.cartItem.qty+1);
                    },
                    child: const Icon(
                      CupertinoIcons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Text(widget.cartItem.qty.toString(), style: Style.titleTextStyle(AppTheme.headingTextColor, 15),),
                const SizedBox(width: 15),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: _getButtonColor(),
                      borderRadius: const BorderRadius.all(Radius.circular(6.0))),
                  child: InkWell(
                    onTap: () {
                      (widget.cartItem.qty == 1)? null :
                      controller.updateCart(widget.cartItem.productId, widget.cartItem.qty-1);
                    },
                    child: const Icon(
                      CupertinoIcons.minus,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Flexible(child: Text("sar".tr+" "+"${widget.cartItem.subtotal}", style: Style.titleTextStyle(AppTheme.primaryColor, 14))),
              ],
            ),
            const SizedBox(height: 15),
            const SizedBox(
              width: double.infinity,
              child: Divider(
                color: AppTheme.dividerColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Color _getButtonColor() {
    if(widget.cartItem.qty == 1) {
      return AppTheme.carouselGrey;
    }
    return AppTheme.headingTextColor;
  }
}
