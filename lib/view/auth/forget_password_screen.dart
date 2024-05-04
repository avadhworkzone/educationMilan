import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../common/common_show_toast.dart';
import '../../common/custom_btn.dart';
import '../../common/custom_text.dart';
import '../../common/custom_textstyle.dart';
import '../../utils/asset_utils.dart';
import '../../utils/color_utils.dart';
import '../../utils/no_leading_space_formatter.dart';
import '../../utils/string_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgetPasswordScreen extends StatefulWidget {
  final String? mobileNumber;
  const ForgetPasswordScreen({super.key, this.mobileNumber});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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

                                ///Forget password
                                Column(
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
                                      StringUtils.enterEmail.tr,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.04),
                                  child: TextFormField(
                                    controller: emailController,
                                    style: CustomTextStyle.textStyleInputField,
                                    keyboardType: TextInputType.text,
                                    maxLines: 1,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z0-9$_@.-]')),
                                      NoLeadingSpaceFormatter(),
                                    ],
                                    validator: (value) {
                                      if (value == null ||
                                          !isValidEmail(value)) {
                                        return StringUtils
                                            .pleaseEnterValidEmail.tr;
                                      }
                                      return null;
                                    },
                                    cursorColor: ColorUtils.grey5B,
                                    decoration: InputDecoration(
                                      // isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 16),
                                      hintText: StringUtils.enterYourEmail.tr,
                                      errorStyle: TextStyle(
                                          color: Colors.red,
                                          fontSize: 9.sp,
                                          fontFamily: AssetsUtils.poppins),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Colors.red)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: ColorUtils.purple2D,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                      disabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1),
                                      ),
                                      filled: true,
                                      fillColor: ColorUtils.greyF6,
                                      labelStyle: TextStyle(
                                          fontSize: 14.sp,
                                          color: ColorUtils.grey9C,
                                          fontWeight: FontWeight.w600),
                                      hintStyle: TextStyle(
                                        color: ColorUtils.grey9C,
                                        fontSize: 11.sp,
                                        fontFamily: AssetsUtils.poppins,
                                      ),
                                      errorMaxLines: 2,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                              ],
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
                                color: ColorUtils.white,
                                shape: BoxShape.circle),
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
                          if (_formKey.currentState!.validate()) {
                            send(
                                mobile: widget.mobileNumber.toString(),
                                emailId: emailController.text.toLowerCase());
                            ToastUtils.showCustomToast(
                                context: context,
                                title: StringUtils.requestSend.tr);

                            Get.back();
                          }
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
      ),
    );
  }

  bool isValidEmail(String value) {
    final emailRegExp = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
      caseSensitive: false,
    );
    return emailRegExp.hasMatch(value);
  }

  Future<void> send({required String mobile, required String emailId}) async {
    print("emailController.text ${emailController.text}");
    final Email email = Email(
      body:
          'Dear Authority \n I Request You to please provide my password for account details as below \n Acc. Mobile Number: $mobile \nAcc. Email Id: $emailId \n Please Revert Your Feedback.\n Thanks and Regards,',
      subject: 'Application For Forgot Password',
      recipients: ['madviseinfotech@gmail.com'],
      isHTML: false,
    );
    String platformResponse;

    // try {
    FlutterEmailSender.send(email);
    platformResponse = 'success';
    emailController.clear();
    print("platformResponse before $platformResponse");
    // } catch (error) {
    //   print(error);
    //   platformResponse = error.toString();
    //   print("platformResponse after  $platformResponse");
    // }
  }
}
