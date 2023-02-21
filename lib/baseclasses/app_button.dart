import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zihazi_sampleproject/baseclasses/theme.dart';

class AppButton extends StatelessWidget {

  final VoidCallback onTap;
  final Color buttonBgColor;
  final Color titleColor;
  final String buttonName;
  final String buttonImage;
  final double radius;
  final double width;
  final double height;

  const AppButton(this.buttonName,
      {Key? key,
        required this.onTap,
        this.buttonImage = '',
        this.buttonBgColor = AppTheme.primaryColor,
        this.radius = 5,
        this.width = double.maxFinite,
        this.height = 44,
        this.titleColor = AppTheme.white})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: TextButton(
          onPressed: onTap,

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (buttonImage.isNotEmpty)
                Image.asset(
                  buttonImage,
                  height: 12,
                  width: 12,
                ),
              const SizedBox(
                width: 3,
              ),
              Text(
                  buttonName,
                  style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: 14,
                      fontWeight:  FontWeight.w600
                  )),
            ],
          ),
          style: TextButton.styleFrom(
            backgroundColor:buttonBgColor,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ));
  }
}
