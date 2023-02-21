import 'package:get/get.dart';

import '../../baseclasses/basebinding.dart';
import '../controller/myorderscontroller.dart';
import '../controller/orderdetailcontroller.dart';
import '../repo/myordersrepo.dart';

class MyOrdersBinding extends BaseBinding{
  @override
  void dependencies() {
    Get.put(OrdersRepo());
    Get.put(MyOrdersController());
    Get.put(OrderDetailController());
    super.dependencies();
  }
}