import 'package:get/get.dart';

import '../controller/productlistcontrller.dart';
import '../repo/productlistrepo.dart';

class ProductListBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(ProductListRepo());
    Get.put(ProductListController());
  }

}