import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import 'package:EduPulse/common/custom_btn.dart';
import 'package:EduPulse/common/custom_text.dart';
import 'package:EduPulse/common/custom_textfield.dart';
import 'package:EduPulse/utils/app_enum.dart';
import 'package:EduPulse/utils/asset_utils.dart';
import 'package:EduPulse/utils/color_utils.dart';
import 'package:EduPulse/utils/regular_expression.dart';
import 'package:EduPulse/utils/string_utils.dart';
import '../../common/common_show_toast.dart';
import '../../common/custom_textstyle.dart';
import '../../model/apiModel/user_model.dart';
import '../../service/auth_service.dart';
import '../../utils/loading_dialog.dart';
import '../../utils/shared_preference_utils.dart';
import '../home screen/home_screen.dart';
import 'create_pin_screen.dart';
import 'forget_password_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _pinController = TextEditingController();
  final phoneController = TextEditingController();
  bool alreadyAccount = false;
  final _formKey = GlobalKey<FormState>();
  final _pinFormKey = GlobalKey<FormState>();
  UserModel reqModel = UserModel();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool enLng = true;
  // RxBool isLoading = false.obs;
  bool isLoadingDialogShown = false;
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
  void initState() {
    setState(() {
      enLng = PreferenceManagerUtils.getIsLang();
      print('enLng---->$enLng');
    });
    deviceToken();
    // TODO: implement initState
    super.initState();
  }

  Future<String?> deviceToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print('fcm--$fcmToken');
    PreferenceManagerUtils.setIsFCM(fcmToken ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffE8F1EE),
      backgroundColor: ColorUtils.white,
      body: Column(
        children: [
          ///old content
          // Container(
          //   width: Get.width,
          //   height: Get.height,
          //   decoration: const BoxDecoration(
          //       color: ColorUtils.purple2D,
          //       image: DecorationImage(
          //           fit: BoxFit.cover,
          //           image: AssetImage(
          //             "assets/images/signUpImage.png",
          //           ))),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       SizedBox(
          //         height: 10.h,
          //       ),
          //       Stack(
          //         clipBehavior: Clip.none,
          //         children: [
          //           Container(
          //             width: Get.width,
          //             margin: EdgeInsets.symmetric(horizontal: 8.w),
          //             decoration: BoxDecoration(
          //                 color: ColorUtils.white,
          //                 borderRadius: BorderRadius.circular(6.w)),
          //             child: Padding(
          //               padding: EdgeInsets.symmetric(
          //                 horizontal: 3.h,
          //               ),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   SizedBox(
          //                     height: 5.h,
          //                   ),
          //                   Center(
          //                     child: CustomText(
          //                       StringUtils.welcome,
          //                       fontWeight: FontWeight.w600,
          //                       fontSize: 16.sp,
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     height: 4.h,
          //                   ),
          //
          //                   ///User Details
          //                   Form(
          //                     key: _formKey,
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         CustomText(
          //                           StringUtils.phoneNumber,
          //                           fontWeight: FontWeight.w600,
          //                         ),
          //                         SizedBox(
          //                           height: 1.w,
          //                         ),
          //
          //                         /// phone field
          //                         CommonTextField(
          //                           textEditController: phoneController,
          //                           regularExpression:
          //                               RegularExpressionUtils.digitsPattern,
          //                           keyBoardType: TextInputType.number,
          //                           validationType: ValidationTypeEnum.pNumber,
          //                           validationMessage:
          //                               ValidationMsg.mobileNoLength,
          //                           hintText: StringUtils.enterYourNumber,
          //                           inputLength: 10,
          //                           onChange: (value) {
          //                             reqModel.phoneNumber = value;
          //                           },
          //                           isValidate: true,
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     height: 2.h,
          //                   ),
          //                   if (alreadyAccount == true)
          //                     Column(
          //                       children: [
          //                         Center(
          //                           child: CustomText(
          //                             StringUtils.addPin,
          //                             fontWeight: FontWeight.w600,
          //                           ),
          //                         ),
          //                         SizedBox(
          //                           height: 1.h,
          //                         ),
          //                         Form(
          //                           key: _pinFormKey,
          //                           child: Pinput(
          //                             defaultPinTheme: defaultPinTheme,
          //                             length: 4,
          //                             controller: _pinController,
          //                             onChanged: (value) {
          //                               reqModel.userPin = value;
          //                             },
          //                             keyboardType: TextInputType.number,
          //                           ),
          //                         ),
          //                         SizedBox(
          //                           height: 2.h,
          //                         ),
          //                         InkWell(
          //                           onTap: () {
          //                             Get.offAll(() => ForgetPasswordScreen(
          //                                   mobileNumber: phoneController.text,
          //                                 ));
          //                           },
          //                           child: Align(
          //                             alignment: Alignment.topRight,
          //                             child: CustomText(
          //                               StringUtils.forgetPin,
          //                               fontWeight: FontWeight.w500,
          //                               color: ColorUtils.red,
          //                               fontSize: 9.sp,
          //                             ),
          //                           ),
          //                         ),
          //                         SizedBox(
          //                           height: 2.h,
          //                         ),
          //                       ],
          //                     )
          //                 ],
          //               ),
          //             ),
          //           ),
          //
          //           /// container's logo
          //           Positioned(
          //             left: 0,
          //             right: 0,
          //             top: -35,
          //             child: Container(
          //               decoration: const BoxDecoration(
          //                   color: Colors.white, shape: BoxShape.circle),
          //               child: Padding(
          //                 padding: EdgeInsets.all(2.w),
          //                 child: SvgPicture.asset(
          //                   AssetsUtils.splashLogo,
          //                   height: 15.w,
          //                   width: 15.w,
          //                 ),
          //               ),
          //             ),
          //           ),
          //           // Positioned(
          //           //     left: 0,
          //           //     right: 0,
          //           //     // top: 460,
          //           //     bottom:-300,
          //           //     child: Align(
          //           //       alignment: Alignment.center,
          //           //       child: Text(StringUtils.copyRightsMadvise),
          //           //     )),
          //         ],
          //       ),
          //       SizedBox(
          //         height: 8.h,
          //       ),
          //
          //       /// SIGN UP Button
          //       Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 17.w),
          //         child: CustomBtn(
          //           borderColor: ColorUtils.purple2D,
          //           bgColor: ColorUtils.purple2D,
          //           onTap: () async {
          //             checkUserExist();
          //           },
          //           title: StringUtils.next,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          ///top container
          Container(
            width: Get.width,
            height: Get.height / 3,
            // margin: EdgeInsets.only(bottom: 50),
            color: Color(0xff2E2694),
            // color: ColorUtils.primary,
            child: Stack(
              children: [
                Positioned(
                  right: 10,
                  top: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              enLng = false;
                              Get.updateLocale(const Locale('gu'));
                              PreferenceManagerUtils.setIsLang(false);
                              setState(() {});
                            },
                            child: Container(
                              // height: 30,
                              // width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    enLng ? Colors.white : ColorUtils.primary,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: CustomText(
                                    'ગુજ',
                                    color: enLng
                                        ? ColorUtils.primary
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              enLng = true;
                              Get.updateLocale(Locale('en'));
                              PreferenceManagerUtils.setIsLang(true);
                              setState(() {});
                            },
                            child: Container(
                              // height: 30,
                              // width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: !enLng
                                    ? ColorUtils.white
                                    : ColorUtils.primary,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: CustomText(
                                    'EN',
                                    color: enLng
                                        ? ColorUtils.white
                                        : ColorUtils.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: Image.asset(
                      "assets/images/app_logo.png",
                      height: 200,
                    ),
                  ),
                ),

                // /// container's logo
                // Positioned(
                //   bottom: 0,
                //   right: 0,
                //   left: 0,
                //   child: Container(
                //     decoration: const BoxDecoration(
                //         color: Colors.white, shape: BoxShape.circle),
                //     child: Padding(
                //       padding: EdgeInsets.all(2.w),
                //       child: SvgPicture.asset(
                //         AssetsUtils.splashLogo,
                //         height: 15.w,
                //         width: 15.w,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

          ///bottom view
          Expanded(
            child: Container(
              width: Get.width,
              color: ColorUtils.white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.h,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 3.h,
                      ),
                      Center(
                        child: CustomText(
                          StringUtils.welcome.tr,
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp,
                          color: ColorUtils.primary,
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),

                      ///User Details
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorUtils.white,
                            border: Border.all(
                                color: ColorUtils.primary, width: 2)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  StringUtils.phoneNumber.tr,
                                  fontWeight: FontWeight.w600,
                                ),
                                SizedBox(
                                  height: 1.w,
                                ),

                                /// phone field
                                CommonTextField(
                                  textEditController: phoneController,
                                  regularExpression:
                                      RegularExpressionUtils.digitsPattern,
                                  keyBoardType: TextInputType.number,
                                  validationType: ValidationTypeEnum.pNumber,
                                  validationMessage:
                                      ValidationMsg.mobileNoLength,
                                  hintText: StringUtils.enterYourNumber.tr,
                                  inputLength: 10,
                                  onChange: (value) {
                                    reqModel.phoneNumber = value;
                                  },
                                  isValidate: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      if (alreadyAccount == true)
                        Column(
                          children: [
                            Center(
                              child: CustomText(
                                StringUtils.addPin,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Form(
                              key: _pinFormKey,
                              child: Pinput(
                                defaultPinTheme: defaultPinTheme,
                                length: 4,
                                controller: _pinController,
                                onChanged: (value) {
                                  reqModel.userPin = value;
                                },
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => ForgetPasswordScreen(
                                      mobileNumber: phoneController.text,
                                    ));
                              },
                              child: Align(
                                alignment: Alignment.topRight,
                                child: CustomText(
                                  StringUtils.forgetPin,
                                  fontWeight: FontWeight.w500,
                                  color: ColorUtils.red,
                                  fontSize: 9.sp,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 17.w),
                        child: CustomBtn(
                          borderColor: ColorUtils.purple2D,
                          bgColor: ColorUtils.purple2D,
                          onTap: () async {
                            checkUserExist();
                          },
                          title: StringUtils.next,
                        ),
                      ),
                      SizedBox(
                        height: 1.w,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        // color: Color(0xffe8f1ee),
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

  // checkUserExist() async {
  //   if (_formKey.currentState!.validate()) {
  //     showLoadingDialog(context: context);
  //
  //     final checkUserExistStatus =
  //         await AuthService.checkUserExist(docId: phoneController.text);
  //     if (checkUserExistStatus) {
  //       if (alreadyAccount == true) {
  //         if (_pinFormKey.currentState!.validate()) {
  //           if (_pinController.length != 4) {
  //             ToastUtils.showCustomToast(
  //                 context: context, title: StringUtils.pleaseEnterPin);
  //             hideLoadingDialog(context: context);
  //           } else {
  //             showLoadingDialog(context: context);
  //
  //             bool checkUserExistStatus = await AuthService.checkLogin(
  //                 docId: phoneController.text, pin: _pinController.text);
  //
  //             if (checkUserExistStatus) {
  //               /// LOADING FALSE
  //               hideLoadingDialog(context: context);
  //               PreferenceManagerUtils.setIsLogin(true);
  //               PreferenceManagerUtils.setPhoneNo(phoneController.text);
  //               Get.to(() => const HomeScreen());
  //             } else {
  //               hideLoadingDialog(context: context);
  //               ToastUtils.showCustomToast(
  //                   context: context, title: StringUtils.invalidPin);
  //               Get.back();
  //             }
  //           }
  //         }
  //       } else {
  //         hideLoadingDialog(context: context);
  //         setState(() {
  //           alreadyAccount = true;
  //         });
  //       }
  //
  //       /// LOADING FALSE
  //     } else {
  //       hideLoadingDialog(context: context);
  //
  //       Get.to(() => CreatePinScreen(
  //             mobileNumber: phoneController.text,
  //           ));
  //     }
  //   }
  // }
  Future<void> checkUserExist() async {
    if (_formKey.currentState!.validate()) {
      if (isLoadingDialogShown) {
        return; // Avoid starting another request while the previous one is still loading
      }

      try {
        setState(() {
          isLoadingDialogShown = true;
        });

        final checkUserExistStatus =
            await AuthService.checkUserExist(docId: phoneController.text);

        if (checkUserExistStatus) {
          if (alreadyAccount == true) {
            if (_pinFormKey.currentState!.validate()) {
              if (_pinController.text.length != 4) {
                ToastUtils.showCustomToast(
                    context: context, title: StringUtils.pleaseEnterPin.tr);
              } else {
                showLoadingDialog(context: context);

                bool checkUserExistStatus = await AuthService.checkLogin(
                    docId: phoneController.text, pin: _pinController.text);

                if (checkUserExistStatus) {
                  // LOADING FALSE
                  hideLoadingDialog(context: context);
                  PreferenceManagerUtils.setIsLogin(true);
                  PreferenceManagerUtils.setPhoneNo(phoneController.text);
                  Get.off(() => const HomeScreen());
                } else {
                  hideLoadingDialog(context: context);
                  ToastUtils.showCustomToast(
                      context: context, title: StringUtils.invalidPin.tr);
                  Get.back();
                }
              }
            }
          } else {
            setState(() {
              alreadyAccount = true;
            });
          }
        } else {
          Get.to(() => CreatePinScreen(
                mobileNumber: phoneController.text,
              ));
        }
      } finally {
        setState(() {
          isLoadingDialogShown = false;
        });
      }
    }
  }
}
