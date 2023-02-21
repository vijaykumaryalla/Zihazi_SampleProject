import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:zihazi_sampleproject/login/view/loginpage.dart';
import 'package:zihazi_sampleproject/product_details/binding/product_detail_binding.dart';
import 'package:zihazi_sampleproject/product_details/view/product_detail_page.dart';
import 'package:zihazi_sampleproject/productlist/binding/productlistbinding.dart';
import 'package:zihazi_sampleproject/productlist/view/productlistpage.dart';
import 'package:zihazi_sampleproject/review/binding/reviewbinding.dart';
import 'package:zihazi_sampleproject/review/view/reviewpage.dart';
import 'package:zihazi_sampleproject/shippingaddress/binding/shippingbinding.dart';
import 'package:zihazi_sampleproject/shippingaddress/view/shipingaddeditpage.dart';
import 'package:zihazi_sampleproject/shippingaddress/view/shippinglistpage.dart';
import 'package:zihazi_sampleproject/signup/binding/signupbinding.dart';
import 'package:zihazi_sampleproject/signup/view/otp_page.dart';
import 'package:zihazi_sampleproject/signup/view/reset_password_page.dart';
import 'package:zihazi_sampleproject/signup/view/signuppage.dart';
import 'package:zihazi_sampleproject/splash/binding/splashbinding.dart';
import 'package:zihazi_sampleproject/splash/view/splashpage.dart';
import 'package:zihazi_sampleproject/wallet/binding/wallet_binding.dart';
import 'package:zihazi_sampleproject/wallet/view/wallet_page.dart';
import 'package:zihazi_sampleproject/wishlist/binding/wishlistbinding.dart';
import 'package:zihazi_sampleproject/wishlist/view/wishlistpage.dart';

import 'account/binding/accountbinding.dart';
import 'account/view/myaccountpage.dart';
import 'account_settings/binding/account_settings_binding.dart';
import 'account_settings/view/account_settings_page.dart';
import 'baseclasses/basebinding.dart';
import 'baseclasses/sessions.dart';
import 'baseclasses/theme.dart';
import 'baseclasses/utils/constants.dart';
import 'cart/binding/cartbinding.dart';
import 'cart/view/cartpage.dart';
import 'change_password/binding/changepasswordbinding.dart';
import 'change_password/view/changepasswordpage.dart';
import 'checout_info/binding/chekout_info_binding.dart';
import 'checout_info/view/chekout_info_page.dart';
import 'contact_us/binding/contactusbinding.dart';
import 'contact_us/view/contactuspage.dart';
import 'forgot_password/binding/forgot_password_binding.dart';
import 'forgot_password/view/forgot_password_page.dart';
import 'frequently_asked_question/binding/faqbbinding.dart';
import 'frequently_asked_question/view/faqpage.dart';
import 'home/binding/homebinding.dart';
import 'home/view/homepage.dart';
import 'home/view/under_maintenance_diogbox.dart';
import 'locale/localeservice.dart';
import 'myorders/binding/myordersbinding.dart';
import 'myorders/view/myorderslistpage.dart';
import 'myorders/view/ordersdetailpage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initialConfig();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Jihazi',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      darkTheme: AppTheme.dark,
      themeMode: AppTheme().theme,
      initialBinding: BaseBinding(),
      initialRoute: '/splash',
      locale: LocaleService.locale,
      fallbackLocale: LocaleService.fallbackLocale,
      translations: LocaleService(),
      // home: const LoginPage(productId: "0", page: '',),
      getPages: [
        GetPage(name: '/splash', page: () => const SplashPage(), binding: SplashBinding()),
        GetPage(name: '/under_maintenance', page: () =>  const UnderMaintenanceDialog(), binding: HomeBinding()),
        GetPage(name: '/forgotpwd', page: () => const ForgotPwdPage(), binding: ForGotPwdBinding()),
        GetPage(name: '/wishlistpage', page: () => WishListPage(), binding: WishlistPageBinding()),
        GetPage(name: '/home', page: () => const HomePage(), binding: HomeBinding()),
        GetPage(name: '/signup', page: () => const SignUpPage(), binding: SignupBinding()),
        GetPage(name: '/myAccount', page: () => const MyAccountPage(), binding: AccountBinding()),
        GetPage(name: '/cart', page: () => const CartPage(), binding: CartBinding()),
        GetPage(name: '/product_list', page: () => const ProductListPage(), binding: ProductListBinding()),
        GetPage(name: '/productdetail', page: () => const ProductDetailPage(), binding: ProductDetailBinding()),
        GetPage(name: '/wishlistpage', page: () => WishListPage(), binding: WishlistPageBinding()),
        GetPage(name: '/checkoutinfopage', page: () => CheckoutInfoPage(), binding: CheckoutInfoBinding()),
        GetPage(name: '/shippingList', page: () => const ShippingListPage(), binding: ShippingBinding()),
        GetPage(name: '/AlterShipping', page: () => AddEditShippingAddress(null), binding: ShippingBinding()),
        GetPage(name: '/accountSettings', page: () => const AccountSettingsPage(), binding: AccountSettingBinding()),
        GetPage(name: '/wallet', page: () => WalletPage(), binding: WalletPageBinding()),
        GetPage(name: '/signup', page: () => const SignUpPage(), binding: SignupBinding()),
        GetPage(name: '/myOrders', page: () => const MyOrdersListPage(), binding: MyOrdersBinding()),
        GetPage(name: '/orderDetail', page: () => const OrderDetailPage(), binding: MyOrdersBinding()),
        GetPage(name: '/product_list', page: () => const ProductListPage(), binding: ProductListBinding()),
        GetPage(name: '/review', page: () => ReviewPage(""), binding: ReviewBinding()),
        GetPage(name: '/changepassword', page: () => ChangePasswordPage(), binding: ChangePasswordBinding()),
        GetPage(name: '/contactuspage', page: () => ContactUsPage(), binding: ContactUsBinding()),
        GetPage(name: '/faq', page: () => const FaqPage(), binding: FaqBinding()),
        GetPage(name: '/otp', page: () => const OTPPage(), binding: SignupBinding()),
        GetPage(name: '/resetpassword', page: () => const ResetPasswordPage(), binding: SignupBinding())
      ],
    );
  }
}
Future<void> initialConfig() async {
  await Get.putAsync(() => StorageService().init());// SessionService
  StorageService().write(Constants.appLanguage, Constants.english);
   LocaleService().changeLocale("English");
  //Define local storage services like Db here.
}

