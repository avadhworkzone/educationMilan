import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:EduPulse/common/custom_btn.dart';
import 'package:EduPulse/common/custom_text.dart';
import 'package:EduPulse/common/custom_textfield.dart';
import 'package:EduPulse/utils/app_enum.dart';
import 'package:EduPulse/utils/color_utils.dart';
import 'package:EduPulse/utils/regular_expression.dart';
import 'package:EduPulse/utils/string_utils.dart';
import 'package:EduPulse/view/upload_student_details/upload_student_details.dart';
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
  // final TextEditingController villageController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController iconController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  bool isDropdownOpen = false;

  String? selectedValue, selectedVillageValue;
  String? validationMessage;
  Future<List<String>>? standardsListFuture;
  Future<List<String>>? villageListFuture;

  @override
  void initState() {
    super.initState();
    standardsListFuture = firestoreService.getStandards();
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: ColorUtils.white,
                            size: 20,
                          )),
                      CustomText(
                        StringUtils.appName,
                        color: ColorUtils.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  Container(
                    height: 200.w,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: ColorUtils.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.w),
                            topLeft: Radius.circular(10.w))),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 3.w, horizontal: 10.w),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: CustomText(
                                  StringUtils.studentDetails,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(
                                height: 8.w,
                              ),
                              CustomText(
                                StringUtils.studentFullName,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 1.w,
                              ),

                              /// name field
                              CommonTextField(
                                textEditController: fullNameController,
                                regularExpression:
                                    RegularExpressionUtils.alphabetSpacePattern,
                                keyBoardType: TextInputType.name,
                                validationType: ValidationTypeEnum.name,
                              ),
                              SizedBox(
                                height: 2.w,
                              ),

                              CustomText(
                                StringUtils.fatherFullName,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 1.w,
                              ),

                              /// father field
                              CommonTextField(
                                textEditController: fatherNameController,
                                regularExpression:
                                    RegularExpressionUtils.alphabetSpacePattern,
                                keyBoardType: TextInputType.name,
                                validationType: ValidationTypeEnum.fName,
                              ),
                              SizedBox(
                                height: 2.w,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          StringUtils.mob1.tr,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(
                                          height: 1.w,
                                        ),

                                        /// mob1 field
                                        CommonTextField(
                                          textEditController: mob1,
                                          regularExpression:
                                              RegularExpressionUtils
                                                  .digitsPattern,
                                          keyBoardType: TextInputType.number,
                                          validationType:
                                              ValidationTypeEnum.pNumber,
                                          inputLength: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          StringUtils.mob2.tr,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(
                                          height: 1.w,
                                        ),

                                        /// mob2 field
                                        CommonTextField(
                                          textEditController: mob2,
                                          regularExpression:
                                              RegularExpressionUtils
                                                  .digitsPattern,
                                          keyBoardType: TextInputType.number,
                                          inputLength: 10,
                                          // validationType: ValidationTypeEnum.fName,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2.w,
                              ),

                              /// village field
                              // CommonTextField(
                              //   textEditController: villageController,
                              //   regularExpression:
                              //       RegularExpressionUtils.alphabetSpacePattern,
                              //   keyBoardType: TextInputType.name,
                              //   validationType: ValidationTypeEnum.village,
                              // ),
                              SizedBox(
                                height: 3.w,
                              ),

                              ///SELECT VILLAGE...
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    StringUtils.villageName,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(
                                    height: 1.w,
                                  ),

                                  /// village drop down menu
                                  SizedBox(
                                    width: 45.w,
                                    child: standardsList.isNotEmpty
                                        ? villageListWidget()
                                        : FutureBuilder<List<String>>(
                                            future: villageListFuture,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return
                                                    // const Center(
                                                    // child: CustomText("Std"),
                                                    // );
                                                    const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                  color:
                                                      ColorUtils.primaryColor,
                                                ));
                                              } else if (snapshot.hasError) {
                                                return Center(
                                                    child: Text(
                                                        'Error: ${snapshot.error}'));
                                              } else if (!snapshot.hasData ||
                                                  snapshot.data!.isEmpty) {
                                                return const Center(
                                                    child: Text(
                                                        'No standards found.'));
                                              } else {
                                                // List<String> standardsList =
                                                //     snapshot.data!;
                                                return villageListWidget();
                                              }
                                            },
                                          ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3.w,
                              ),

                              ///STANDARD
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          StringUtils.standard,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(
                                          height: 1.w,
                                        ),

                                        /// drop down menu
                                        SizedBox(
                                          // width: 45.w,
                                          child: standardsList.isNotEmpty
                                              ? stdListWidget()
                                              : FutureBuilder<List<String>>(
                                                  future: standardsListFuture,
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return
                                                          // const Center(
                                                          // child: CustomText("Std"),
                                                          // );
                                                          const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                        color: ColorUtils
                                                            .primaryColor,
                                                      ));
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Center(
                                                          child: Text(
                                                              'Error: ${snapshot.error}'));
                                                    } else if (!snapshot
                                                            .hasData ||
                                                        snapshot
                                                            .data!.isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No standards found.'));
                                                    } else {
                                                      // List<String> standardsList =
                                                      //     snapshot.data!;
                                                      return stdListWidget();
                                                    }
                                                  },
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        StringUtils.percentage,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      SizedBox(
                                        height: 1.w,
                                      ),

                                      /// percentage
                                      SizedBox(
                                        width: 25.w,
                                        child: CommonTextField(
                                          textEditController:
                                              percentageController,
                                          regularExpression:
                                              RegularExpressionUtils
                                                  .percentagePattern,
                                          keyBoardType: TextInputType.number,
                                          inputLength: 5,
                                          validationType:
                                              ValidationTypeEnum.percentage,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: CustomText(
                                  StringUtils.forEnglishGrade,
                                  // fontWeight: FontWeight.w600,
                                  color: ColorUtils.red,
                                  fontSize: 8.sp,
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),

                              // SizedBox(
                              //   height: 35.w,
                              // ),
                              Center(
                                  child: CustomBtn(
                                      onTap: () async {
                                        if (_formKey.currentState!.validate() &&
                                            selectedValue != null &&
                                            selectedVillageValue != null) {
                                          Get.to(() =>
                                              UploadStudentDetailsScreen(
                                                percentage: double.parse(
                                                    percentageController.text),
                                                standard:
                                                    selectedValue.toString(),
                                                studentFullName:
                                                    '${fullNameController.text} / ${fatherNameController.text}',
                                                villageName:
                                                    selectedVillageValue,
                                                mobile: mob2.text.isEmpty
                                                    ? mob1.text
                                                    : '${mob1.text} / ${mob2.text}',
                                              ));
                                        } else {
                                          // setState(() {
                                          //   validationMessage = '* Required';
                                          // });
                                        }
                                      },
                                      title: "આગળ"))
                            ],
                          ),
                          // Positioned(
                          //     left: 0,
                          //     right: 0,
                          //     // top: 200,
                          //     bottom:50,
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
      ),
    );
  }

  DropdownButtonFormField<String> stdListWidget() {
    Set<String> uniqueStandards = Set<String>.from(standardsList);
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 2.w,
          vertical: 4.w,
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorUtils.redError, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorUtils.greyF6, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorUtils.greyF6, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorUtils.greyF6, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorUtils.redError, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorUtils.greyF6, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 9.sp,
          fontFamily: AssetsUtils.poppins,
        ),
        filled: true,
        fillColor: ColorUtils.greyF6,
        hintText: StringUtils.selectStandard.tr,
        hintStyle: TextStyle(
          color: ColorUtils.greyD3,
          fontFamily: AssetsUtils.poppins,
          fontSize: 10.5.sp,
        ),
      ),
      isExpanded: true,
      isDense: true,
      menuMaxHeight: 50.w,
      validator: (value) =>
          value == null ? StringUtils.selectStandard.tr : null,
      dropdownColor: ColorUtils.greyF6,
      value: selectedValue,
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        // Form.of(context).validate();
      },
      items: uniqueStandards.map((String standard) {
        return DropdownMenuItem<String>(
          value: standard,
          child: Text(standard),
        );
      }).toList(),
    );
  }

  ///VILLAGE DROPDOWN....
  DropdownButtonFormField<String> villageListWidget() {
    Set<String> uniqueVillage = Set<String>.from(villageList);
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 2.w,
          vertical: 4.w,
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorUtils.redError, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorUtils.greyF6, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorUtils.greyF6, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorUtils.greyF6, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorUtils.redError, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorUtils.greyF6, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 9.sp,
          fontFamily: AssetsUtils.poppins,
        ),
        filled: true,
        fillColor: ColorUtils.greyF6,
        hintText: StringUtils.selectVillage.tr,
        hintStyle: TextStyle(
          color: ColorUtils.greyD3,
          fontFamily: AssetsUtils.poppins,
          fontSize: 10.5.sp,
        ),
      ),
      isExpanded: true,
      isDense: true,
      menuMaxHeight: 50.w,
      validator: (value) =>
          value == null ? StringUtils.villageValidation.tr : null,
      dropdownColor: ColorUtils.greyF6,
      value: selectedVillageValue,
      onChanged: (String? newValue) {
        setState(() {
          selectedVillageValue = newValue;
        });
        // Form.of(context).validate();
      },
      items: uniqueVillage.map((String villageName) {
        return DropdownMenuItem<String>(
          value: villageName,
          child: Text(villageName.capitalizeFirst!),
        );
      }).toList(),
    );
  }
}
