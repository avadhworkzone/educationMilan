import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:Jamanvav/common/custom_btn.dart';
import 'package:Jamanvav/common/custom_text.dart';
import 'package:Jamanvav/common/custom_textfield.dart';
import 'package:Jamanvav/utils/app_enum.dart';
import 'package:Jamanvav/utils/color_utils.dart';
import 'package:Jamanvav/utils/regular_expression.dart';
import 'package:Jamanvav/utils/string_utils.dart';
import '../../common/common_show_toast.dart';
import '../../model/apiModel/user_model.dart';
import '../../utils/loading_dialog.dart';
import '../../utils/shared_preference_utils.dart';
import '../home screen/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController familyCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final UserModel reqModel = UserModel();
  bool isLoadingDialogShown = false;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((token) {
      PreferenceManagerUtils.setIsFCM(token ?? '');
    });
  }

  Future<void> checkUserExist() async {
    if (_formKey.currentState!.validate()) {
      if (isLoadingDialogShown) return;

      final familyCode = familyCodeController.text.trim().toUpperCase();
      final phone = phoneController.text.trim();

      try {
        setState(() => isLoadingDialogShown = true);

        final familyDoc = await FirebaseFirestore.instance
            .collection('families')
            .doc(familyCode)
            .get();

        if (!familyDoc.exists) {
          ToastUtils.showCustomToast(context: context, title: 'Invalid family code');
          return;
        }

        final userRef = FirebaseFirestore.instance
            .collection('families')
            .doc(familyCode)
            .collection('users')
            .doc(phone);

        final userDoc = await userRef.get();

        if (!userDoc.exists) {
          // Auto-create the user
          await userRef.set({
            'userId': phone,
            'phoneNumber': phone,
            'familyCode': familyCode,
            'createdAt': FieldValue.serverTimestamp(),
          });

          ToastUtils.showCustomToast(
              context: context, title: 'User created successfully');
        }

        // Set preferences and go to dashboard
        PreferenceManagerUtils.setIsLogin(true);
        PreferenceManagerUtils.setPhoneNo(phone);
        PreferenceManagerUtils.setFamilyCode(familyCode);
        Get.off(() => const HomeScreen());
      } catch (e) {
        ToastUtils.showCustomToast(
          context: context,
          title: 'Something went wrong',
        );
      } finally {
        setState(() => isLoadingDialogShown = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.white,
      body: Column(
        children: [
          /// Header Logo
          Container(
            height: Get.height / 3,
            color: Colors.white,
            child: Center(
              child: Image.asset("assets/images/app_logo.png", height: 300),
            ),
          ),

          /// Login Form
          Expanded(
            child: Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 3.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 3.h),
                    CustomText(
                      StringUtils.welcome.tr,
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp,
                      color: ColorUtils.primary,
                    ),
                    SizedBox(height: 4.h),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorUtils.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: ColorUtils.grey5B,blurRadius: 20)]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText("Family Code", fontWeight: FontWeight.w600),
                                CommonTextField(
                                  textEditController: familyCodeController,
                                  hintText: 'Enter Family Code',
                                  validationType: ValidationTypeEnum.name,
                                  validationMessage: 'Family code is required',
                                  onChange: (val) => reqModel.familyCode = val,
                                  isValidate: true,
                                ),
                                SizedBox(height: 2.h),
                                CustomText(StringUtils.phoneNumber.tr, fontWeight: FontWeight.w600),
                                CommonTextField(
                                  textEditController: phoneController,
                                  regularExpression: RegularExpressionUtils.digitsPattern,
                                  keyBoardType: TextInputType.number,
                                  validationType: ValidationTypeEnum.pNumber,
                                  validationMessage: ValidationMsg.mobileNoLength,
                                  hintText: StringUtils.enterYourNumber.tr,
                                  inputLength: 10,
                                  onChange: (val) => reqModel.phoneNumber = val,
                                  isValidate: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17.w),
                      child: CustomBtn(
                        title: StringUtils.next,
                        borderColor: ColorUtils.purple2D,
                        bgColor: ColorUtils.purple2D,
                        onTap: checkUserExist,
                      ),
                    ),
                    SizedBox(height: 1.w),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
