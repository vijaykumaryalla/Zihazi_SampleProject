import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';

class AppTheme{

  static final light = ThemeData.light().copyWith(
      backgroundColor: Colors.white,
      colorScheme: lightColorScheme,
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: HexColor("#ce171f"),
        minimumSize: const Size(88, 36),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            shape:  RoundedRectangleBorder(
              borderRadius:  BorderRadius.circular(6.0),
            ),
          )),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          actionsIconTheme: IconThemeData(color: Colors.grey),
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent
          ),
          centerTitle: false,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.black))
  );
  static final dark = ThemeData.dark().copyWith(
      backgroundColor: Colors.black,
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: HexColor("#ce171f"),
        minimumSize: const Size(88, 36),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            shape:  RoundedRectangleBorder(
              borderRadius:  BorderRadius.circular(6.0),
            ),
          )),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.red),
          actionsIconTheme: IconThemeData(color: Colors.grey),
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent
          ),
          centerTitle: false,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.black))
  );
  final _box = GetStorage();
  final _key = 'isDarkMode';
  final _keymode = 'ThemeMode';
  ThemeMode get theme {
    if(_box.read(_keymode)=='System'){
      return ThemeMode.light;
    }
    else if(_box.read(_keymode)=='Dark'){
      return ThemeMode.light;
    }
    else{
      return ThemeMode.light;
    }
  }
  bool _loadThemeFromBox() => _box.read(_key) ?? false;
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);
  void switchTheme() {
    Get.changeTheme(_loadThemeFromBox() ?light : dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
  Brightness currentTheme(){
    return _loadThemeFromBox() ? Brightness.dark : Brightness.light;
  }

  void setThemeMode(String mode){
    //   _box.write(_keymode,mode);
    if(mode=='System'){
      Get.changeThemeMode(ThemeMode.system);
    }
    else if(mode=='Dark'){
      Get.changeThemeMode(ThemeMode.dark);
    }
    else{
      Get.changeThemeMode(ThemeMode.light);
    }
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: primaryColor,
    primaryVariant: Color(0xFF640AFF),
    secondary: Color(0xFF03DAC5),
    secondaryVariant: Color(0xFF0AE1C5),
    background: Color(0xFFE6EBEB),
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static const Color black = Color(0xff000000);
  static const Color white = Color(0xffffffff);
  static const Color boxgrey = Color(0xfff5f5f5);
  static const Color headingTextColor = Color(0xff252e3c);
  static const Color subheadingTextColor = Color(0xff77838f);
  static const Color blackTextColor = Color(0xff1e2022);
  static const Color primaryColor = Color(0xffce171f);
  // static const Color primaryColor = Color(0xff23a0a0);
  static const Color dividerColor = Color(0xff77838f);
  static const Color textColor = Color(0xff444648);
  static const Color imageBackgroundColor = Color(0xfff9f9f9);
  static const Color greyf0f0f0 = Color(0xffe7e7e7);
  static const Color redce171f = Color(0xffc71b22);
  static const Color orangeDD780CFF = Color(0xFFDD780C);
  static const Color grey5B5E60FF = Color(0xFF454749);
  static const Color starColor = Color(0xffe67b00);
  static const Color lightGrey = Color(0xfff0f0f0);
  static const Color greenButtonColor = Color(0xff23a0a0);
  static const Color inputFillColor = Color(0xfff2f2f2);
  static const Color secondaryTextColor = Color(0xff888888);
  static const Color carouselGrey = Color(0xffe3e3e3);
  static const Color orange = Color(0xffe85432);
  static const Color bottomStripGrey = Color(0xfff0f0f0);
  static const Color paymentTextGreen = Color(0xff11a12e);

  static const Color greyf9f9f9 = Color(0xf9f9f9);

  static const Color buttongreen = Color.fromARGB(255, 209, 215, 49);
  static const Color dashpurple = Color.fromARGB(255, 137,119,233);
  static const Color dashpink = Color.fromARGB(255, 224,105,171);
  static const Color dashyellow = Color.fromARGB(255, 238,186,85);
  static const Color dashseagreen = Color.fromARGB(255, 92,203,201);
  static const Color dashgreen = Color.fromARGB(255, 69,196,86);
  static const Color dashblue = Color.fromARGB(255, 209, 215, 49);

  AppTheme(){
    _box.writeIfNull(_keymode, 'System');
  }
}