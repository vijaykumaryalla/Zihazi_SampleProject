import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/scrolling_indicator/scrolling_indicator.dart';
import '../../baseclasses/utils/scrolling_indicator/scrolling_indicator_effect.dart';
import '../model/product_detail_model.dart';

class ProductSlider extends StatefulWidget {
  final List<ProductImageUrl> items;
  var currentItem= 0.obs;


  ProductSlider({required this.items});

  @override
  _ProductSliderState createState() =>
      _ProductSliderState();
}

class _ProductSliderState extends State<ProductSlider> {
  int activeIndex = 0;

  setActiveDot(index) {
    setState(() {
      activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        // overflow: Overflow.visible,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 290,
            child: CarouselSlider(
              options: CarouselOptions(
                  enableInfiniteScroll: false,
                  aspectRatio: 1.0,
                  viewportFraction: 1,
                  initialPage: 0,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    widget.currentItem.value = index;
                  }

              ),
              items: widget.items.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image(
                            image: NetworkImage(item.url),
                            fit: BoxFit.fitHeight,
                          ),
                        ),

                      ],
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Obx(()=>
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedSmoothIndicator(
                    activeIndex: widget.currentItem.value,
                    count:  widget.items.length,
                    effect: const ScrollingDotsEffect(
                        activeStrokeWidth: 1.2,
                        activeDotScale: 1.2,
                        maxVisibleDots: 5,
                        radius: 6,
                        spacing: 10,
                        dotHeight: 6,
                        dotWidth: 6,
                        activeDotColor: AppTheme.primaryColor,
                        dotColor: AppTheme.carouselGrey
                    )
                ),
              )
          ),
        ],
      ),
    );
  }
}