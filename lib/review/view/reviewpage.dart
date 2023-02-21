import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';
import '../controller/reviewcontroller.dart';

class ReviewPage extends StatefulWidget {
  String productId;
  ReviewPage(this.productId, {Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final maxLines = 5;
  ReviewController controller = Get.find<ReviewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "write_a_review".tr,
          style: Style.titleTextStyle(AppTheme.blackTextColor, 16),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            CupertinoIcons.arrow_left,
            color: AppTheme.black,
          ),
        ),
      ),
      body: _reviewPageContent(),
    );
  }

  _reviewPageContent() {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.reviewFormKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(() => controller.handleResponse()),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "rate".tr,
                        style: Style.subheadingTextStyle(14),
                      ),
                    ),
                    const SizedBox(height: 20),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: AppTheme.starColor,
                      ),
                      onRatingUpdate: (rating) {
                        controller.rating = rating.toInt();
                      },
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: controller.headlineController,
                      decoration:
                      Style.textFieldWithoutIconStyle("review_headline".tr),
                      validator: (value) {
                        return controller.validateField(value!);
                      },
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 170,
                      child: TextFormField(
                        controller: controller.reviewController,
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.top,
                        expands: true,
                        maxLines: null,
                        decoration: Style.textFieldWithoutIconStyle(
                            "write_a_comment".tr),
                        validator: (value) {
                          return controller.validateField(value!);
                        },
                      ),
                    ),
                    const SizedBox(height: 54),
                    Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          bool isValid = controller.isValid();
                          if (controller.rating > 0) {
                            if (isValid) {
                              controller.postReview(widget.productId);
                            }
                          } else {
                            Get.snackbar(
                                "message".tr, "select_starts".tr);
                          }
                        },
                        child: Text("submit_review".tr,
                            style: Style.normalTextStyle(AppTheme.white, 14)),
                        style: Style.primaryButtonStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
