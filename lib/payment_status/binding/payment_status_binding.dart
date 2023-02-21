import 'package:get/get.dart';

import '../controller/payment_status_controller.dart';
class PaymentStatusBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(PaymentStatusController());
  }

}