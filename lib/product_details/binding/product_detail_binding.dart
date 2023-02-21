import 'package:get/get.dart';

import '../../baseclasses/basebinding.dart';
import '../controller/product_detail_controller.dart';
import '../repo/product_detail_repo.dart';

class ProductDetailBinding extends BaseBinding{

  @override
  void dependencies() {
    Get.put(ProductDetailRepo());
    Get.put(ProductDetailController());
    super.dependencies();
  }


}