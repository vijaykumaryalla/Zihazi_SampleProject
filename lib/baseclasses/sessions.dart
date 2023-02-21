import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zihazi_sampleproject/baseclasses/utils/constants.dart';

class StorageService extends GetxService {


  Future<StorageService> init() async {
    await GetStorage.init();
    return this;
  }

  Future<void> write(String key, dynamic value) async{
    await GetStorage().write(key, value);
  }

  Future<dynamic> read(String key) async {
    String? userId = GetStorage().read(key);
    return userId;
  }

  Future<Map<String,String>> getDefaultHeaders()async{
    final headerMap = <String,String>{};
    headerMap.putIfAbsent("content-type", () =>"application/json");
    headerMap.putIfAbsent("Token", () =>  GetStorage().read(Constants.apiToken));
    headerMap.putIfAbsent("UserId", () => GetStorage().read(Constants.userId));
    headerMap.putIfAbsent("lang", () => GetStorage().read(Constants.appLanguage));
    return headerMap;
  }

  Map<String,String> getHeader() {
    final headerMap = <String,String>{};
    headerMap.putIfAbsent("content-type", () =>"application/json");
    headerMap.putIfAbsent("lang", () => getAppLanguage());
    return headerMap;
  }

  Future<bool> checkLogin() async {
    String? userId = GetStorage().read(Constants.userId);
    if(userId != null) {
      if(userId.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  Future<String> getUserEmail() async {
    String? email = GetStorage().read(Constants.userEmail);
    if(email != null) {
      if(email.isNotEmpty) {
        return email;
      }
    }
    return "";
  }

  Future<bool> logout() async {
    try {
      GetStorage().remove(Constants.apiToken);
      GetStorage().remove(Constants.userId);
      GetStorage().remove(Constants.userName);
      GetStorage().remove(Constants.userEmail);
    } catch(e) {
      return false;
    }
    return true;
  }

  String getAppLanguage() {
    String? locale = GetStorage().read(Constants.appLanguage);
    if(locale != null && locale.isNotEmpty) {
      if(locale == Constants.arabic) {
        return "2";
      } else if(locale == Constants.english) {
        return "1";
      }
    }
    return "2";
  }

  Locale getLocale() {
    String? locale = GetStorage().read(Constants.appLanguage);
    if(locale != null && locale.isNotEmpty) {
      if(locale == Constants.arabic) {
        return const Locale('ar', 'SA');
      } else if(locale == Constants.english) {
        return const Locale('en', 'US');
      }
    }
    return const Locale('ar', 'SA');
  }
}