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
import 'package:Jamanvav/view/upload_student_details/upload_student_details.dart';
import '../../service/firebase_service.dart';
import '../../utils/asset_utils.dart';
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

  String? selectedValue, selectedVillageValue;
  Future<List<String>>? standardsListFuture;
  Future<List<String>>? villageListFuture;

  int? passingYear;
  Set<String> standardsList = {};

  @override
  void initState() {
    super.initState();
    selectedVillageValue = 'Jamanvav';
    standardsListFuture = firestoreService.getStandards().then((list) {
      standardsList = Set<String>.from(list);
      print('standerd--->$standardsList');
      return list;
    });
    villageListFuture = firestoreService.getVillageName();
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
                              regularExpression: RegularExpressionUtils.alphabetSpacePattern,
                              keyBoardType: TextInputType.name,
                              validationType: ValidationTypeEnum.name,
                            ),
                            SizedBox(height: 2.w),
                            CustomText(StringUtils.fatherFullName, fontWeight: FontWeight.w500),
                            SizedBox(height: 1.w),
                            CommonTextField(
                              textEditController: fatherNameController,
                              regularExpression: RegularExpressionUtils.alphabetSpacePattern,
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(StringUtils.standard, fontWeight: FontWeight.w500),
                                      SizedBox(height: 1.w),
                                      SizedBox(
                                        height: 5.5.h,
                                        child: standardsList.isNotEmpty
                                            ? stdListWidget()
                                            : FutureBuilder<List<String>>(
                                          future: standardsListFuture,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return const Center(
                                                child: CircularProgressIndicator(color: ColorUtils.primaryColor),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Center(child: Text('Error: ${snapshot.error}'));
                                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                              return const Center(child: Text('No standards found.'));
                                            } else {
                                              standardsList = Set<String>.from(snapshot.data!);
                                              return stdListWidget();
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 3.w),

                                    /// Passing Year (dynamic)
                                    if (passingYear != null)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          CustomText("Passing Year", fontWeight: FontWeight.w500),
                                          SizedBox(height: 1.w),
                                          Container(
                                            height: 5.5.h,
                                            // width: double.infinity,
                                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: ColorUtils.greyF6,
                                              border: Border.all(color: ColorUtils.greyF6),
                                            ),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              passingYear.toString(),
                                              style: TextStyle(
                                                fontSize: 10.5.sp,
                                                fontFamily: AssetsUtils.poppins,
                                                color: ColorUtils.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),



                              ],
                            ),
                            SizedBox(height: 3.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [


                                CustomText(StringUtils.percentage, fontWeight: FontWeight.w500),
                                SizedBox(height: 1.w),
                                SizedBox(
                                  width:double.infinity,
                                  child: CommonTextField(
                                    textEditController: percentageController,
                                    regularExpression: RegularExpressionUtils.percentagePattern,
                                    keyBoardType: TextInputType.number,
                                    inputLength: 5,
                                    validationType: ValidationTypeEnum.percentage,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                              ],
                            ),
                            Center(
                              child: CustomBtn(
                                onTap: () {
                                  if (_formKey.currentState!.validate() && selectedValue != null) {
                                    Get.to(() => UploadStudentDetailsScreen(
                                      percentage: double.parse(percentageController.text),
                                      standard: selectedValue.toString(),
                                      studentFullName:
                                      '${fullNameController.text.toUpperCase()} / ${fatherNameController.text.toUpperCase()}',
                                      villageName: 'Jamanvav',
                                      mobile: mob2.text.isEmpty ? mob1.text : '${mob1.text} / ${mob2.text}',
                                    ));
                                  }
                                },
                                title: "આગળ",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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

  DropdownButtonFormField<String> stdListWidget() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.w),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ColorUtils.greyF6)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ColorUtils.greyF6)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ColorUtils.greyF6)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ColorUtils.redError)),
        hintText: StringUtils.selectStandard.tr,
        filled: true,
        fillColor: ColorUtils.greyF6,
      ),
      value: selectedValue,
      isExpanded: true,
      menuMaxHeight: 50.w,
      validator: (value) => value == null ? StringUtils.selectStandard.tr : null,
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue;
          if (['STD 10', 'STD 12 SCI', 'STD 12 COM'].contains(newValue)) {
            passingYear = 2024;
          } else {
            passingYear = 2025;
          }
        });
      },
      items: standardsList.map((String standard) {
        return DropdownMenuItem<String>(
          value: standard,
          child: Text(standard),
        );
      }).toList(),
    );
  }
}
