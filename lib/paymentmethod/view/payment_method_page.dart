import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/custome_loader/lodading_indicator.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../controller/customcontroller.dart';
import 'package:flutter_svg/svg.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({Key? key}) : super(key: key);

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  var controller=Get.find<CustomController>();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(controller.loading.value){
          return false;
        }
        return true;
      },
      child: Scaffold (
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text("payment_method".tr,style: Style.customTextStyle(AppTheme.black, 16.0,FontWeight.bold,FontStyle.normal),),
              leading: IconButton(
                onPressed: () {
                  if(!controller.loading.value){
                    Get.back();
                  }
                },
                icon: const Icon(
                  CupertinoIcons.arrow_left,
                  color: Colors.black,
                ),
              ),
            ),
            backgroundColor: AppTheme.white,
            body: SafeArea(
              child: Obx(()=>
                Stack(
                  children:  [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Obx(()=>
                            ListView.builder(
                              itemCount: controller.paymentMethodObj.length,
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                return controller.paymentMethodObj.isNotEmpty ?
                                    InkWell(
                                      onTap: (){
                                        for (var element in controller.paymentMethodObj) {
                                          if(element.isChecked==true){
                                            element.isChecked=false;
                                          }
                                        }
                                        controller.paymentMethodTapped(i);
                                        // controller.submitButtonText.value=controller.paymentMethodObj[i].paymentText;
                                        // controller.paymentMethodObj[i].isChecked=true;
                                        // controller.paymentMethodId.value=controller.paymentMethodObj[i].methodId;
                                        // controller.paymentMethodCode=controller.paymentMethodObj[i].methodCode;
                                        // controller.paymentMethodObj.refresh();
                                      },
                                      child: SizedBox(
                                        height: 60,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children:  [
                                              controller.paymentMethodObj[i].isChecked?const Icon(
                                                Icons.check_circle,
                                                size: 30.0,
                                                color: AppTheme.primaryColor,
                                              ):const Icon(
                                                Icons.circle_outlined,
                                                size: 30.0,
                                                color: AppTheme.primaryColor,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                  child: Text(controller.paymentMethodObj[i].methodName, style: const TextStyle(
                                                    color: AppTheme.black,
                                                  ),),
                                                ),
                                              ),
                                              SvgPicture.asset(controller.paymentMethodObj[i].imgUrl),
                                              SizedBox(width: 10,)
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    : Container(
                                  height: 0,
                                  width: 0,
                                );
                              },
                            ),
                          ),
                          Obx(() {
                           return  controller.isEmailNeeded.value ?  Padding(padding:const EdgeInsets.all(15),
                              child:  TextField(
                                onChanged: (a){
                                  controller.isShowButton.value = true;
                                  controller.error.value = '';
                                  controller.errorEmail.value = false;
                                },
                                controller: controller.emailController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                  hintText: "email".tr,
                                  hintStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                  ),
                                  border: controller.errorEmail.value ? OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28),
                                      borderSide:  const BorderSide(color: AppTheme.primaryColor)
                                  ) : OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28),
                                      borderSide:   const BorderSide(color: AppTheme.blackTextColor)
                                  ) ,
                                  enabledBorder: controller.errorEmail.value ? OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28),
                                      borderSide:  const BorderSide(color: AppTheme.primaryColor)
                                  ) : OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28),
                                      borderSide:    const BorderSide(color: AppTheme.blackTextColor)
                                  ) ,
                                  disabledBorder: controller.errorEmail.value ? OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28),
                                      borderSide:  const BorderSide(color: AppTheme.primaryColor)
                                  ) : OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28),
                                      borderSide:   const BorderSide(color: AppTheme.blackTextColor)
                                  ) ,
                                  focusedBorder:  controller.errorEmail.value ? OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28),
                                      borderSide:  const BorderSide(color: AppTheme.primaryColor)
                                  ) : OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28),
                                      borderSide:   const BorderSide(color: AppTheme.blackTextColor)
                                  ) ,
                              ),
                            )) : const SizedBox();
                          }),
                          controller.error.value.isNotEmpty ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              children: [
                                const SizedBox(height: 5,),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(controller.error.value,style: const TextStyle(
                                      fontSize: 12,fontWeight: FontWeight.w400,
                                      color: AppTheme.primaryColor
                                  ),
                                  ),
                                ),
                              ],
                            ),
                          ) : const SizedBox(),

                          Padding(padding:const EdgeInsets.all(15),
                            child: controller.priceInfoView(),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            controller.paymentMethodId.value==1?SizedBox(child: Image.asset(controller.storageService.getAppLanguage()=="1"?ImageUtil.icMadaEnglish:ImageUtil.icMadaArabic,fit: BoxFit.fitWidth,),height: 60,):Container(),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Obx(() => Row(
                                children: [
                                  Expanded(
                                      child: ElevatedButton(

                                        style:  ElevatedButton.styleFrom(
                                            backgroundColor: !controller.isShowButton.value ? AppTheme.primaryColor.withOpacity(0.2) : AppTheme.primaryColor,
                                            minimumSize:  const Size(double.infinity, 50.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),),
                                        onPressed: () {
                                          if(controller.isShowButton.value) {
                                            controller.checkEmailNeeded();
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Spacer(),
                                            Text(controller.submitButtonText.value,style: Style.normalTextStyle(Colors.white, 18.0),),
                                            const Spacer(),
                                            Text("sar".tr+" "+controller.calculateTotalAmount().toStringAsFixed(2),style: Style.normalTextStyle(Colors.white, 18.0),),
                                          ],
                                        ),

                                      )),
                                ],
                              ),
                              ),
                            ),
                          ],
                        )
                    ),
                    controller.loading.value==true?const Center(
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballRotateChase,
                          colors:  [AppTheme.primaryColor],
                          strokeWidth: 2,
                        ),
                      ),
                    ):Container(),
                  ],
                ),
              ),
            ),
          ),
    );
  }



  Function()? checkPressed(){



    var paymentMethodObj;
    for (int i=0;i<controller.paymentMethodObj.length;i++) {
      if(controller.paymentMethodObj[i].isChecked){
        paymentMethodObj=controller.paymentMethodObj[i];
      }
    }
    if(paymentMethodObj!=null){
      return (){
        if(controller.paymentMethodId.value==2) {
          // PayfortPlugin.getID.then((value) {
          //   //use this call to get device id and send it to server
          //   if(value!=null){
          //     controller.deviceId=value;
          //     controller.getToken(value, controller.generateSha256(value));
          //   }
          // });
          controller.createOrder();
        }else{
          controller.callPayFort(controller.paymentMethodId.value);
        }
      };
    }else{
      return null;
    }

  }
}
