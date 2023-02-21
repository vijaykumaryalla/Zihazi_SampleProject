import 'dart:ui';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

import '../baseclasses/sessions.dart';
import 'ar_sa.dart';
import 'en_us.dart';

class LocaleService extends Translations {

  static Locale get locale => getAppLocale();
  static const fallbackLocale =  Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'ar_SA': arSA,
  };

  static final locales = [
    const Locale('en', 'US'),
    const Locale('ar', 'SA'),
  ];

  static final langs = [
    'English',
    'عربي',
  ];

  void changeLocale(String lang) {
    final locale = _getLocaleFromLanguage(lang);
    Get.updateLocale(locale);
  }

  Locale _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale??const Locale('ar', 'SA');
  }

  static getAppLocale() {
    var storageService = Get.find<StorageService>();
    return storageService.getLocale();
  }
}