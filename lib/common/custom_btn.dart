import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:EduPulse/common/custom_text.dart';
import 'package:EduPulse/utils/color_utils.dart';

class CustomBtn extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final double? radius;
  final double? height;
  final double? width;
  final Color? bgColor;
  final Color? textColor;
  final Color? borderColor;
  final double? fontSize;
  final bool? isDownloadFile;
  final IconData? leading;
  final bool? withIcon;
  final String? iconPath;

  // ignore: use_key_in_widget_constructors
  const CustomBtn(
      {required this.onTap,
      required this.title,
      this.radius,
      this.borderColor,
      this.height,
      this.width,
      this.fontSize,
      this.bgColor,
      this.textColor,
      this.leading,
      this.withIcon = false,
      this.iconPath,
      this.isDownloadFile = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        height: height ?? 6.h,
        width: width ?? Get.width * 0.5,
        decoration: BoxDecoration(
          color: bgColor ?? ColorUtils.purple2D,
          border: Border.all(color: borderColor ?? ColorUtils.purple2D),
          borderRadius: BorderRadius.circular(radius ?? 30),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius ?? 25),
          child: Center(
            child: CustomText(
              title!,
              fontWeight: FontWeight.w600,
              color: textColor ?? ColorUtils.white,
              fontSize: fontSize ?? 14.sp,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
