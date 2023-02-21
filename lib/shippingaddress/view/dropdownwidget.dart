import 'package:flutter/cupertino.dart';

import '../../baseclasses/styles.dart';
import '../../baseclasses/theme.dart';

class DropDownWidget {

  Widget create(String hint) {
    return DecoratedBox(
      child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(hint,
                    style: Style.normalTextStyle(
                        AppTheme.blackTextColor,16)),
                const Spacer(),
                SizedBox(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                          color: AppTheme.carouselGrey,
                          borderRadius: BorderRadius.all(
                              Radius.circular(5))),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(">"),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
      decoration: BoxDecoration(
          border: Border.all(color: AppTheme.boxgrey),
          //border: BorderSide(color: MyTheme.tffStrokeColor, width: 1.0),
          borderRadius: BorderRadius.circular(16.0)),
    );
  }
}