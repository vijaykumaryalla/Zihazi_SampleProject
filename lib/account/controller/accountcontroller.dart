import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../baseclasses/basecontroller.dart';
import '../../baseclasses/basefailuremodel.dart';
import '../../baseclasses/sessions.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/custome_loader/lodading_indicator.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../../locale/localeservice.dart';
import '../../login/binding/loginbinding.dart';
import '../../login/view/loginpage.dart';
import '../../service/networkerrors.dart';
import '../model/my_account.dart';
import '../repo/accountrepo.dart';

class AccountController extends BaseController {
  var storageService = Get.find<StorageService>();
  var repo = Get.find<AccountRepo>();
  var localeService = Get.find<LocaleService>();
  late MyAccount accountData;
  final RxInt _value = 1.obs;
  var accountResponse = ResponseInfo(responseStatus: Constants.idle).obs;

  AccountController() {
    checkConnection();

    isConnected.listen((value) async {
      var loggedIn = await storageService.checkLogin();
      if(value&&loggedIn){
        print("isConnected");
        getAccountInfo();
      }
    });

    eventBus.on<String>().listen((event) { // listening for login callback to load data again
      if(event==Constants.loginSuccess){
        print("eventBus");
        getAccountInfo();
      }

    });
  }

  void getAccountInfo() async {
    _value.value = int.parse(storageService.getAppLanguage());
    accountResponse.value = ResponseInfo(responseStatus: Constants.loading);
    var userId = await storageService.read(Constants.userId);
    var result = await repo.getAccountDetails({
      "userid": userId
    });
    try {
      print(result);
      if (result.error == null) {
        var responseCode = result.response['SuccessCode'];
        if (responseCode == 200) {
          var message = result.response['message'];
          accountData = MyAccount.fromJson(result.response);
          accountResponse.value = ResponseInfo(
              responseStatus: Constants.success,
              respCode: responseCode,
              respMessage: message);
        } else {
          var baseFailureModel = BaseFailureModel.fromJson(result.response);
          accountResponse.value = ResponseInfo(
              responseStatus: Constants.failure,
              respCode: baseFailureModel.responseCode,
              respMessage: baseFailureModel.message);
        }
      } else {
        accountResponse.value = ResponseInfo(
            responseStatus: Constants.failure,
            respCode: 500,
            respMessage: result.error);
      }
    } catch (e) {
      accountResponse.value = ResponseInfo(
          responseStatus: Constants.failure,
          respCode: 500,
          respMessage: "something_went_wrong".tr);
      printError(info: e.toString());
    }
  }

