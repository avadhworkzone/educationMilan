import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:Jamanvav/common/custom_text.dart';
import 'package:Jamanvav/utils/asset_utils.dart';
import 'package:Jamanvav/utils/shared_preference_utils.dart';
import 'package:Jamanvav/utils/string_utils.dart';
import 'package:Jamanvav/view/auth/sign_up_screen.dart';
import 'package:Jamanvav/view/home%20screen/home_screen.dart';

import '../../utils/color_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      PreferenceManagerUtils.getIsLogin() == true
          ? Get.offAll(() => const HomeScreen())
          : Get.offAll(() => const SignUpScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Image.asset(
        "assets/images/app_logo.png",
        width: Get.width,
        height: Get.height,
        // fit: BoxFit.fitHeight,
      ),
    );
  }
}
