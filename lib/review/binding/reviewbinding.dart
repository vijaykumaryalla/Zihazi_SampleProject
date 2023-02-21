import 'package:get/get.dart';

import '../../baseclasses/basebinding.dart';
import '../controller/reviewcontroller.dart';
import '../repo/reviewrepo.dart';

class ReviewBinding extends BaseBinding{
  @override
  void dependencies() {
    Get.put(ReviewRepo());
    Get.put(ReviewController());
    super.dependencies();
  }
}