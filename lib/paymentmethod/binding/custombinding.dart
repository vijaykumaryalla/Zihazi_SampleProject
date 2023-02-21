import 'package:get/get.dart';
import '../controller/customcontroller.dart';
import '../repo/repo.dart';


class CustomBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(Repo());
    Get.put(CustomController());
  }

}