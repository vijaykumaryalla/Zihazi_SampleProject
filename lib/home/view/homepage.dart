import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:zihazi_sampleproject/baseclasses/theme.dart';
import 'package:zihazi_sampleproject/home/controller/homecontroller.dart';
import 'package:zihazi_sampleproject/home/view/under_maintenance_diogbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var controller = Get.put(HomeController());
  // @override
  // void initState() {
  //   super.initState();
  //   _showUnderMaintenance();
  // }
  //
  // _showUnderMaintenance() {
  //   final ref = FirebaseDatabase.instance.ref();
  //   ref
  //       .child("is_under_maintenance")
  //       .once()
  //       .then((data) => handleUnderMaintenance(data.snapshot.value));
  // }
  //
  // handleUnderMaintenance(dynamic isUnderMaintenance) {
  //   if (isUnderMaintenance) {
  //     showModalBottomSheet(
  //         isDismissible: false,
  //         enableDrag: false,
  //         isScrollControlled: true,
  //         backgroundColor: Colors.transparent,
  //         context: context,
  //         builder: (context) => const UnderMaintenanceDialog());
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: controller.tabController,
        screens: controller.pages,
        items: controller.navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        // Default is true.
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
        NavBarStyle.style12, // Choose the nav bar style with this property.
      ),
    );
  }
}
