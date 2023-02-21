import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/imageutils.dart';
class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: 0.5,
      maxChildSize: 1,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0))),
        child: ListView(
          controller: controller,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(CupertinoIcons.arrow_left)
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Center(
                      child: Text(
                          "privacy_policy".tr,
                          textAlign: TextAlign.center,
                          style: Style.titleTextStyle(Colors.black, 16)),
                    ),
                  ),
                )
              ],
            ),
            Container(
              width: double.infinity,
              color: AppTheme.imageBackgroundColor,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SvgPicture.asset(ImageUtil.privacyImg),
                ),
              )
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                "privacy_statements".tr,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ) ,
            ),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "point1".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point2".tr,
                      maxLines: 4,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point3".tr,
                      maxLines: 4,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point4".tr,
                      maxLines: 4,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point5".tr,
                      maxLines: 4,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 15),
                  ],
                )),
         Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Text(
            "data_we_collect".tr,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700),
          )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
              children: [
                const SizedBox(height: 5),
                Text(
                  "point6".tr,
                  maxLines: 4,
                  style: Style.normalTextStyle(AppTheme.textColor, 14),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                Text(
                  "point7".tr,
                  maxLines: 4,
                  style: Style.normalTextStyle(AppTheme.textColor, 14),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                Text(
                  "point8".tr,
                  maxLines: 8,
                  style: Style.normalTextStyle(AppTheme.textColor, 14),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                Text(
                  "point9".tr,
                  maxLines: 4,
                  style: Style.normalTextStyle(AppTheme.textColor, 14),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                Text(
                  "point10".tr,
                  style: Style.normalTextStyle(AppTheme.textColor, 14),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                Text(
                  "point11".tr,
                  style: Style.normalTextStyle(AppTheme.textColor, 14),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                Text(
                  "point12".tr,
                  style: Style.normalTextStyle(AppTheme.textColor, 14),
                  textAlign: TextAlign.left,
                ),
              ],
            )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "credit_check".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point13".tr,
                      maxLines: 4,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point14".tr,
                      maxLines: 4,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point15".tr,
                      maxLines: 8,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point16".tr,
                      maxLines: 4,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "other_uses".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point17".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point18".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point19".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "competition".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point20".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "third_parties".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point21".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),

                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "use_of_fb".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point22".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point23".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point24".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point25".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point26".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "cookies".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point27".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),

                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "what_are_cookies".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point28".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "what_kind_of_cookies".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point29".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "kind_of_information".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point30".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "onsite_targeting".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point31".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "third_party".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point32".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "re_targeting".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point33".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "resale".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point34".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "prevent_cookies".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point35".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point36".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point37".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point38".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point39".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "log_info".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point40".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point41".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point42".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "point43".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "security".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point44".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "consent".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point45".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "your_rights".tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "point46".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
