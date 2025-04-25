import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../utils/color_utils.dart';
import '../utils/string_utils.dart';
import 'custom_text.dart';

void commonDialog({
  required String text,
  required String btnNameTxt,
  required VoidCallback? onTap,
}) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.06,
            vertical: Get.height * 0.02,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/alert.png", width: Get.width * 0.07),
              SizedBox(height: 2.h),
              CustomText(
                text,
                color: ColorUtils.greyA7,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: ColorUtils.greyA7),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 1.h,
                        horizontal: 5.w,
                      ),
                      child: CustomText(
                        StringUtils.cancel.tr,
                        color: ColorUtils.greyA7,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  InkWell(
                    onTap: onTap,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ColorUtils.redF3,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 1.h,
                        horizontal: 5.w,
                      ),
                      child: CustomText(
                        btnNameTxt,
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
