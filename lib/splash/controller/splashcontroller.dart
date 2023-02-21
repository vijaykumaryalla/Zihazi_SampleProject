import '../../baseclasses/basecontroller.dart';

class SplashController extends BaseController{

  @override
  void onInit() {
    checkConnection();
    super.onInit();
  }
}