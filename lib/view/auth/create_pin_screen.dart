import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import 'package:Jamanvav/service/auth_service.dart';
import 'package:Jamanvav/utils/loading_dialog.dart';

import '../../common/common_show_toast.dart';
import '../../common/custom_btn.dart';
import '../../common/custom_text.dart';

import '../../common/custom_textstyle.dart';
import '../../model/apiModel/user_model.dart';

import '../../utils/asset_utils.dart';
import '../../utils/color_utils.dart';
import '../../utils/shared_preference_utils.dart';
import '../../utils/string_utils.dart';
import '../home screen/home_screen.dart';

class CreatePinScreen extends StatefulWidget {
  final String? mobileNumber;
  const CreatePinScreen({super.key, this.mobileNumber});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final TextEditingController pinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();

  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  UserModel reqModel = UserModel();

  FirebaseAuth auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: CustomTextStyle.textStyleInputField,
    decoration: BoxDecoration(
      color: ColorUtils.greyF6,
      border: Border.all(color: Colors.transparent),
      borderRadius: BorderRadius.circular(12),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: Get.width,
              height: Get.height,
              decoration: const BoxDecoration(
                  color: ColorUtils.purple2D,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        "assets/images/signUpImage.png",
                      ))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 9.h,
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: Get.width,
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                            color: ColorUtils.white,
                            borderRadius: BorderRadius.circular(6.w)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.h,
                          ),
                          child:

                              ///User Details
                              Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 8.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.h),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: CustomText(
                                      StringUtils.createPin,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Pinput(
                                  disabledPinTheme: PinTheme(
                                    width: 15.h,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  errorText: 'Please Enter Your pin',
                                  defaultPinTheme: defaultPinTheme,
                                  errorPinTheme: defaultPinTheme.copyWith(
                                      decoration:
                                          defaultPinTheme.decoration!.copyWith(
                                              border: Border.all(
                                    color: ColorUtils.red,
                                  ))),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter Otp';
                                    } else if (value.length != 4) {
                                      return 'OTP must be 4 digits';
                                    }

                                    return null;
                                  },
                                  // errorPinTheme: PinTheme(
                                  //     textStyle:
                                  //         TextStyle(color: ColorUtils.red),
                                  //     decoration: BoxDecoration(
                                  //         border:
                                  //             Border.all(color: Colors.red))),
                                  closeKeyboardWhenCompleted: true,
                                  length: 4,
                                  controller: pinController,
                                  onChanged: (value) {
                                    reqModel.userPin = value;
                                  },
                                  pinputAutovalidateMode:
                                      PinputAutovalidateMode.onSubmit,
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.h),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: CustomText(
                                      StringUtils.confirmPin,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Pinput(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter Confirm Pin';
                                    } else if (value.length != 4) {
                                      return 'OTP must be 4 digits';
                                    }
                                    if (value != pinController.text) {
                                      return 'PIN does not match';
                                    }
                                    return null;
                                  },
                                  defaultPinTheme: defaultPinTheme,
                                  errorPinTheme: defaultPinTheme.copyWith(
                                      decoration:
                                          defaultPinTheme.decoration!.copyWith(
                                              border: Border.all(
                                    color: ColorUtils.red,
                                  ))),
                                  closeKeyboardWhenCompleted: true,
                                  length: 4,
                                  controller: confirmPinController,
                                  onChanged: (value) {
                                    reqModel.userPin = value;
                                  },
                                  pinputAutovalidateMode:
                                      PinputAutovalidateMode.onSubmit,
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// container's logo
                      Positioned(
                        left: 0,
                        right: 0,
                        top: -35,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Padding(
                            padding: EdgeInsets.all(2.w),
                            child: SvgPicture.asset(
                              AssetsUtils.splashLogo,
                              height: 15.w,
                              width: 15.w,
                            ),
                          ),
                        ),
                      ),
                      // Positioned(
                      //     left: 0,
                      //     right: 0,
                      //      bottom:-260,
                      //     child: Align(
                      //       alignment: Alignment.center,
                      //       child: Text(StringUtils.copyRightsMadvise),
                      //     )),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),

                  /// SIGN UP Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17.w),
                    child: CustomBtn(
                      onTap: () async {
                        addSighUpInfo();
                      },
                      title: StringUtils.next,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Color(0xffe8f1ee),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            StringUtils.copyRightsMadvise,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  addSighUpInfo() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      showLoadingDialog(context: context);
      Map<String, dynamic> user = {
        "PhoneNo": widget.mobileNumber,
        "Pin": pinController.text
      };
      final status =
          await AuthService.signUp(user, widget.mobileNumber.toString());
      if (status) {
        hideLoadingDialog(context: context);
        PreferenceManagerUtils.setIsLogin(true);
        PreferenceManagerUtils.setPhoneNo(widget.mobileNumber.toString());
        Get.off(() => const HomeScreen());
        ToastUtils.showCustomToast(
            context: context, title: StringUtils.signupSuccessfully.tr);
      } else {
        hideLoadingDialog(context: context);
        ToastUtils.showCustomToast(
            context: context, title: StringUtils.somethingWentWrong.tr);
      }
    }
  }
}
