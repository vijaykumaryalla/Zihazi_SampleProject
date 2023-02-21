import 'package:get/get.dart';

import '../../baseclasses/basebinding.dart';
import '../controller/shippingcontroller.dart';
import '../repo/shippingaddressrepo.dart';

class ShippingBinding extends BaseBinding {
  @override
  void dependencies() {
    Get.put(ShippingAddressRepo());
    Get.put(ShippingController());
    super.dependencies();
  }
}