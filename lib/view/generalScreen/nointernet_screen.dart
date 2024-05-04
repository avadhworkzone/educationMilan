import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:Jamanvav/common/custom_text.dart';
import 'package:Jamanvav/utils/asset_utils.dart';

import '../../utils/color_utils.dart';
import '../../utils/string_utils.dart';

class NoInterNetConnected extends StatelessWidget {
  const NoInterNetConnected({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorUtils.grey5E,
      child: SafeArea(
        child: SizedBox(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AssetsUtils.noInternet, height: 30.w),
              SizedBox(
                height: 3.h,
              ),
              CustomText(
                StringUtils.noInterNetMessage,
                color: ColorUtils.black,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
