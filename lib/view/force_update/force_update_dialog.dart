import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_store/open_store.dart';
import 'package:sizer/sizer.dart';
import 'package:EduPulse/common/custom_text.dart';
import 'package:EduPulse/utils/color_utils.dart';
import 'package:EduPulse/utils/string_utils.dart';

updateDialog(BuildContext context) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.04, vertical: Get.height * 0.02),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/alert.png", width: Get.width * 0.07),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                CustomText(
                  StringUtils.updateAvailable,
                  color: ColorUtils.black32,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                InkWell(
                  onTap: () async {
                    OpenStore.instance.open(
                        appStoreId:
                            '284815942', // AppStore id of your app for iOS
                        appStoreIdMacOS:
                            '284815942', // AppStore id of your app for MacOS (appStoreId used as default)
                        androidAppBundleId:
                            'com.madvise.edu', // Android app bundle package name
                        windowsProductId:
                            '9NZTWSQNTD0S' // Microsoft store id for Widnows apps
                        );
                    // await signOut();
                    // Get.offAll(const SignUpScreen());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ColorUtils.primaryColor),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Get.height * 0.005,
                          horizontal: Get.width * 0.04),
                      child: CustomText(
                        StringUtils.update,
                        color: ColorUtils.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
