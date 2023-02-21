import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../styles.dart';
import '../theme.dart';

class SearchBar extends StatefulWidget {
  final bool isSearching;
  final String headingText;
  final Function(String text) onSubmitted;
  const SearchBar(
      {Key? key, required this.isSearching, required this.headingText,required this.onSubmitted})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}


class _SearchBarState extends State<SearchBar>{
  late TextEditingController searchController;

  @override
  void didUpdateWidget(covariant SearchBar oldWidget) {
    if(!widget.isSearching){
      searchController.clear();
    }
    super.didUpdateWidget(oldWidget);
  }
  @override
  void initState() {
    searchController=TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimateExpansion(
          animate: !widget.isSearching,
          axisAlignment: 1.0,
          child:  Text(widget.headingText,
            style: Style.titleTextStyle(AppTheme.headingTextColor, 18),),
        ),
        AnimateExpansion(
          animate: widget.isSearching,
          axisAlignment: -1.0,
          child: SizedBox(
            height: 40,
            child:
            TextFormField(
              controller: searchController,
              autofocus: false,
              onChanged: (value){
                widget.onSubmitted(value);
              },
              decoration: Style.searchTextFieldStyle("search_for_items".tr,"",(bool){
                searchController.clear();
              }),
            ),
          ),
        ),
      ],
    );
  }

}


class AnimateExpansion extends StatefulWidget {
  final Widget child;
  final bool animate;
  final double axisAlignment;
  const AnimateExpansion({
    Key? key,
    this.animate = false,
    required this.axisAlignment,
    required this.child,
  }): super(key: key);

  @override
  _AnimateExpansionState createState() => _AnimateExpansionState();
}

class _AnimateExpansionState extends State<AnimateExpansion>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  void prepareAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInCubic,
      reverseCurve: Curves.easeOutCubic,
    );
  }

  void _toggle() {
    if (widget.animate) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _toggle();
  }

  @override
  void didUpdateWidget(AnimateExpansion oldWidget) {
    super.didUpdateWidget(oldWidget);
    _toggle();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axis: Axis.horizontal,
        axisAlignment: -1.0,
        sizeFactor: _animation,
        child: widget.child);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}