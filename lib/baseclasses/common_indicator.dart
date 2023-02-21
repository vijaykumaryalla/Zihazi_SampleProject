import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zihazi_sampleproject/baseclasses/theme.dart';

enum IndicatorType {
  Circle,
  CubeGrid,
  Wave,
  FoldingCube
}

class CommonIndicator extends StatefulWidget {
  final indicatorType;
   const CommonIndicator({Key? key,
   required this.indicatorType}) : super(key: key);

  @override
  State<CommonIndicator> createState() => _CommonIndicatorState();
}

class _CommonIndicatorState extends State<CommonIndicator> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _buildIndicator();
  }

  _buildIndicator() {
    switch (widget.indicatorType) {
      case IndicatorType.Circle:
        return  const SpinKitCircle(
          color: AppTheme.primaryColor,
          size: 50.0,
        );
      case IndicatorType.CubeGrid	:
        return SpinKitCubeGrid	(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? AppTheme.primaryColor : AppTheme.primaryColor,
              ),
            );
          },
        );
      case IndicatorType.Wave:
        return const SpinKitWave(
          type: SpinKitWaveType.start,
          color: AppTheme.primaryColor,
          size: 30.0,
          duration: Duration(milliseconds: 1000),
        );
      case IndicatorType.FoldingCube:
        return const SpinKitFoldingCube(
          color: AppTheme.primaryColor,
          size: 50.0,
        );
      default:
        throw Exception("no related indicator type:${widget.indicatorType}");
    }
  }
}