  Widget buildMyAccount() {
    if (accountResponse.value.responseStatus == Constants.loading) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: SizedBox(
            height: 40,
            child: LoadingIndicator(
              indicatorType: Indicator.ballRotateChase,
              colors: [AppTheme.primaryColor],
              strokeWidth: 2,
            ),
          ),
        ),
      );
    } else if (accountResponse.value.responseStatus == Constants.failure) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            accountResponse.value.respMessage,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      );
    } else if (accountResponse.value.responseStatus == Constants.success) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: AppTheme.lightGrey),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 87,
                    width: 87,
                    child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            accountData.data.profileImage)
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(accountData.data.name,
                      style: Style.titleTextStyle(AppTheme.blackTextColor, 23)),
                  const SizedBox(height: 5),
                  Text(accountData.data.email, style: Style.titleTextStyle(
                      AppTheme.subheadingTextColor, 14)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                InkWell(
                  onTap: () {
                    Get.toNamed('/myOrders');
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryColor
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                              height: 17,
                              width: 10,
                              child: SvgPicture.asset(
                                  ImageUtil.orderIcon, color: Colors.white)
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text("my_order".tr, style: Style.titleTextStyle(
                          AppTheme.subheadingTextColor, 14)),
                    ],
                  ),
                ),
                Visibility(
                  visible: false,
                  child: InkWell(
                    onTap: () {

                    },
                    child: Column(
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primaryColor
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox(
                                height: 17,
                                width: 10,
                                child: SvgPicture.asset(
                                    ImageUtil.messageIcon, color: Colors.white)
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text("messages".tr, style: Style.titleTextStyle(
                            AppTheme.subheadingTextColor, 14)),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Get.toNamed('/shippingList');
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryColor
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                              height: 17,
                              width: 10,
                              child: SvgPicture.asset(
                                  ImageUtil.addressIcon, color: Colors.white)
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text("my_address".tr, style: Style.titleTextStyle(
                          AppTheme.subheadingTextColor, 14)),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: false,
              child: InkWell(
                onTap: () {

                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(ImageUtil.walletIcon),
                      const SizedBox(width: 15),
                      Text("my_wallet".tr, style: Style.titleTextStyle(
                          AppTheme.subheadingTextColor, 16)),
                      const Spacer(),
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: AppTheme.orange
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 5),
                          child: Text(accountData.data.walletBalance,
                              style: Style.titleTextStyle(AppTheme.white, 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed("/accountSettings");
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    SvgPicture.asset(ImageUtil.settingsIcon),
                    const SizedBox(width: 15),
                    Text("account_settings".tr, style: Style.titleTextStyle(
                        AppTheme.subheadingTextColor, 16)),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: InkWell(
                onTap: () {

                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(ImageUtil.shopIcon),
                      const SizedBox(width: 15),
                      Text("favourite_stores".tr, style: Style.titleTextStyle(
                          AppTheme.subheadingTextColor, 16)),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: InkWell(
                onTap: () {

                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(ImageUtil.pendingIcon),
                      const SizedBox(width: 15),
                      Text("pending_feedback".tr, style: Style.titleTextStyle(
                          AppTheme.subheadingTextColor, 16)),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed('/changepassword');
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    SvgPicture.asset(ImageUtil.passwordIcon),
                    const SizedBox(width: 15),
                    Text("change_password".tr, style: Style.titleTextStyle(
                        AppTheme.subheadingTextColor, 16)),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: InkWell(
                onTap: () {

                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(ImageUtil.notificationIcon),
                      const SizedBox(width: 15),
                      Text("notification".tr, style: Style.titleTextStyle(
                          AppTheme.subheadingTextColor, 16)),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed('/contactuspage');
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    SvgPicture.asset(ImageUtil.supportIcon),
                    const SizedBox(width: 15),
                    Text('contact_us'.tr, style: Style.titleTextStyle(
                        AppTheme.subheadingTextColor, 16)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed('/faq');
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    SvgPicture.asset(ImageUtil.faqIcon),
                    const SizedBox(width: 15),
                    Text('faq'.tr, style: Style.titleTextStyle(
                        AppTheme.subheadingTextColor, 16)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                openFile();
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    SvgPicture.asset(ImageUtil.faqIcon),
                    const SizedBox(width: 15),
                    Text("Open File", style: Style.titleTextStyle(
                        AppTheme.subheadingTextColor, 16)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                deleteFile();
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    SvgPicture.asset(ImageUtil.faqIcon),
                    const SizedBox(width: 15),
                    Text("Delete File", style: Style.titleTextStyle(
                        AppTheme.subheadingTextColor, 16)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
              child: Row(
                children: [
                  SvgPicture.asset(ImageUtil.worldIcon),
                  const SizedBox(width: 15),
                  Text('change_language'.tr,
                      style: Style.titleTextStyle(AppTheme.subheadingTextColor, 16)),
                  const Spacer(),
                  DropdownButton(
                    value: _value.value,
                    items: const [
                      DropdownMenuItem(
                        child: Text("English"),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("عربي"),
                        value: 2,
                      )
                    ],
                    onChanged: (int? value) {
                      _value.value = value!;
                      changeAppLanguage();
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 35
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                    backgroundColor: Colors.white
                ),
                // focusColor: AppTheme.primaryColor,
                // highlightColor: Colors.red[50],
                // highlightedBorderColor: AppTheme.primaryColor,

                child: Center(
                    child: Text(
                      'logout'.tr,
                      style: Style.titleTextStyle(AppTheme.primaryColor, 14),
                    )
                ),
                onPressed: () {
                  logout();
                },
              ),
            )
          ],
        ),);
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("please_login_to_view_account".tr,style: Style.customTextStyle(AppTheme.black, 14.0, FontWeight.normal, FontStyle.normal),),
            const SizedBox(height: 10,),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                style: Style.elevatedNormalRedButton(),
                onPressed: (){
                  Get.to( const LoginPage(page: Constants.cart, productId: "",), binding: LoginBinding());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("login".tr,style: Style.normalTextStyle(Colors.white, 18.0),),
                  ],

                ),

              ),
            )
          ],
        ),
      );
    }
  }

  changeAppLanguage() {
    if(_value == 1) {
      storageService.write(Constants.appLanguage, Constants.english);
      localeService.changeLocale("English");
      getAccountInfo();
    } else if(_value == 2) {
      storageService.write(Constants.appLanguage, Constants.arabic);
      localeService.changeLocale("عربي");
      getAccountInfo();
    }
    eventBus.fire(Constants.refreshDashboard);
    eventBus.fire(Constants.refreshWishlist);
    eventBus.fire(Constants.refreshCart);
    getAccountInfo();
  }

  logout() async {
    var isLoggedOut = await storageService.logout();
    if(isLoggedOut) {
      Get.offAll(const LoginPage(page: Constants.splash, productId: '0',), binding: LoginBinding());
    } else {
      Get.snackbar("message".tr, "Unable to logout");
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> getFileName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    return appName + "_" + packageName + "_" + version + "_" + buildNumber;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final fileName = await getFileName();
    return File('$path/' + fileName + '.txt');
  }

  Future<File> writeLog(String identifier, String log) async {
    final file = await _localFile;
    return file.writeAsString(formatLog(identifier, log) + "\n",
        mode: FileMode.append);
  }

  String formatLog(String identifier, String log) {
    String dateAndTime =
    DateFormat("MMMM, dd, yyyy hh:mm:ss a").format(DateTime.now());
    return dateAndTime + " " + identifier + " " + log;
  }

  Future<void> openFile() async {
    try {
      final path = await _localPath;
      final fileName = await getFileName();
      OpenFile.open('$path/' + fileName + '.txt').then((value) {
        if (value.type == ResultType.fileNotFound) {
          EasyLoading.showToast("There are no logs.So file doesn't exists");
        }
        if (value.type == ResultType.permissionDenied) {
          EasyLoading.showToast(
              "Permission missing. Please give storage permissions");
        }
        if (value.type == ResultType.noAppToOpen) {
          EasyLoading.showToast(
              "Your phone doesn't have application to open .txt files");
        }
        if (value.type == ResultType.error) {
          EasyLoading.showToast(value.message);
        }
      });
      // Read the file

    } catch (e) {
      // If encountering an error, return 0
      return e.printError(info: "File error");
    }
  }

  Future<void> deleteFile() async {
    try {
      final file = await _localFile;
      bool isFileExists = await file.exists();
      if (isFileExists) {
        await file.delete(recursive: true);
        EasyLoading.showToast("File Deleted");
      } else {
        EasyLoading.showToast("File Already Deleted");
      }
    } catch (e) {
      return e.printError(info: "File error");
    }
  }

}