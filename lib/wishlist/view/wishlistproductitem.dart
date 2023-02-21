
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../../baseclasses/utils/multistate_button/multi_state_button_controller.dart';
import '../../dashboard/view/addtocartbutton.dart';
import '../../dashboard/view/favoritebutton.dart';
import '../model/wishlistmodel.dart';

class WishlistProductItem extends StatefulWidget {
  final CartData productItem;
  final MultiStateButtonController multiStateButtonController;
  final Function(String productId,bool isFavorite) onFavoriteClicked;
  final Function(String productId) onAddToCart;

  const WishlistProductItem({Key? key,
    required this.productItem,
    required this.multiStateButtonController,
    required this.onFavoriteClicked,
    required this.onAddToCart
  }) : super(key: key);

  @override
  _CategoryProductItemState createState() => _CategoryProductItemState();
}

class _CategoryProductItemState extends State<WishlistProductItem> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 10.0, bottom: 10),
      child:
      Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.network(
                  widget.productItem.image, fit: BoxFit.cover,
                  errorBuilder: (context, exception, stackTrace) {
                    return Center(
                      child: SvgPicture.asset(ImageUtil.noImageIcon),);
                  },),
              ),
              const SizedBox(height: 10,),
              Text(widget.productItem.name, overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.blackTextColor,
                ),
                maxLines: 2,),
              const SizedBox(height: 10,),
              Text(widget.productItem.price.isNotEmpty ?
              "sar".tr+" "+double.parse(widget.productItem.price).toStringAsFixed(2) : "",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.primaryColor,
                ),),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: (){

                  },
                  child: SizedBox(
                    height: 35,
                    width: double.infinity,
                    // child: ElevatedButton(
                    //   child: const Text('Add to Cart',style: TextStyle(
                    //     fontSize: 10,
                    //     color: AppTheme.white,
                    //   ),),
                    //   onPressed: () {},
                    //
                    // ),
                    child: widget.productItem.isInStock ? AddToCartButton(multiStateButtonController: widget
                        .multiStateButtonController, onClicked : (){
                      widget.onAddToCart(widget.productItem.productId);
                    }): ElevatedButton(
                      child: Text('out_of_stock'.tr,style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.textColor,
                      ),),
                      style: Style.disabledButton(),
                      onPressed: null,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(child:
          FavoriteButton(
            valueChanged: (_isFavorite) {
              _isFavorite=true;
              widget.onFavoriteClicked(widget.productItem.productId, true);
            },
            iconColor: AppTheme.primaryColor,
            iconSize: 40,
            changeState: false,
            iconDisabledColor: AppTheme.headingTextColor,
            isFavorite: true,
          ),
            alignment: Alignment.topRight,),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}