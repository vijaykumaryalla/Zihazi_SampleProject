
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zihazi_sampleproject/baseclasses/theme.dart';
import 'package:zihazi_sampleproject/baseclasses/utils/imageutils.dart';

import '../service/networkerrors.dart';

class PageErrorView extends StatefulWidget {
  Function onClick;
  dynamic error;
  PageErrorView(this.onClick, this.error, {Key? key}) : super(key: key);

  @override
  _PageErrorViewState createState() => _PageErrorViewState();
}

class _PageErrorViewState extends State<PageErrorView> {
  @override
  Widget build(BuildContext context) {
    String msg = 'Error occurred';
    String subMsg='';
    if(widget.error is ServerError){
      msg = (widget.error as ServerError).msg;
    }
    if(widget.error is NoInternetError){
      msg = (widget.error as NoInternetError).msg;
      subMsg = (widget.error as NoInternetError).subMsg;
    }
    if(widget.error is NoData){
      msg = (widget.error as NoData).msg;
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          InkWell(
              onTap: (){
                widget.onClick();
              }, child: SvgPicture.asset(ImageUtil.noInternetIcon,)),
          const SizedBox(height: 30,),
          Text(msg,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: AppTheme.headingTextColor,
            ),
          ),
          const SizedBox(height: 10,),
          Text(subMsg,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.subheadingTextColor,
            ),),
        ],
      ),
    );
  }
}
