
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zihazi_sampleproject/dashboard/model/categoryproductsuccessmodel.dart';

import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../../baseclasses/utils/multistate_button/multi_state_button_controller.dart';
import 'addtocartbutton.dart';

class CategoryProductItem extends StatefulWidget {
  final Products productItem;
  final bool isInStock;
  final bool isFavorite;
  final MultiStateButtonController multiStateButtonController;
  Function(String productId,bool isFavorite) onFavoriteClicked;
  final Function(String productId) onAddToCart;
  bool isClicked = false;

  CategoryProductItem({Key? key,
    required this.productItem,
    required this.multiStateButtonController,
    required this.onFavoriteClicked,
    required this.onAddToCart,
    required this.isInStock,
    required this.isFavorite
  }) : super(key: key);

  @override
  _CategoryProductItemState createState() => _CategoryProductItemState();
}

class _CategoryProductItemState extends State<CategoryProductItem> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    widget.isClicked = widget.isFavorite;
    return InkWell(
      onTap: (){
        Get.toNamed("/productdetail",arguments: [widget.productItem.prodId, widget.isInStock]);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 14.0,right: 14.0),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:120,width:Get.width/2,child: Image.network(widget.productItem.prodImage!,fit: BoxFit.fill,
                  errorBuilder: ( context, exception, stackTrace) {
                    return Center(child: SvgPicture.asset(ImageUtil.noImageIcon),);
                  },)),
                const SizedBox(height: 10,),
                SizedBox(
                  height: 40,
                  child: Text(widget.productItem.prodName!,overflow: TextOverflow.ellipsis,style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.blackTextColor,
                  ),
                    maxLines: 2,),
                ),
                const SizedBox(height: 10,),
                Text(widget.productItem.prodAmount!.isNotEmpty?
                "sar".tr+" "+double.parse(widget.productItem.prodAmount!).toStringAsFixed(2):"",style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.primaryColor,
                ),),
                const SizedBox(height: 10,),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 35,
                    width: double.infinity,
                    // child: ElevatedButton(
                    //   child: Text('add_to_cart'.tr,style: const TextStyle(
                    //     fontSize: 10,
                    //     color: AppTheme.white,
                    //   ),),
                    //   onPressed: () {
                    //     widget.onAddToCart(widget.productItem.prodId);
                    //   },
                    //
                    // ),
                    child: widget.isInStock ? AddToCartButton(multiStateButtonController: widget
                        .multiStateButtonController, onClicked : (){
                      widget.onAddToCart(widget.productItem.prodId);
                    }): ElevatedButton(
                      child: Text('out_of_stock'.tr,style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.textColor,
                      ),),
                      style: Style.disabledButton(),
                      onPressed: null,
                    ),

                    // ),
                  ),
                )
              ],
            ),
            Align(child: IconButton(
              onPressed: () {
                widget.isClicked = !widget.isClicked;
                widget.onFavoriteClicked(widget.productItem.prodId,widget.isClicked);
              }, icon: (widget.isFavorite) ? const Icon(Icons.favorite, color: AppTheme.primaryColor): const Icon(Icons.favorite_outline, color: AppTheme.headingTextColor),

            ),
              // FavoriteButton(
              //   valueChanged: (_isFavorite) {
              //     widget.onFavoriteClicked(widget.productItem.prodId,_isFavorite);
              //     print(widget.isInStock);
              //     print("IsFav: ${widget.isFavorite}");
              //   },
              //   iconColor: widget.isFavorite ? AppTheme.primaryColor : AppTheme.headingTextColor,
              //   iconSize: 40,
              //   iconDisabledColor: AppTheme.headingTextColor,
              //   isFavorite: widget.isFavorite,
              // ),
              alignment: Alignment.topRight,),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
