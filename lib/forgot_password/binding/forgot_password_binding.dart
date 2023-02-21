
import 'package:get/get.dart';

import '../../baseclasses/basebinding.dart';
import '../controller/forgot_password_controller.dart';
import '../repo/forgot_password_repo.dart';

class ForGotPwdBinding extends BaseBinding{
  @override
  void dependencies() {
    Get.put(ForgotPwdRepo());
    Get.put(ForgotPwdController());
    super.dependencies();
  }

}