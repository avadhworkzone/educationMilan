import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:EduPulse/model/connectivity_viewmodel.dart';
import 'package:EduPulse/utils/app_enum.dart';
import 'package:EduPulse/utils/asset_utils.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/common_show_toast.dart';
import '../../common/custom_assets.dart';
import '../../common/custom_text.dart';
import '../../model/apiModel/student_detail_model.dart';
import '../../service/student_service.dart';
import '../../utils/color_utils.dart';
import '../../utils/loading_dialog.dart';
import '../../utils/shared_preference_utils.dart';
import '../../utils/string_utils.dart';
import '../auth/sign_up_screen.dart';
import '../edit_details/student_details_screen_upload.dart';
import '../force_update/force_update_dialog.dart';
import '../studentDetailScreen/student_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var metaData;
  int? appVersion;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  ConnectivityViewModel connectivityViewModel =
      Get.find<ConnectivityViewModel>();
  bool enLng = false;
  String finalDate = '';
  bool isFinalDate = false;
  @override
  void initState() {
    setState(() {
      enLng = PreferenceManagerUtils.getIsLang();
    });
    super.initState();
    initData();
  }

  Future<void> initData() async {
    print("StringUtils.appVersion == ${StringUtils.appVersion}");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      metaData = await connectivityViewModel.getAppMetaData();

      setState(() {
        finalDate = metaData['lastDate'].toString();
        isFinalDate =
            finalDate == DateFormat('dd-MM-yyyy').format(DateTime.now());
      });

      if (Platform.isAndroid) {
        // print("metaData['androidVersion'] == $metaData");
        appVersion = int.parse(
            metaData['androidVersion'].toString().replaceAll('.', ''));
      } else if (Platform.isIOS) {
        appVersion =
            int.parse(metaData['iosVersion'].toString().replaceAll('.', ''));
      }
      if (appVersion! > int.parse(StringUtils.appVersion)) {
        updateDialog(context);
      }
      // updateDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: Drawer(
        // width: Get.width / 2,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserAccountsDrawerHeader(
                currentAccountPicture:
                    Center(child: Image.asset('assets/images/app_logo.png')),
                decoration: BoxDecoration(color: ColorUtils.primaryColor),
                accountName: CustomText(
                  'Welcome!',
                  color: ColorUtils.white,
                ),
                accountEmail: CustomText(
                  PreferenceManagerUtils.getPhoneNo() ?? "",
                  color: ColorUtils.white,
                )),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        StringUtils.lang,
                        color: ColorUtils.primaryColor,
                        fontSize: 12.sp,
                      ),
                      Container(
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
                                    color: enLng
                                        ? Colors.white
                                        : ColorUtils.primary,
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
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      commonDialog(
                        text: StringUtils.logoutTitle.tr,
                        btnNameTxt: StringUtils.logout.tr,
                        onTap: () async {
                          Get.updateLocale(const Locale('en'));

                          await signOut();
                          Get.offAll(() => const SignUpScreen());
                        },
                      );
                    },
                    child: CustomText(
                      StringUtils.logout.tr,
                      color: ColorUtils.red,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            CustomText(
              // ignore: prefer_interpolation_to_compose_strings
              'v ' + StringUtils.appV,
              color: ColorUtils.primaryColor,
              fontSize: 12.sp,
            ),
            InkWell(
              onTap: () {
                _launchUrl();
              },
              child: Text(
                StringUtils.copyRightsMadvise,
                textAlign: TextAlign.center,
                style: const TextStyle(color: ColorUtils.primaryColor),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
      backgroundColor: ColorUtils.purple2D,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        _key.currentState!.openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        color: ColorUtils.white,
                        size: 30,
                      )),
                  CustomText(
                    StringUtils.appName.tr,
                    color: ColorUtils.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    width: 30,
                  )
                  // Column(
                  //
                  //   children: [
                  //     // InkWell(
                  //     //   borderRadius: BorderRadius.circular(11),
                  //     //   onTap: () {
                  //     //     commonDialog(
                  //     //       text: StringUtils.logoutTitle.tr,
                  //     //       btnNameTxt: StringUtils.logout.tr,
                  //     //       onTap: () async {
                  //     //         Get.updateLocale(const Locale('en'));
                  //     //
                  //     //         await signOut();
                  //     //         Get.offAll(() => const SignUpScreen());
                  //     //       },
                  //     //     );
                  //     //   },
                  //     //   child: Image.asset("assets/images/logout.png",
                  //     //       height: Get.width * 0.08),
                  //     // ),
                  //     CustomText(
                  //       StringUtils.logout.tr,
                  //       color: ColorUtils.white,
                  //       fontSize: 8.sp,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
            SizedBox(
              height: 5.w,
            ),
            Expanded(
              child: Container(
                height: Get.height,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: ColorUtils.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5.w),
                        topLeft: Radius.circular(5.w))),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.w),
                          topRight: Radius.circular(10.w)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 3.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextScroll(
                              '$finalDate ${StringUtils.lastDate.tr}',
                              mode: TextScrollMode.endless,
                              numberOfReps: 200,
                              delayBefore: Duration(milliseconds: 3000),
                              pauseBetween: Duration(milliseconds: 50),
                              velocity:
                                  Velocity(pixelsPerSecond: Offset(50, 0)),
                              style: TextStyle(
                                  // decoration: TextDecoration.,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              textAlign: TextAlign.right,
                              selectable: true,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          StreamBuilder<List<StudentModel>>(
                            stream: StudentService.getAppointmentData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<StudentModel> studentList = snapshot.data!;
                                if (studentList.isEmpty) {
                                  return noDataFound();
                                }

                                String userPhoneNo =
                                    PreferenceManagerUtils.getPhoneNo();
                                List<StudentModel> filteredList = studentList
                                    .where((student) =>
                                        student.userId == userPhoneNo)
                                    .toList();

                                if (filteredList.isNotEmpty) {
                                  return Expanded(
                                    child: ListView.builder(
                                      itemCount: filteredList.length,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        StudentModel student =
                                            filteredList[index];
                                        return Column(
                                          children: [
                                            Slidable(
                                              key: ValueKey(DateTime.now()),
                                              endActionPane: ActionPane(
                                                motion: const ScrollMotion(),
                                                children: [
                                                  ///DELETE BUTTON...
                                                  GestureDetector(
                                                    onTap: () async {
                                                      commonDialog(
                                                        text: StringUtils
                                                            .deleteTitle.tr,
                                                        btnNameTxt: StringUtils
                                                            .delete.tr,
                                                        onTap: () async {
                                                          //showLoadingDialog(context: context);
                                                          Future.delayed(
                                                            const Duration(
                                                                seconds: 7),
                                                            () {},
                                                          );
                                                          final status =
                                                              await StudentService
                                                                  .deleteAccountData(
                                                                      student.studentId ??
                                                                          "");
                                                          if (status) {
                                                            // hideLoadingDialog(context: context);
                                                            Get.back();
                                                          } else {}
                                                        },
                                                      );
                                                      // final status =
                                                      //     await StudentService
                                                      //         .deleteAccountData(
                                                      //             student.studentId ??
                                                      //                 "");
                                                      // print('  STATUS :=>$status');
                                                      // if (status) {
                                                      //   // hideLoadingDialog(
                                                      //   //     context: context);
                                                      //   // Get.back();
                                                      //   ToastUtils.showCustomToast(
                                                      //       context: context,
                                                      //       title: StringUtils
                                                      //           .deleteSuccessfully);
                                                      // } else {
                                                      //   // hideLoadingDialog(
                                                      //   //     context: context);
                                                      //
                                                      //   /// SOMETHING WENT WRONG
                                                      //   ToastUtils.showCustomToast(
                                                      //       context: context,
                                                      //       title: StringUtils
                                                      //           .somethingWentWrong,
                                                      //       backgroundColor:
                                                      //           Colors.red);
                                                      // }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        width: 60,
                                                        height: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.3),
                                                              spreadRadius: 3,
                                                              blurRadius: 5,
                                                              offset: const Offset(
                                                                  0,
                                                                  3), // Offset
                                                            ),
                                                          ],
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors
                                                              .white, // Customize the background color
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: LocalAssets(
                                                            imagePath:
                                                                AssetsUtils
                                                                    .deleteIcon,
                                                            imgColor:
                                                                Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              enabled: student.documentStatus ==
                                                      DocumentStatusTypeEnum
                                                          .approve.name
                                                  ? false
                                                  : true,
                                              child: InkWell(
                                                onTap: () {
                                                  Get.to(() =>
                                                      StudentDetailsScreenUpLoad(
                                                        imageId:
                                                            filteredList[index]
                                                                .imageId
                                                                .toString(),
                                                        studentId:
                                                            filteredList[index]
                                                                .studentId
                                                                .toString(),
                                                        mobile:
                                                            filteredList[index]
                                                                .mobileNumber
                                                                .toString(),
                                                        status:
                                                            filteredList[index]
                                                                .documentStatus
                                                                .toString(),
                                                        standard:
                                                            filteredList[index]
                                                                .standard,
                                                        image:
                                                            filteredList[index]
                                                                .result,
                                                        personTage:
                                                            filteredList[index]
                                                                .percentage,
                                                        fullName: filteredList[
                                                                index]
                                                            .studentFullName,
                                                        villageName:
                                                            filteredList[index]
                                                                .villageName
                                                                .toString(),
                                                        userId:
                                                            filteredList[index]
                                                                .userId
                                                                .toString(),
                                                        createdDate:
                                                            filteredList[index]
                                                                .createdDate,
                                                      ));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      18.0),
                                                  child: Container(
                                                    width: Get.width,
                                                    decoration: BoxDecoration(
                                                      color: ColorUtils.greyF6,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: SizedBox(
                                                            width: 90,
                                                            height: 100,
                                                            child: student
                                                                        .result !=
                                                                    null
                                                                ? Image.network(
                                                                    student
                                                                        .result
                                                                        .toString(),
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    loadingBuilder: (BuildContext
                                                                            context,
                                                                        Widget
                                                                            child,
                                                                        ImageChunkEvent?
                                                                            loadingProgress) {
                                                                      if (loadingProgress ==
                                                                          null) {
                                                                        return child;
                                                                      } else {
                                                                        return const Center(
                                                                          child:
                                                                              CircularProgressIndicator(color: ColorUtils.primaryColor),
                                                                        );
                                                                      }
                                                                    },
                                                                  )
                                                                : const Center(
                                                                    child: CircularProgressIndicator(
                                                                        color: ColorUtils
                                                                            .primaryColor),
                                                                  ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              Get.width * 0.02,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CustomText(
                                                                student
                                                                    .studentFullName
                                                                    .toString(),
                                                                color: ColorUtils
                                                                    .black32,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  CustomText(
                                                                    "${StringUtils.standard.tr} : ",
                                                                    color: ColorUtils
                                                                        .greyB5,
                                                                    fontSize:
                                                                        10.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                  CustomText(
                                                                    student
                                                                        .standard
                                                                        .toString(),
                                                                    color: ColorUtils
                                                                        .black32,
                                                                    fontSize:
                                                                        10.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  CustomText(
                                                                    "${StringUtils.percentage.tr} : ",
                                                                    color: ColorUtils
                                                                        .greyB5,
                                                                    fontSize:
                                                                        10.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                  CustomText(
                                                                    "${student.percentage}%",
                                                                    color: ColorUtils
                                                                        .black32,
                                                                    fontSize:
                                                                        10.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ],
                                                              ),

                                                              ///STATUS FOR DOCUMENT.....
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  CustomText(
                                                                    "Status : ",
                                                                    color: ColorUtils
                                                                        .greyB5,
                                                                    fontSize:
                                                                        10.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                  student.documentStatus !=
                                                                          null
                                                                      ? student.documentStatus ==
                                                                              DocumentStatusTypeEnum.approve.name
                                                                          ? Text(
                                                                              "Approved",
                                                                              style: TextStyle(
                                                                                color: Colors.green,
                                                                                fontSize: 10.sp,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            )
                                                                          : student.documentStatus == DocumentStatusTypeEnum.delete.name
                                                                              ? Text(
                                                                                  "Reject",
                                                                                  style: TextStyle(
                                                                                    color: ColorUtils.red,
                                                                                    fontSize: 10.sp,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                )
                                                                              : Text(
                                                                                  "Pending",
                                                                                  style: TextStyle(
                                                                                    color: ColorUtils.black32,
                                                                                    fontSize: 10.sp,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                )
                                                                      : Text(
                                                                          "Pending",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                ColorUtils.black32,
                                                                            fontSize:
                                                                                10.sp,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),

                                                              SizedBox(
                                                                height: 0.8.h,
                                                              ),
                                                              if (student
                                                                      .documentStatus ==
                                                                  DocumentStatusTypeEnum
                                                                      .delete
                                                                      .name)
                                                                InkWell(
                                                                  onTap: () {
                                                                    showModalBottomSheet(
                                                                      context:
                                                                          context,
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      useSafeArea:
                                                                          true,
                                                                      builder:
                                                                          (context) {
                                                                        return SafeArea(
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                                                                            child:
                                                                                Container(
                                                                              decoration: const BoxDecoration(
                                                                                color: Colors.white,
                                                                              ),
                                                                              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                                                              child: SingleChildScrollView(
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        CustomText(
                                                                                          StringUtils.reasonForReject.tr,
                                                                                          fontSize: 14.sp,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                        IconButton(
                                                                                          onPressed: () {
                                                                                            Get.back();
                                                                                          },
                                                                                          icon: const Icon(Icons.clear),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    const Divider(),
                                                                                    CustomText(student.documentReason!.tr ?? ''),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  child:
                                                                      CustomText(
                                                                    StringUtils
                                                                        .viewReason
                                                                        .tr,
                                                                    fontSize:
                                                                        10.sp,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                  ),
                                                                ),
                                                              SizedBox(
                                                                height: 1.h,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (filteredList[index] ==
                                                filteredList.last)
                                              const SizedBox(
                                                height: 55,
                                              )
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return noDataFound();
                                }
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 18.h,
                                    ),
                                    const Center(
                                      child: CircularProgressIndicator(
                                          color: ColorUtils.primaryColor),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    // Positioned(
                    //     left: 0,
                    //     right: 0,
                    //     bottom: 0,
                    //     child: Align(
                    //       alignment: Alignment.center,
                    //       child: Text(StringUtils.copyRightsMadvise),
                    //     )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            StringUtils.copyRightsMadvise,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
      floatingActionButton: isFinalDate
          ? SizedBox()
          : FloatingActionButton(
              backgroundColor: ColorUtils.purple2D,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Icon(
                Icons.add,
                color: ColorUtils.white,
                size: 5.h,
              ),
              onPressed: () {
                Get.to(() => const StudentDetailScreen());
              }),
    );
  }

  commonDialog(
      {required String text,
      required String btnNameTxt,
      required void Function()? onTap}) {
    showDialog(
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.06, vertical: Get.height * 0.02),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/alert.png", width: Get.width * 0.07),
                SizedBox(height: 2.h),
                CustomText(
                  text,
                  // StringUtils.logoutTitle,
                  color: ColorUtils.greyA7,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: ColorUtils.greyA7)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Get.height * 0.005,
                              horizontal: Get.width * 0.04),
                          child: CustomText(
                            StringUtils.cancel.tr,
                            color: ColorUtils.greyA7,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                    InkWell(
                      onTap: onTap,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: ColorUtils.redF3),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Get.height * 0.005,
                              horizontal: Get.width * 0.04),
                          child: CustomText(
                            btnNameTxt,
                            // StringUtils.logout,
                            color: ColorUtils.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
      context: context,
    );
  }

  // commonDialog() {
  //   showDialog(
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(
  //             Radius.circular(5.0),
  //           ),
  //         ),
  //         child: Padding(
  //           padding: EdgeInsets.symmetric(
  //               horizontal: Get.width * 0.04, vertical: Get.height * 0.02),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               Image.asset("assets/images/alert.png", width: Get.width * 0.07),
  //               SizedBox(
  //                 height: Get.height * 0.02,
  //               ),
  //               CustomText(
  //                 StringUtils.logoutTitle,
  //                 color: ColorUtils.black32,
  //                 fontSize: 13.sp,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //               SizedBox(
  //                 height: Get.height * 0.04,
  //               ),
  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   InkWell(
  //                     onTap: () {
  //                       Get.back();
  //                     },
  //                     child: Padding(
  //                       padding: EdgeInsets.symmetric(
  //                           vertical: Get.height * 0.005,
  //                           horizontal: Get.width * 0.04),
  //                       child: CustomText(
  //                         StringUtils.cancel,
  //                         color: ColorUtils.greyA7,
  //                         fontSize: 12.sp,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: Get.width * 0.02,
  //                   ),
  //                   InkWell(
  //                     onTap: () async {
  //                       await signOut();
  //                       Get.offAll(() => const SignUpScreen());
  //                     },
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(20),
  //                           color: ColorUtils.redF3),
  //                       child: Padding(
  //                         padding: EdgeInsets.symmetric(
  //                             vertical: Get.height * 0.005,
  //                             horizontal: Get.width * 0.04),
  //                         child: CustomText(
  //                           StringUtils.logout,
  //                           color: ColorUtils.white,
  //                           fontSize: 10.sp,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //     context: context,
  //   );
  // }

  Future<void> signOut() async {
    try {
      showLoadingDialog(context: context);
      await FirebaseAuth.instance.signOut();
      await PreferenceManagerUtils.clearPreference();
      print("User signed out");
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse('https://www.madviseinfotech.com/'))) {
      throw Exception('Could not launch');
    }
  }

  Widget noDataFound() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 18.h,
          ),
          Image.asset(
            AssetsUtils.fileUpload,
            height: 27.h,
          ),
          SizedBox(
            height: 2.h,
          ),
          CustomText(StringUtils.noResult.tr),
        ],
      ),
    );
  }
}

// if (status) {
// // hideLoadingDialog(
// //     context: context);
// // Get.back();
// ToastUtils.showCustomToast(
// context: context,
// title: StringUtils
//     .deleteSuccessfully);
// } else {
// // hideLoadingDialog(
// //     context: context);
//
// /// SOMETHING WENT WRONG
// ToastUtils.showCustomToast(
// context: context,
// title: StringUtils
//     .somethingWentWrong,
// backgroundColor:
// Colors.red);
// }
