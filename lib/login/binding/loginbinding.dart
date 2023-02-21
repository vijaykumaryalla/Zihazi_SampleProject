import 'package:get/get.dart';

import '../../baseclasses/basebinding.dart';
import '../../baseclasses/sessions.dart';
import '../controller/logincontroller.dart';
import '../repo/loginrepo.dart';

class LoginBinding extends BaseBinding{
  @override
  void dependencies() {
    Get.lazyPut(()=>LoginRepo());
    // Get.put(LoginRepo());
    Get.put(StorageService());
    Get.put(LoginController());
    super.dependencies();
  }
}