import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../baseclasses/basebinding.dart';
import '../controller/wallet_page_controller.dart';

class WalletPageBinding extends BaseBinding {

  @override
  void dependencies() {
    Get.put(WalletPageController());
    super.dependencies();
  }
}