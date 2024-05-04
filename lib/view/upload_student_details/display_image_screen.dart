import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:Jamanvav/common/custom_btn.dart';
import 'package:Jamanvav/common/custom_text.dart';
import 'package:Jamanvav/common/exit_confirmtion_dialog.dart';
import 'package:Jamanvav/utils/asset_utils.dart';
import 'package:Jamanvav/utils/color_utils.dart';
import 'package:Jamanvav/utils/string_utils.dart';
import 'package:Jamanvav/view/upload_student_details/upload_student_details.dart';

class ImageDisplayScreen extends StatelessWidget {
  final XFile selectedImage;

  const ImageDisplayScreen({super.key, required this.selectedImage});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          await ExitConfirmationDialog.showExitDialog(context),
      child: Scaffold(
          backgroundColor: ColorUtils.purple2D,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: ColorUtils.white,
                            )),
                        SizedBox(
                          width: 17.w,
                        ),
                        CustomText(
                          StringUtils.appName,
                          color: ColorUtils.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  Container(
                    height: Get.height,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: ColorUtils.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.w),
                            topLeft: Radius.circular(10.w))),
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 5.w),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.w),
                              child: Image.file(
                                File(selectedImage.path),
                                width: Get.width,
                                height: 60.w,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            SizedBox(
                              height: 60.w,
                            ),
                            CustomBtn(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible:
                                        false, // Prevents closing when tapping outside
                                    // contentPadding: EdgeInsets.all(0),
                                    builder: (context) {
                                      return Stack(
                                        children: [
                                          AlertDialog(
                                            icon: Image.asset(
                                              AssetsUtils.successIcon,
                                              width: 20.w,
                                              height: 20.w,
                                            ),
                                            title: CustomText(
                                                "Congratulations!",
                                                color: ColorUtils.purple2D,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold),
                                            content: CustomText(
                                                "Your result has been uploaded successfully.Thank you for submitting your result.",
                                                fontSize: 10.sp,
                                                textAlign: TextAlign.center),
                                            actions: const <Widget>[],
                                          ),
                                          Positioned(
                                              left: 0,
                                              right: 0,
                                              bottom: 60.w,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.to(() =>
                                                      const UploadStudentDetailsScreen());
                                                },
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              ColorUtils.redF3),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(2.w),
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: ColorUtils.white,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      );
                                    },
                                  );
                                },
                                title: StringUtils.next.tr)
                          ],
                        )),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
