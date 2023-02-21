import 'package:get/get.dart';

import '../../baseclasses/basebinding.dart';
import '../controller/changepasswordcontroller.dart';
import '../repo/changepasswordrepo.dart';

class ChangePasswordBinding extends BaseBinding{



  @override
  void dependencies() {
    Get.put(ChangePasswordRepo());
    Get.put(ChangePasswordController());
    super.dependencies();
  }

}