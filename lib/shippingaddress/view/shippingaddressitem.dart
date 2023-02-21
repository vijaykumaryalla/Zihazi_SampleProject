import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zihazi_sampleproject/shippingaddress/view/shipingaddeditpage.dart';

import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/imageutils.dart';
import '../binding/altershippingbinding.dart';
import '../controller/shippingcontroller.dart';
import '../model/shipping_address.dart';

class ShippingAddressItem extends StatefulWidget {
  List<Address> addressList;
  ShippingAddressItem(this.addressList,{Key? key}) : super(key: key);

  @override
  _ShippingAddressItemState createState() => _ShippingAddressItemState();
}

class _ShippingAddressItemState extends State<ShippingAddressItem> {
  ShippingController controller = Get.find<ShippingController>();
  int selectedIndex = -1;

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var addressList = widget.addressList;
    return ListView.builder(
      itemCount: addressList.length,
      itemBuilder: (BuildContext context, int index) {
        var address = addressList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 1),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Column(
                children: [
                  Obx(() => controller.handleDeleteAPIResponse(context)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.scale(
                        alignment: Alignment.topLeft,
                        scale: 1.2,
                        child: Checkbox(
                          checkColor: Colors.white,
                          activeColor: AppTheme.primaryColor,
                          value: (selectedIndex == index)? true : false ,
                          shape: const CircleBorder(),
                          onChanged: (bool? value) {
                            if(value == true) {
                              setState(() {
                                selectedIndex = index;
                                controller.selectedAddress = address;
                                controller.showSaveButton(true);
                              });
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("${address.firstname} ${address.lastname}", style: Style.titleTextStyle(AppTheme.blackTextColor, 16),),
                            const SizedBox(height: 5),
                            Text(address.phone, style: Style.normalTextStyle(AppTheme.blackTextColor, 16),),
                            const SizedBox(height: 5),
                            Text(address.city, style: Style.normalTextStyle(AppTheme.blackTextColor, 16),),
                            Text("${address.country} - ${address.postcode}", style: Style.normalTextStyle(AppTheme.blackTextColor, 16),),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          var data = {
                            "addressId": address.addressId,
                            "firstname": address.firstname,
                            "lastname": address.lastname,
                            "country": address.country,
                            "postcode": address.postcode,
                            "city": address.city,
                            "location": address.location,
                            "state": address.state,
                            "isDefaultBilling": address.isDefaultBilling,
                            "isDefaultShipping": address.isDefaultShipping,
                            "phone": address.phone,
                            "company": address.company
                          };
                          _navigateAndRefresh(context, data);
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(right: 25, top: 16, left: 25, bottom: 16),
                            child: Text("edit".tr, style: Style.titleTextStyle(AppTheme.subheadingTextColor, 14),)
                        ),
                      )
                    ],

                  ),
                  const SizedBox(height: 30),
                  const Divider(
                    color: AppTheme.dividerColor,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 30),
                child: SizedBox(
                  width: 150,
                  child: OutlinedButton(

                    style: OutlinedButton.styleFrom(

                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side:  const BorderSide(
                        color: AppTheme.primaryColor,
                        width: 2,
                      ),
                    ),
                    // focusColor: AppTheme.primaryColor,
                    // highlightColor: Colors.red[50],
                    // highlightedBorderColor: AppTheme.primaryColor,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              width: 20,
                              height: 16,
                              child: SvgPicture.asset(ImageUtil.deleteIcon)
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "remove".tr,
                            style: Style.titleTextStyle(AppTheme.primaryColor, 14),
                          )
                        ],
                      ),
                    ),
                    onPressed: () {
                      controller.deleteAddress(address.addressId);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateAndRefresh(BuildContext context, dynamic data) async {
    await Get.to( () =>
        AddEditShippingAddress(data),
        binding: AlterShippingBinding()
    );
    controller.onInit();
  }
}
