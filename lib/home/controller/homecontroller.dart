import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:zihazi_sampleproject/account/view/myaccountpage.dart';
import 'package:zihazi_sampleproject/baseclasses/basecontroller.dart';
import 'package:zihazi_sampleproject/cart/view/cartpage.dart';
import 'package:zihazi_sampleproject/productlist/view/productlistpage.dart';
import 'package:zihazi_sampleproject/wishlist/view/wishlistpage.dart';

import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/nav_icons.dart';
import '../../dashboard/view/dashboardpage.dart';
import '../model/productmodel.dart';
import '../repo/homerepo.dart';

class HomeController extends BaseController{
  var repo = Get.find<HomeRepo>();
  RxList<Prolist> productList = List<Prolist>.empty(growable: true).obs;
  var tabIndex = 0.obs;
  final List<Widget> pages = [
     const DashboardPage(),
    WishListPage(),
    const CartPage(),
    const MyAccountPage()
  ];
  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      PersistentBottomNavBarItem(icon:  const Icon(NavIcons.ic_home,), title: (""), activeColorPrimary: AppTheme.primaryColor, inactiveColorPrimary: AppTheme.subheadingTextColor,),
      PersistentBottomNavBarItem(icon:  const Icon(NavIcons.ic_wishlist), title: (""), activeColorPrimary: AppTheme.primaryColor, inactiveColorPrimary: AppTheme.subheadingTextColor,),
      PersistentBottomNavBarItem(icon:  const Icon(NavIcons.ic_cart), title: (""), activeColorPrimary: AppTheme.primaryColor, inactiveColorPrimary: AppTheme.subheadingTextColor,),
      PersistentBottomNavBarItem(icon:  const Icon(NavIcons.ic_profile), title: (""), activeColorPrimary: AppTheme.primaryColor, inactiveColorPrimary: AppTheme.subheadingTextColor,),
    ];
  }

  var tabController = PersistentTabController(initialIndex: 0);

}