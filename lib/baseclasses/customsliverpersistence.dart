import 'package:flutter/material.dart';

class CustomPersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;
  final Color backgroundColor;

  CustomPersistentHeader({required this.widget,required this.backgroundColor });


  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: backgroundColor,
        child: widget
    );
  }

  @override
  double get maxExtent => 80.0;

  @override
  double get minExtent => 80.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}