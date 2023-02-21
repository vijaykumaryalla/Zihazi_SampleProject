import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../../baseclasses/basebinding.dart';
import '../../cart/controller/cartcontroller.dart';
import '../../shippingaddress/controller/shippingcontroller.dart';
import '../../shippingaddress/repo/shippingaddressrepo.dart';
import '../controller/checkout_info_controller.dart';
import '../repo/checkout_info_repo.dart';

class CheckoutInfoBinding extends BaseBinding{
  @override
  void dependencies() {
    Get.put(CheckoutInfoRepo());
    Get.put(CartController());
    Get.put(ShippingAddressRepo());
    Get.put(ShippingController());
    Get.put(CheckoutInfoController());
    super.dependencies();
  }

}