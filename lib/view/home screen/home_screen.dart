import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/common_dialog.dart';
import '../../common/common_show_toast.dart';
import '../../common/custom_assets.dart';
import '../../common/custom_text.dart';
import '../../model/apiModel/student_detail_model.dart';
import '../../model/connectivity_viewmodel.dart';
import '../../service/student_service.dart';
import '../../utils/app_enum.dart';
import '../../utils/asset_utils.dart';
import '../../utils/color_utils.dart';
import '../../utils/loading_dialog.dart';
import '../../utils/shared_preference_utils.dart';
import '../../utils/string_utils.dart';
import '../auth/sign_up_screen.dart';
import '../force_update/force_update_dialog.dart';
import '../studentDetailScreen/edit_student_result_screen.dart';
import '../studentDetailScreen/create_student_result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  var metaData;
  int? appVersion;
  String? familyCode;
  String? userPhoneNo;
  String? familyName;
  String finalDate = '';
  bool isFinalDate = false;
  bool enLng = false;
bool subSubscription=false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ConnectivityViewModel connectivityViewModel = Get.find<ConnectivityViewModel>();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    enLng = PreferenceManagerUtils.getIsLang();
    familyCode = PreferenceManagerUtils.getFamilyCode();
    userPhoneNo = PreferenceManagerUtils.getPhoneNo();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = CurvedAnimation(parent: _animationController, curve: Curves.elasticInOut);

    initData();
  }

  Future<void> initData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      metaData = await connectivityViewModel.getAppMetaData();

      if (metaData == null) {
        log("App metadata is missing, skipping version check.");
        return;
      }

      final familyDoc = await FirebaseFirestore.instance
          .collection('families')
          .doc(familyCode)
          .get();

      final familyData = familyDoc.data();
      setState(() {
        subSubscription=familyData?['isActive']??false;

        familyName = familyData?['familyName'] ?? '';
        StringUtils.appName = familyName ?? StringUtils.appName;

        final startDate = familyData?['lastDateResult']?.toString() ?? '';
        List<String> dateParts = startDate.split('-');
        if (dateParts.length == 3) {
          DateTime givenDate = DateTime(
            int.parse(dateParts[2]),
            int.parse(dateParts[1]),
            int.parse(dateParts[0]),
          );
          isFinalDate = DateTime.now().isAfter(givenDate);
          finalDate = startDate;
        }
      });

      _animationController.forward();

      appVersion = Platform.isAndroid
          ? int.parse(metaData['androidVersion'].toString().replaceAll('.', ''))
          : int.parse(metaData['iosVersion'].toString().replaceAll('.', ''));

      if (appVersion! > int.parse(StringUtils.appVersion)) {
        updateDialog(context);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void showImagePopup(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator(color: ColorUtils.primaryColor)),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: buildDrawer(),
      backgroundColor: ColorUtils.purple2D,
      floatingActionButton: isFinalDate||subSubscription==false
          ? null
          : FloatingActionButton(
        backgroundColor: ColorUtils.purple2D,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Icon(Icons.add, color: ColorUtils.white, size: 5.h),
        onPressed: () => Get.to(() => const StudentDetailScreen()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _key.currentState!.openDrawer(),
                    icon: Icon(Icons.menu, color: ColorUtils.white, size: 30),
                  ),
                  Expanded(
                    child: CustomText(
                      familyName != null && familyName!.isNotEmpty
                          ? familyName!
                          : "Family Name",
                      color: ColorUtils.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.w),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorUtils.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ColorUtils.white,border: Border.all(color: ColorUtils.primary),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  finalDate,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustomText(
                              StringUtils.lastDate.tr,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorUtils.black32,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<List<StudentModel>>(
                        stream: StudentService.getResultsForCurrentUser(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator(color: ColorUtils.primaryColor));
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return noDataFound();
                          }

                          final resultList = snapshot.data!;
                          return ListView.builder(
                            itemCount: resultList.length,
                            itemBuilder: (context, index) {
                              final student = resultList[index];
                              Color statusColor;
                              String statusLabel;
                              if (student.documentStatus == DocumentStatusTypeEnum.approve.name) {
                                statusColor = Colors.green;
                                statusLabel = "Approved";
                              } else if (student.documentStatus == DocumentStatusTypeEnum.delete.name) {
                                statusColor = Colors.red;
                                statusLabel = "Rejected";
                              } else {
                                statusColor = Colors.orange;
                                statusLabel = "Pending";
                              }

                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: statusColor, width: 2),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if ((student.result ?? '').isNotEmpty) {
                                            final urls = student.result!.split(','); // multiple image URLs
                                            showMultiImageViewer(urls);
                                          }
                                        },
                                        // onTap: () => showImagePopup(student.result ?? ''),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            student.result ?? '',
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Container(
                                                width: 70,
                                                height: 70,
                                                alignment: Alignment.center,
                                                child: const CircularProgressIndicator(color: ColorUtils.primaryColor),
                                              );
                                            },
                                            errorBuilder: (context, error, stackTrace) => Icon(Icons.image, size: 70),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: CustomText(
                                                    student.studentFullName ?? 'No Name',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: statusColor.withOpacity(0.1),
                                                    border: Border.all(color: statusColor),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Text(statusLabel, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10.sp)),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            CustomText("${StringUtils.phoneNumber.tr}: ${student.mobileNumber}", fontSize: 10.sp),
                                            CustomText("${StringUtils.villageName.tr}: ${student.villageName}", fontSize: 10.sp),
                                            CustomText("${StringUtils.standard.tr}: ${student.standard}", fontSize: 10.sp),
                                            CustomText("${StringUtils.percentage.tr}: ${student.percentage}%", fontSize: 10.sp),
                                            if (student.documentStatus == DocumentStatusTypeEnum.delete.name && (student.documentReason?.isNotEmpty ?? false))
                                              Padding(
                                                padding: const EdgeInsets.only(top: 6),
                                                child: CustomText("${StringUtils.reasonForReject.tr}: ${student.documentReason}", fontSize: 10.sp, color: Colors.red),
                                              ),
                                            if (student.documentStatus != DocumentStatusTypeEnum.approve.name)
                                              Row(
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Get.to(() => EditStudentScreen(student: student));
                                                    },
                                                    child: Text("${StringUtils.edit.tr}", style: TextStyle(color: ColorUtils.primaryColor)),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      bool? confirm = await showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text("Delete Confirmation"),
                                                          content: Text("Are you sure you want to delete this result?"),
                                                          actions: [
                                                            TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
                                                            TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Delete")),
                                                          ],
                                                        ),
                                                      );
                                                      if (confirm == true) {
                                                        final status = await StudentService.deleteStudent(student.studentId!);
                                                        if (status) {
                                                          ToastUtils.showCustomToast(context: context, title: "Deleted Successfully");
                                                        }
                                                      }
                                                    },
                                                    child: Text(StringUtils.delete.tr, style: TextStyle(color: Colors.red)),
                                                  ),
                                                ],
                                              )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: Center(child: Image.asset('assets/images/app_logo.png')),
            decoration: BoxDecoration(color: ColorUtils.primaryColor),
            accountName: CustomText(
              familyName != null ? "Welcome to $familyName!" : 'Welcome!',
              color: ColorUtils.white,
            ),
            accountEmail: CustomText(userPhoneNo ?? "", color: ColorUtils.white),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(StringUtils.lang.tr, color: ColorUtils.primaryColor, fontSize: 12.sp),
                    Row(
                      children: [
                        languageToggle('ગુજ', false),
                        languageToggle('EN', true),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
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
          const Spacer(),
          CustomText('v ${StringUtils.appV}', color: ColorUtils.primaryColor, fontSize: 12.sp),
          InkWell(
            onTap: _launchUrl,
            child: Text(
              StringUtils.copyRightsMadvise.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: ColorUtils.primaryColor),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  void showMultiImageViewer(List<String> imageUrls) {
    PageController controller = PageController();
    int currentIndex = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: ColorUtils.primaryColor,
              insetPadding: EdgeInsets.zero,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: controller,
                    itemCount: imageUrls.length,
                    onPageChanged: (index) => setState(() => currentIndex = index),
                    itemBuilder: (context, index) {
                      return InteractiveViewer(
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator(color: ColorUtils.primaryColor));
                          },
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, color: Colors.white),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 40,
                    right: 0,left: 0,
                    child: Row(
mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text('My Result',style: TextStyle(color: ColorUtils.white,fontSize: 16,fontWeight: FontWeight.bold),),
                      SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(Icons.cancel_outlined, color: Colors.white, size: 30),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        '${currentIndex + 1} / ${imageUrls.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget languageToggle(String label, bool isEnglish) {
    bool isActive = enLng == isEnglish;
    return InkWell(
      onTap: () {
        enLng = isEnglish;
        Get.updateLocale(Locale(isEnglish ? 'en' : 'gu'));
        PreferenceManagerUtils.setIsLang(isEnglish);
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isActive ? ColorUtils.primary : Colors.white,
        ),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: CustomText(
          label,
          color: isActive ? Colors.white : ColorUtils.primary,
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    final uri = Uri.parse('https://www.madviseinfotech.com/');
    if (!await launchUrl(uri)) throw Exception('Could not launch URL');
  }

  Future<void> signOut() async {
    try {
      showLoadingDialog(context: context);
      await FirebaseAuth.instance.signOut();
      await PreferenceManagerUtils.clearPreference();
    } catch (e) {
      print("SignOut Error: $e");
    }
  }

  Widget noDataFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AssetsUtils.fileUpload, height: 27.h),
          SizedBox(height: 2.h),
          CustomText(StringUtils.noResult.tr),
        ],
      ),
    );
  }
}
