
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../baseclasses/pageloaderror.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../service/networkerrors.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPwdPage extends StatefulWidget {
  const ForgotPwdPage({Key? key}) : super(key: key);

  @override
  _PageState createState() {
    return _PageState();
  }
}

class _PageState extends State<ForgotPwdPage> {

  var forgotPwdController= Get.put(ForgotPwdController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child:forgotPwdController.isConnected.value? Container(
          child: _MainBody(),
        ):
        PageErrorView((){}, NoInternetError()),

      ),
    );
  }

  Widget _MainBody() {
    return SingleChildScrollView(
      //controller: Get.find(ForgotPwdController()),
      child: Form(
        key: forgotPwdController.formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 150,width:0,),
              Text(
                "forgot_password".tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10,width:0,),
              Text(
                "Password_reset_link".tr + "\n" + "your_email_id".tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600,color: AppTheme.dividerColor),
              ),
              const SizedBox(height: 20,width:0,),
              TextFormField(
                controller: forgotPwdController.emailController,
                onChanged: (value) {
                  forgotPwdController.email = value;
                },
                validator: (value) {
                  return forgotPwdController.validateEmail(value!);
                },
                decoration: Style.roundedTextFieldStyle(
                    "email_address".tr,
                    "enter_email".tr,
                    ''),
              ),
              const SizedBox(height: 20,width:0,),
              ElevatedButton(
                  style: Style.elevatedRedRoundButton(),
                  onPressed: () async {

                    //  bool isValid = forgotPwdController.isValid();
                    //  if (isValid) {
                    //    Future.delayed(Duration.zero, () async {
                    //      showDialog(
                    //          context: context,
                    //          barrierDismissible: false,
                    //          builder: (BuildContext context) {
                    //            return const Center(
                    //              child: CircularProgressIndicator(),
                    //            );
                    //          });
                    //    });
                    // var message= await forgotPwdController.sendEmailData();
                    //    Navigator.pop(context);
                    //    Get.snackbar("message".tr, message!);
                    //  }
                    Future.delayed(Duration.zero, () async {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          });
                    });
                    var message= await forgotPwdController.sendEmailData();
                    Navigator.pop(context);
                    Get.snackbar("message".tr, message!);

                  },
                  child:  Text("send".tr)
              ),
              const SizedBox(height: 20,width:0,),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: SizedBox(
                  height: 30,
                  child: Center(
                    child: Text(
                      "login".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: AppTheme.primaryColor),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
