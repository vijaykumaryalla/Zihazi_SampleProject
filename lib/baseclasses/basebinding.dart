import 'package:get/get.dart';

import 'basecontroller.dart';

class BaseBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<BaseController>(() => BaseController());
  }

}