import 'package:get/get.dart';

import '../../baseclasses/basebinding.dart';
import '../controller/signupcontroller.dart';
import '../repo/signuprepo.dart';

class SignupBinding extends BaseBinding{
  @override
  void dependencies() {
    Get.put(SignupRepo());
    Get.put(SignupController());
    super.dependencies();
  }
}