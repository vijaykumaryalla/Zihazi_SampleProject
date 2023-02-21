import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/imageutils.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

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
                          "terms_and_condition".tr,
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
                    child: SvgPicture.asset(ImageUtil.termsAndConditionImg),
                  ),
                )
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                "introduction".tr,
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
                      "term1".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "term2".tr,
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
                  "use_of_site".tr,
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
                      "term3".tr,
                      maxLines: 4,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "term4".tr,
                      maxLines: 8,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Content provided on this site is solely for informational purposes. Product representations expressed on this Site are those of the vendor and are not made by us. Submissions or opinions expressed on this Site are those of the individual posting such content and may not reflect our opinions.",
                      maxLines: 4,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "term5".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "term6".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "user_submissions".tr,
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
                      "term7".tr,
                      maxLines: 4,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "order_acceptance".tr,
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
                      "term8".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "bulk_sale".tr,
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
                      "term9".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "copyrights".tr,
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
                      "term10".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),

                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "law".tr,
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
                      "term11".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "arbitration".tr,
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
                      "term12".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),

                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "termination".tr,
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
                      "term13".tr,
                      style: Style.normalTextStyle(AppTheme.textColor, 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
