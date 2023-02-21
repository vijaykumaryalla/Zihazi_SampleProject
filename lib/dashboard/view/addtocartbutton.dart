import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../baseclasses/theme.dart';
import '../../baseclasses/utils/constants.dart';
import '../../baseclasses/utils/multistate_button/button_state.dart';
import '../../baseclasses/utils/multistate_button/multi_state_button.dart';
import '../../baseclasses/utils/multistate_button/multi_state_button_controller.dart';

class AddToCartButton extends StatefulWidget {

  final MultiStateButtonController multiStateButtonController;
  final Function onClicked;
  const AddToCartButton({Key? key,
    required this.multiStateButtonController,
    required this.onClicked
  }) : super(key: key);

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  @override
  Widget build(BuildContext context) {
    return MultiStateButton(
      multiStateButtonController: widget.multiStateButtonController,
      buttonStates:[
        ButtonState(
            stateName: Constants.idle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "add_to_cart".tr,
              ),
            ),
            textStyle: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            color: AppTheme.primaryColor,
            onPressed:() {
              widget.onClicked();
              widget.multiStateButtonController.setButtonState = Constants.loading;
              Future.delayed(const Duration(milliseconds: 2000), () {
                widget.multiStateButtonController.setButtonState = Constants.success;
                Future.delayed(const Duration(milliseconds: 1000), () {
                  widget.multiStateButtonController.setButtonState = Constants.idle;
                });
              });
            }
        ),
        ButtonState(
          stateName: Constants.loading,
          alignment: Alignment.center,
          child: const SizedBox(
            height: 15,width: 15,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppTheme.white,
            ),
          ),
          size: const Size(20, 20),
          decoration: const BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          onPressed: () {

          },
        ),
        ButtonState(
          stateName: Constants.success,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  "added_to_cart".tr,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.white,
                  ),
                ),
              ),
              const SizedBox(width: 5,),
              const Flexible(flex:1,child: Icon(Icons.check_circle, color: AppTheme.white, size: 15,)),

            ],
          ),
          textStyle: const TextStyle(color: Colors.white, fontSize: 12),
          decoration: const BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          onPressed: () {
          },
        ),
      ],
    );
  }
}