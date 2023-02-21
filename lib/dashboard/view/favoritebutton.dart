import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../baseclasses/sessions.dart';
import '../../baseclasses/theme.dart';

class FavoriteButton extends StatefulWidget {
  FavoriteButton({
    double? iconSize,
    Color? iconColor,
    Color? iconDisabledColor,
    bool? isFavorite,
    bool? changeState,
    required Function valueChanged,
    Key? key,
  })  : _iconSize = iconSize ?? 25.0,
        _iconColor = iconColor ?? Colors.red,
        _iconDisabledColor = iconDisabledColor ?? Colors.grey[400],
        _isFavorite = isFavorite ?? false,
        _valueChanged = valueChanged,
        _changeState = changeState ?? true,
        super(key: key);

  final double _iconSize;
  final Color _iconColor;
  final bool _isFavorite;
  final Function _valueChanged;
  final Color? _iconDisabledColor;
  final bool _changeState;

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;

  late CurvedAnimation _curve;

  double _maxIconSize = 0.0;
  double _minIconSize = 0.0;

  final int _animationTime = 400;

  bool _isFavorite = false;
  bool _isAnimationCompleted = false;


  @override
  void initState() {
    super.initState();

    _isFavorite = widget._isFavorite;
    _maxIconSize = (widget._iconSize < 20.0)
        ? 20.0
        : (widget._iconSize > 100.0)
        ? 100.0
        : widget._iconSize;
    final double _sizeDifference = _maxIconSize * 0.30;
    _minIconSize = _maxIconSize - _sizeDifference;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _animationTime),
    );

    _curve = CurvedAnimation(curve: Curves.slowMiddle, parent: _controller);
    Animation<Color?> _selectedColorAnimation = ColorTween(
      begin: widget._iconColor,
      end: widget._iconDisabledColor,
    ).animate(_curve);

    Animation<Color?> _deSelectedColorAnimation = ColorTween(
      begin: widget._iconDisabledColor,
      end: widget._iconColor,
    ).animate(_curve);

    _colorAnimation = (_isFavorite == true)
        ? _selectedColorAnimation
        : _deSelectedColorAnimation;
    _sizeAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: _minIconSize,
            end: _maxIconSize,
          ),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: _maxIconSize,
            end: _minIconSize,
          ),
          weight: 50,
        ),
      ],
    ).animate(_curve);

    if(widget._changeState){
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _isAnimationCompleted = true;
          _isFavorite = !_isFavorite;
          widget._valueChanged(_isFavorite);
        } else if (status == AnimationStatus.dismissed) {
          _isAnimationCompleted = false;
          _isFavorite = !_isFavorite;
          widget._valueChanged(_isFavorite);
        }
      });
    }else{
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _isAnimationCompleted = true;
          _isFavorite = true;
          widget._valueChanged(true);
        } else if (status == AnimationStatus.dismissed) {
          _isAnimationCompleted = false;
          _isFavorite = true;
          widget._valueChanged(true);
        }
      });
    }
    // _controller.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     _isAnimationCompleted = true;
    //     _isFavorite = !_isFavorite;
    //     widget._valueChanged(_isFavorite);
    //   } else if (status == AnimationStatus.dismissed) {
    //     _isAnimationCompleted = false;
    //     _isFavorite = !_isFavorite;
    //     widget._valueChanged(_isFavorite);
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        return InkResponse(
          onTap: () {
            setState(() async{
              bool isLoggedIn = await Get.find<StorageService>().checkLogin();
              if(isLoggedIn) {
                if (_isAnimationCompleted == true) {
                  _controller.reverse();
                } else {
                  _controller.forward();
                }
              }else{
                widget._valueChanged(_isFavorite);
              }
            });
          },
          child: _isFavorite?Icon(
            (Icons.favorite),
            // color: _colorAnimation.value,
            color: AppTheme.primaryColor,
            size: _sizeAnimation.value,
          ):Icon(
            (Icons.favorite_outline),
            // color: _colorAnimation.value,
            color: AppTheme.headingTextColor,
            size: _sizeAnimation.value,
          ),
        );
      },
    );
  }
}