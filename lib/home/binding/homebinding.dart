import 'package:get/get.dart';
import 'package:zihazi_sampleproject/account/controller/accountcontroller.dart';
import 'package:zihazi_sampleproject/account/repo/accountrepo.dart';
import 'package:zihazi_sampleproject/baseclasses/basebinding.dart';
import 'package:zihazi_sampleproject/dashboard/controller/dashboardcontroller.dart';
import 'package:zihazi_sampleproject/dashboard/repo/dashboardrepo.dart';
import 'package:zihazi_sampleproject/wishlist/controller/wishlistcontroller.dart';

import '../../baseclasses/theme.dart';
import '../../cart/controller/cartcontroller.dart';
import '../../cart/repo/cartrepo.dart';
import '../../locale/localeservice.dart';
import '../../wishlist/repo/wishlistrepo.dart';
import '../controller/homecontroller.dart';
import '../repo/homerepo.dart';

class HomeBinding extends BaseBinding{
  @override
  void dependencies() {
    Get.put(AccountRepo());
    Get.put(LocaleService());
    Get.put(AccountController());
    Get.put(WishlistRepo());
    Get.put(WishListController());
    Get.put(CartRepo());
    Get.put(CartController());
    Get.put(HomeRepo());
    Get.put(HomeController());
    Get.put(DashboardRepo());
    Get.put(DashboardController());
    Get.put(AppTheme());

    super.dependencies();
  }
}