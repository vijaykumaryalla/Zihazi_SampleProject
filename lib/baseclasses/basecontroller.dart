import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
EventBus eventBus = EventBus();
class BaseController extends GetxController{
  StreamSubscription? networkState;
  RxBool isConnected = true.obs;
  @override
  void onInit() async{
    try {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent
      ));
      networkState = Connectivity().onConnectivityChanged.listen((ConnectivityResult connectivityResult) {
        if (connectivityResult == ConnectivityResult.mobile) {
          print('Has Connection');
          isConnected.value =true;
        } else if (connectivityResult == ConnectivityResult.wifi) {
          print('Has Connection');
          isConnected.value =true;
        }
        else{
          print('No Connection');
          isConnected.value =false;
        }
      });
    } catch (e) {
      print(e);
    }
    super.onInit();
  }

  @override
  void onClose() {
    networkState?.cancel();
    super.onClose();
  }

  Future<bool> checkConnection() async {
    var connectivityResult= await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      print('Has Connection');
      return isConnected.value =true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print('Has Connection');
      return isConnected.value =true;
    }
    else{
      print('No Connection');
      return isConnected.value =false;
    }
  }
}