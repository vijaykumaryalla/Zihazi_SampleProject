import 'package:get/get.dart';

import '../../baseclasses/basebinding.dart';
import '../controller/addeditaddresscontroller.dart';
import '../repo/shippingaddressrepo.dart';

class AlterShippingBinding extends BaseBinding {
  @override
  void dependencies() {
    Get.put(ShippingAddressRepo());
    Get.put(AddEditAddressController());
    super.dependencies();
  }
}