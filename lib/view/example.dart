// import 'dart:convert';
// import 'dart:math';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
// import 'package:Jamanvav/common/custom_btn.dart';
// import 'package:Jamanvav/common/custom_text.dart';
// import 'package:Jamanvav/common/custom_textfield.dart';
// import 'package:Jamanvav/common/exit_confirmtion_dialog.dart';
// import 'package:Jamanvav/utils/app_enum.dart';
// import 'package:Jamanvav/utils/asset_utils.dart';
// import 'package:Jamanvav/utils/color_utils.dart';
// import 'package:Jamanvav/utils/regular_expression.dart';
// import 'package:Jamanvav/utils/shared_preference_utils.dart';
// import 'package:Jamanvav/utils/string_utils.dart';
// import 'package:Jamanvav/view/example.dart';
// import 'package:Jamanvav/view/studentDetailScreen/student_detail_screen.dart';
// import 'package:Jamanvav/viewmodel/auth_viewmodel.dart';
//
// import '../../common/common_show_toast.dart';
// import '../../model/apiModel/user_model.dart';
//
// class ContainerScreen extends StatefulWidget {
//   const ContainerScreen({super.key});
//
//   @override
//   State<ContainerScreen> createState() => _ContainerScreenState();
// }
//
// class _ContainerScreenState extends State<ContainerScreen> {
//   final nameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   UserModel reqModel = UserModel();
//
//   FirebaseAuth auth = FirebaseAuth.instance;
//   RxBool isLoading = false.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Example Screen'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               width: Get.width,
//               height: Get.height,
//               decoration: const BoxDecoration(
//                   color: ColorUtils.purple2D,
//                   image: DecorationImage(
//                       fit: BoxFit.cover,
//                       image: AssetImage(
//                         "assets/images/signUpImage.png",
//                       )
//                   )
//               ),
//               child:   Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 1.h,),
//                   Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       Container(
//                         height: 26.h,
//                         width: Get.width,
//                         margin: EdgeInsets.symmetric(horizontal: 8.w),
//                         decoration: BoxDecoration(
//                             color: ColorUtils.white,
//                             borderRadius: BorderRadius.circular(6.w)),
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 3.h,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                 height: 5.h,
//                               ),
//                               Center(
//                                 child: CustomText(
//                                   StringUtils.welcome,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 16.sp,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 4.h,
//                               ),
//
//                               ///User Details
//                               Form(
//                                 key: _formKey,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//
//                                     CustomText(
//                                       StringUtils.phoneNumber,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                     SizedBox(
//                                       height: 1.w,
//                                     ),
//                                     /// phone field
//                                     CommonTextField(
//                                       textEditController: phoneController,
//                                       regularExpression:
//                                       RegularExpressionUtils.digitsPattern,
//                                       keyBoardType: TextInputType.number,
//                                       validationType: ValidationTypeEnum.pNumber,
//                                       validationMessage: ValidationMsg.mobileNoLength,
//                                       hintText: StringUtils.enterYourNumber,
//                                       inputLength: 10,
//                                       onChange: (value){
//                                         reqModel.phoneNumber = value;
//                                       },
//                                       isValidate: true,
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       /// container's logo
//                       Positioned(
//                         left: 0,
//                         right: 0,
//                         top: -35,
//                         child: Container(
//                           decoration: const BoxDecoration(
//                               color: Colors.white, shape: BoxShape.circle),
//                           child: Padding(
//                             padding: EdgeInsets.all(2.w),
//                             child: SvgPicture.asset(
//                               AssetsUtils.splashLogo,
//                               height: 15.w,
//                               width: 15.w,
//                             ),
//                           ),
//                         ),
//                       ),
//
//
//                       // Positioned(
//                       //   left: 0,
//                       //   right: 0,
//                       //   top: 95.w,
//                       //   // bottom: 40.w,
//                       //   child: Padding(
//                       //     padding: EdgeInsets.symmetric(horizontal: 17.w),
//                       //     child: CustomBtn(
//                       //       onTap: () {
//                       //         if (_formKey.currentState!.validate()) {
//                       //           print("=========TAPTHEBUTTON=============");
//                       //           Get.to(() => const StudentDetailScreen());
//                       //         }
//                       //       },
//                       //       title: StringUtils.signUp,
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                   SizedBox(height: 8.h,),
//                   /// SIGN UP Button
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 17.w),
//                     child: CustomBtn(
//                       onTap: () {
//                         if(_formKey.currentState!.validate()){
//                           reqModel.phoneNumber = phoneController.text.trim();
//                           reqModel.userId = phoneController.text.trim();
//                           storeUserDataInFirestore(reqModel);
//                           // Get.to(()=> ContainerScreen());
//                         }
//                       },
//                       title: StringUtils.signUp,
//                     ),
//                   ),
//                   SizedBox(height: 4.h,),
//           InkWell(
//             onTap: () {
//               if (_height == 200) {
//                 setState(() {
//                   _height = 100.0;
//                 });
//               } else {
//                 _updateState();
//               }
//             },
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 550),
//               height: _height,
//               width: Get.width,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     spreadRadius: 2,
//                     blurRadius: 10,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text("0.0"),
//                   Text("0.0"),
//                   //Widget1(),
//                   //Widget2(),
//                   //Widget3(),
//                 ],
//               ),
//             ),
//           ),
//
//                 ],
//               ),
//               // height: 200,
//               // child: Padding(
//               //   padding: EdgeInsets.symmetric(
//               //     vertical: 5.w,
//               //   ),
//               //   child: Image.asset(
//               //     AssetsUtils.signInLogo, height: 230, width: 150,
//               //     // scale: 1.4,
//               //   ),
//               // ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   void storeUserDataInFirestore(UserModel model) async {
//     try {
//
//
//       // Convert the UserModel to a Map for Firestore
//       final Map<String, dynamic> userDataMap = model.toJson();
//
//       // Store user data in the 'users' collection
//       final docResult = await FirebaseFirestore.instance
//           .collection('UserDetails')
//           .doc(reqModel.phoneNumber)
//           .get();
//       if(docResult.exists){
//         ToastUtils.showCustomToast(
//             context: context,
//             title: StringUtils.alreadyExist);
//       }
//       isLoading.value = true;
//       auth.signInWithPhoneNumber(reqModel.phoneNumber!).then((value) {
//         FirebaseFirestore.instance
//             .collection('UserDetails')
//             .doc(reqModel.phoneNumber)
//             .set(reqModel.toJson())
//             .then((value) {
//           isLoading.value = false;
//
//           ToastUtils.showCustomToast(
//               context: context,
//               title: StringUtils.signupDone);
//
//           final authViewModel1 = Get.find<AuthViewModel>();
//           authViewModel1.setUserModel(reqModel);
//           PreferenceManagerUtils.setUserData(jsonEncode(reqModel.toJson()));
//           Get.to(() => StudentDetailScreen());
//
//         });
//       });
//
//
//
//       // Show success message or perform any other action upon successful data storage
//       print('==================User data stored in Firestore!');
//     } catch (error) {
//       // Handle errors or show error message
//       isLoading.value = false;
//       print('============Failed to store user data: $error');
//     }
//   }
//
// // Future<void> onTap(BuildContext context) async {
// //   if(_formKey.currentState!.validate()){
// //     final docResult = await FirebaseFirestore.instance
// //         .collection('UserDetails')
// //         .doc(reqModel.phoneNumber)
// //         .get();
// //     if(docResult.exists){
// //       ToastUtils.showCustomToast(
// //           context: context,
// //           title: StringUtils.alreadyExist);
// //     }
// //
// //
// //     auth.signInWithPhoneNumber(reqModel.phoneNumber!).then((value) {
// //       FirebaseFirestore.instance
// //           .collection('UserDetails')
// //           .doc(reqModel.phoneNumber)
// //           .set(reqModel.toJson())
// //           .then((value) {
// //
// //
// //         final authViewModel1 = Get.find<AuthViewModel>();
// //         authViewModel1.setUserModel(reqModel);
// //         PreferenceManagerUtils.setUserData(jsonEncode(reqModel.toJson()));
// //         ToastUtils.showCustomToast(
// //             context: context,
// //             title: StringUtils.signupDone);
// //        Get.to(() => StudentDetailScreen());
// //       }).catchError((e){
// //         isLoading.value = false;
// //         // ToastUtils.showCustomToast(
// //         //     context: context,
// //         //     title: 'Something went wrong..');
// //       });
// //     }).catchError((e) {
// //
// //
// //       // ToastUtils.showCustomToast(
// //       //     context: context,
// //       //     title: 'Something went wrong..');
// //     });
// //   }
// // }
// }
