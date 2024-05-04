import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:Jamanvav/utils/asset_utils.dart';
import 'package:Jamanvav/utils/color_utils.dart';

class CustomText extends StatelessWidget {
  final String title;
  final Color? color;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final double? fontSize;
  final TextAlign? textAlign;
  final double? height;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final double? letterSpacing;

  const CustomText(
    this.title, {
    Key? key,
    this.color,
    this.fontWeight,
    this.fontFamily,
    this.fontSize,
    this.textAlign,
    this.height,
    this.fontStyle,
    this.maxLines,
    this.overflow,
    this.decoration = TextDecoration.none,
    this.letterSpacing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title.tr,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        color: color ?? ColorUtils.black32,
        fontFamily: fontFamily ?? AssetsUtils.poppins,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontSize: fontSize ?? 11.sp,
        height: height,
        fontStyle: fontStyle,
        overflow: overflow,
        decoration: decoration,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
