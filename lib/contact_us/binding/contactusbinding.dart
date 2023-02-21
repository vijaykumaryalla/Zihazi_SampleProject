import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../baseclasses/basebinding.dart';
import '../controller/contactuscontroller.dart';
import '../repo/contactusrepo.dart';
class ContactUsBinding extends BaseBinding{
  @override
  void dependencies() {
    Get.put(ContactUsRepo());
    Get.put(ContactUsController());
    super.dependencies();
  }
}