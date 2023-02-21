import 'package:flutter/material.dart';

import 'ball_rotate_chase.dart';
import 'ball_spin_fade_loader.dart';
import 'decorate.dart';
import 'line_scale_plus_out_rapid.dart';

enum Indicator {
  lineScalePulseOutRapid,
  ballSpinFadeLoader,
  ballRotateChase,
}

/// Entrance of the loading.
class LoadingIndicator extends StatelessWidget {
  /// Indicate which type.
  final Indicator indicatorType;

  /// The color you draw on the shape.
  final List<Color>? colors;
  final Color? backgroundColor;

  /// The stroke width of line.
  final double? strokeWidth;

  /// Applicable to which has cut edge of the shape
  final Color? pathBackgroundColor;

  const LoadingIndicator({
    Key? key,
    required this.indicatorType,
    this.colors,
    this.backgroundColor,
    this.strokeWidth,
    this.pathBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> safeColors = colors == null || colors!.isEmpty
        ? [Theme.of(context).primaryColor]
        : colors!;
    return DecorateContext(
      decorateData: DecorateData(
        indicator: indicatorType,
        colors: safeColors,
        strokeWidth: strokeWidth,
        pathBackgroundColor: pathBackgroundColor,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          color: backgroundColor,
          child: _buildIndicator(),
        ),
      ),
    );
  }

  /// return the animation indicator.
  _buildIndicator() {
    switch (indicatorType) {
      case Indicator.lineScalePulseOutRapid:
        return const LineScalePulseOutRapid();
      case Indicator.ballSpinFadeLoader:
        return const BallSpinFadeLoader();
      case Indicator.ballRotateChase:
        return const BallRotateChase();
      default:
        throw Exception("no related indicator type:$indicatorType");
    }
  }
}