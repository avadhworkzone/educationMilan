import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'color_utils.dart';

class CircularIndicator extends StatelessWidget {
  const CircularIndicator({Key? key, this.isExpand, this.bgColor})
      : super(key: key);
  final bool? isExpand;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isExpand == false ? 35.w : Get.height,
      width: isExpand == false ? 35.w : Get.width,
      color: bgColor ?? Colors.white.withOpacity(0.5),
      child: Center(
        child: SizedBox(
          height: 15.w,
          width: 15.w,
          child: CircularProgressIndicator(
            color: ColorUtils.primaryColor,
          ),
        ),
      ),
    );
  }
}
