import 'package:get/get.dart';

import '../../baseclasses/basebinding.dart';
import '../../locale/localeservice.dart';
import '../controller/accountcontroller.dart';
import '../repo/accountrepo.dart';

class AccountBinding extends BaseBinding {
  @override
  void dependencies() {
    Get.put(AccountRepo());
    Get.put(LocaleService());
    Get.put(AccountController());
    super.dependencies();
  }
}