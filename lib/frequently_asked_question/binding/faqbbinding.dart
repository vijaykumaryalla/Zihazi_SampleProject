import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../baseclasses/basebinding.dart';
import '../controller/faqcontroller.dart';
import '../repo/faqrepo.dart';
class FaqBinding extends BaseBinding{

  @override
  void dependencies() {
    Get.put(FaqReppo());
    Get.put(FaqController());
    super.dependencies();
  }
}