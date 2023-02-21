import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controller/account_settings_controller.dart';
import '../repo/account_settings_repo.dart';

class AccountSettingBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AccountSettingRepo());
    Get.put(AccountSettingController());
  }

}