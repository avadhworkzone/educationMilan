import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:Jamanvav/common/custom_text.dart';
import 'package:Jamanvav/utils/string_utils.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/alert.png", width: Get.width * 0.07),
            SizedBox(
              height: 2.h,
            ),
            CustomText("This app under maintenance",
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp),
            SizedBox(
              height: 3.h,
            ),
            Image.asset("assets/images/maintance_image.png",
                width: Get.width * 0.4),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Text(
          StringUtils.copyRightsMadvise,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
