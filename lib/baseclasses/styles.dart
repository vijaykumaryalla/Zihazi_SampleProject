import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zihazi_sampleproject/baseclasses/theme.dart';

class Style {
  static TextStyle headingTextStyle() => const TextStyle(
      color: AppTheme.headingTextColor,
      fontSize: 27,
      fontFamily: 'opensans',
      fontWeight: FontWeight.w700);

  static TextStyle subheadingTextStyle(double fontSize) => const TextStyle(
      color: AppTheme.subheadingTextColor,
      fontSize: 16,
      fontFamily: 'opensans',
      fontWeight: FontWeight.w400);

  static TextStyle normalTextStyle(Color color, double fontSize) => TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      fontFamily: 'opensans'
  );

  static TextStyle titleTextStyle(Color color, double fontSize) => TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: 'opensans',
      fontWeight: FontWeight.w700
  );

  static TextStyle customTextStyle(Color color, double fontSize,FontWeight fontWeight,FontStyle fontStyle) => TextStyle(
      color: color,
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontFamily: 'opensans',
      fontWeight: fontWeight
  );

  static ButtonStyle primaryButtonStyle() => ElevatedButton.styleFrom(
    onSurface: Colors.grey,
    primary: AppTheme.primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32.0),
    ),
  );

  static ButtonStyle secondaryButton() => OutlinedButton.styleFrom(
      onSurface: Colors.white,
      primary: Colors.white,
      elevation: 0,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      )
  );

  static ButtonStyle rectangularRedButton() => ElevatedButton.styleFrom(
    onSurface: Colors.grey,
    primary: AppTheme.primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6.0),
    ),
  );

  static ButtonStyle elevatedRedRoundButton() => ElevatedButton.styleFrom(
    primary: AppTheme.primaryColor,
    onPrimary: AppTheme.white,
    minimumSize: Size(double.infinity, 50.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32.0),
    ),
  );

  static ButtonStyle elevatedNormalRedButton() => ElevatedButton.styleFrom(
    primary: AppTheme.primaryColor,
    onPrimary: AppTheme.white,
    minimumSize: Size(double.infinity, 50.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
  );

  static ButtonStyle disabledButton() => ElevatedButton.styleFrom(
    primary: AppTheme.dividerColor,
    onPrimary: AppTheme.textColor,
    minimumSize: Size(double.infinity, 50.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
  );

  static ButtonStyle elevatedNormalCustomButton(Color color) => ElevatedButton.styleFrom(
    primary: color,
    onPrimary: color,
    minimumSize: Size(double.infinity, 50.0),
    splashFactory: NoSplash.splashFactory,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
  );

  static ButtonStyle elevatedNormalBlackButton() => ElevatedButton.styleFrom(
    primary: AppTheme.black,
    onPrimary: AppTheme.black,
    minimumSize: Size(double.infinity, 50.0),
    splashFactory: NoSplash.splashFactory,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
  );

  static InputDecoration roundedTextFieldStyle(
      String label,
      String hint,
      String icon) =>
      InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          labelText: label,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              icon: SvgPicture.asset(icon, height: 16, width: 16),
              onPressed: null,
            ),
          ),
          hintText: hint,
          errorMaxLines: 3,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.0),
            borderSide: const BorderSide(
              color: AppTheme.headingTextColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.0),
            borderSide: const BorderSide(
              color: AppTheme.headingTextColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.0),
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.0),
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
            ),
          )
      );

  static InputDecoration textFieldWithoutIconStyle(
      String hint) =>
      InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
          hintText: hint,
          labelText: hint,
          hintStyle: const TextStyle(
              color: AppTheme.subheadingTextColor
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.0),
            borderSide: const BorderSide(
              color: AppTheme.headingTextColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.0),
            borderSide: const BorderSide(
              color: AppTheme.headingTextColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.0),
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.0),
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
            ),
          )
      );

  static InputDecoration searchTextFieldStyle(
      String label,
      String icon,
      Function(bool) onSuffixClicked) =>
      InputDecoration(
          contentPadding: icon!=""?const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0):
          const EdgeInsets.fromLTRB(20, 10, 20, 10),
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          prefixIcon:icon!=""? IconButton(
            icon: SvgPicture.asset(icon, height: 16, width: 16),
            onPressed: null,
          ):null,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear), onPressed: () {onSuffixClicked(true);  },),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.0),
            borderSide: const BorderSide(
              color: AppTheme.headingTextColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.0),
            borderSide: const BorderSide(
              color: AppTheme.headingTextColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.0),
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.0),
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
            ),
          )
      );



  static InputDecoration normalTextFieldStyle(
      String label,
      String hint) =>
      InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          labelText: label,

          hintText: hint,
          errorMaxLines: 3,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: AppTheme.headingTextColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: AppTheme.headingTextColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
            ),
          )
      );
}
