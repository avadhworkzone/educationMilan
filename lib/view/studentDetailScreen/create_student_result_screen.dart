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
import 'package:Jamanvav/view/studentDetailScreen/upload_student_details.dart';
import '../../service/firebase_service.dart';
import '../../utils/asset_utils.dart';
import '../../utils/shared_preference_utils.dart';
import '../home screen/home_screen.dart';

class StudentDetailScreen extends StatefulWidget {
  const StudentDetailScreen({super.key});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController mob1 = TextEditingController();
  final TextEditingController mob2 = TextEditingController();
  final TextEditingController percentageController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  String? selectedStandard;
  String? selectedVillage;
  Future<List<String>>? standardsListFuture;
  Future<List<String>>? villageListFuture;
  Set<String> standardsList = {};
  Set<String> villageList = {};

  String? familyCode;

  @override
  void initState() {
    super.initState();
    familyCode = PreferenceManagerUtils.getFamilyCode();
    standardsListFuture = firestoreService.getStandardsByFamily(familyCode!);
    villageListFuture = firestoreService.getVillagesByFamily(familyCode!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => const HomeScreen());
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorUtils.purple2D,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_ios, color: ColorUtils.white, size: 20),
                    ),
                    CustomText(
                      StringUtils.appName,
                      color: ColorUtils.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                SizedBox(height: 5.w),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorUtils.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.w),
                        topLeft: Radius.circular(10.w),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.w, horizontal: 10.w),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: CustomText(
                                StringUtils.studentDetails,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 8.w),
                            CustomText(StringUtils.studentFullName, fontWeight: FontWeight.w500),
                            SizedBox(height: 1.w),
                            CommonTextField(
                              textEditController: fullNameController,
                              // regularExpression: RegularExpressionUtils.alphabetSpacePattern,
                              keyBoardType: TextInputType.name,
                              validationType: ValidationTypeEnum.name,
                            ),
                            SizedBox(height: 2.w),
                            CustomText(StringUtils.fatherFullName, fontWeight: FontWeight.w500),
                            SizedBox(height: 1.w),
                            CommonTextField(
                              textEditController: fatherNameController,
                              // regularExpression: RegularExpressionUtils.alphabetSpacePattern,
                              keyBoardType: TextInputType.name,
                              validationType: ValidationTypeEnum.fName,
                            ),
                            SizedBox(height: 2.w),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(StringUtils.mob1.tr, fontWeight: FontWeight.w500),
                                      SizedBox(height: 1.w),
                                      CommonTextField(
                                        textEditController: mob1,
                                        regularExpression: RegularExpressionUtils.digitsPattern,
                                        keyBoardType: TextInputType.number,
                                        validationType: ValidationTypeEnum.pNumber,
                                        inputLength: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(StringUtils.mob2.tr, fontWeight: FontWeight.w500),
                                      SizedBox(height: 1.w),
                                      CommonTextField(
                                        textEditController: mob2,
                                        regularExpression: RegularExpressionUtils.digitsPattern,
                                        keyBoardType: TextInputType.number,
                                        inputLength: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.w),
                            CustomText(StringUtils.selectStandard.tr, fontWeight: FontWeight.w500),
                            SizedBox(height: 1.w),

                            FutureBuilder<List<String>>(
                              future: standardsListFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                  return DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.w),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                      filled: true,
                                      fillColor: ColorUtils.greyF6,
                                    ),
                                    value: selectedStandard,
                                    hint: Text(StringUtils.selectStandard.tr),

                                    isExpanded: true,
                                    validator: (value) => value == null ? StringUtils.selectStandard.tr : null,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedStandard = newValue;
                                      });
                                    },
                                    items: snapshot.data!.map((String standard) {
                                      return DropdownMenuItem<String>(
                                        value: standard,
                                        child: Text(standard),
                                      );
                                    }).toList(),
                                  );
                                } else {
                                  return const Text("No standards available");
                                }
                              },
                            ),
                            SizedBox(height: 3.w),
                            CustomText(StringUtils.selectVillage.tr, fontWeight: FontWeight.w500),
                            SizedBox(height: 1.w),

                            FutureBuilder<List<String>>(
                              future: villageListFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                  // Auto-select if only one village is available
                                  if (snapshot.data!.length == 1 && selectedVillage == null) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      setState(() {
                                        selectedVillage = snapshot.data!.first;
                                      });
                                    });
                                  }

                                  return DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.w),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                      filled: true,
                                      fillColor: ColorUtils.greyF6,
                                    ),
                                    value: selectedVillage,
                                    isExpanded: true,
                                    hint: Text(StringUtils.selectVillage.tr),
                                    validator: (value) => value == null ? 'Please select village' : null,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedVillage = newValue;
                                      });
                                    },
                                    items: snapshot.data!.map((String village) {
                                      return DropdownMenuItem<String>(
                                        value: village,
                                        child: Text(village),
                                      );
                                    }).toList(),
                                  );
                                } else {
                                  return const Text("No villages available");
                                }
                              },
                            ),

                            SizedBox(height: 3.w),
                            CustomText(StringUtils.percentage, fontWeight: FontWeight.w500),
                            SizedBox(height: 1.w),
                            CommonTextField(
                              textEditController: percentageController,
                              regularExpression: RegularExpressionUtils.percentagePattern,
                              keyBoardType: TextInputType.number,
                              inputLength: 5,
                              validationType: ValidationTypeEnum.percentage,
                            ),
                            SizedBox(height: 5.h),
                            Center(
                              child: CustomBtn(
                                onTap: () {
                                  if (_formKey.currentState!.validate() && selectedStandard != null && selectedVillage != null) {
                                    Get.to(() => UploadStudentDetailsScreen(
                                      percentage: double.parse(percentageController.text),
                                      standard: selectedStandard,
                                      studentFullName: '${fullNameController.text.toUpperCase()} / ${fatherNameController.text.toUpperCase()}',
                                      villageName: selectedVillage,
                                      mobile: mob2.text.isEmpty ? mob1.text : '${mob1.text} / ${mob2.text}',
                                    ));
                                  }
                                },
                                title: StringUtils.next.tr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
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
}
