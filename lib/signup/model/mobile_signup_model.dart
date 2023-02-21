
enum RouteView {
  otp,
  resetPassword,
  stopped,
  paused
}

class MobileSignupModel {
  String otp = '';
  String mobileNumber = '';
  RouteView type = RouteView.otp;

}