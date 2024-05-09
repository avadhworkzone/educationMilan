import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:Jamanvav/common/common_image_zoom.dart';
import 'package:Jamanvav/utils/shared_preference_utils.dart';
import '../../common/common_show_toast.dart';
import '../../common/custom_text.dart';
import '../../common/custom_textfield.dart';
import '../../common/image_compress.dart';
import '../../model/apiModel/student_detail_model.dart';
import '../../service/firebase_service.dart';
import '../../service/student_service.dart';
import '../../utils/app_enum.dart';
import '../../utils/asset_utils.dart';
import '../../utils/color_utils.dart';
import '../../utils/loading_dialog.dart';
import '../../utils/regular_expression.dart';
import '../../utils/string_utils.dart';
import '../home screen/home_screen.dart';

class EditScreen extends StatefulWidget {
  final String villageName;
  final num? personTage;
  final String? standard;
  final String? fullName;
  final String studentId;
  final String userId;
  final String imageId;
  final String? createdDate;
  final String? mobile;
  final String? status;
  String? image;

  EditScreen(
      {Key? key,
      this.standard,
      this.createdDate,
      this.image,
      this.personTage,
      this.fullName,
      this.mobile,
      this.status,
      required this.imageId,
      required this.userId,
      required this.villageName,
      required this.studentId})
      : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController mobile1Controller = TextEditingController();
  final TextEditingController mobile2Controller = TextEditingController();
  final TextEditingController percentageController = TextEditingController();
  Future<List<String>>? standardsListFuture;
  Future<List<String>>? villageListFuture;
  final FirestoreService firestoreService = FirestoreService();
  String? selectedValue;
  String? selectedVillageValue;
  String? selectedImage;
  String? downloadURL;
  String? imageId;

  @override
  void initState() {
    super.initState();
    standardsListFuture = firestoreService.getStandards();
    villageListFuture = firestoreService.getVillageName();
    fullNameController.text =
        widget.fullName.toString().split('/').first.toUpperCase();
    fatherNameController.text =
        widget.fullName.toString().split('/').last.toUpperCase();
    percentageController.text = widget.personTage.toString();
    selectedValue = widget.standard.toString();
    imageId = widget.image;
    mobile1Controller.text =
        widget.mobile.toString().toString().split('/').first;
    if (widget.mobile.toString().contains('/')) {
      mobile2Controller.text =
          widget.mobile.toString().toString().split('/').last;
    }

    selectedVillageValue = widget.villageName.toString();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.purple2D,
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: ColorUtils.white,
                      )),
                  SizedBox(
                    width: 25.w,
                  ),
                  CustomText(
                    StringUtils.details,
                    color: ColorUtils.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
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
                        topRight: Radius.circular(10.w),
                        topLeft: Radius.circular(10.w))),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.06,
                    // vertical: Get.height * 0.04
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: InkWell(
                                onTap: () {
                                  print("this is a image tap..?");
                                  commomImageZoom(
                                      context, widget.image.toString());
                                },
                                child: Container(
                                  height: 200,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: widget.image != null &&
                                            widget.image!.startsWith('http')
                                        ? Image.network(
                                            widget.image!,
                                            height: 200,
                                            width: 400,
                                            fit: BoxFit.fill,
                                          )
                                        : Image.file(
                                            File(widget.image!),
                                            height: 200,
                                            width: 400,
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 22,
                                right: 22,
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      backgroundColor: ColorUtils.whiteF9,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(6.w),
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return _buildBottomSheet(context);
                                      },
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: Get.width * 0.04,
                                    backgroundColor: ColorUtils.primaryColor,
                                    child: const Icon(
                                      Icons.edit,
                                      color: ColorUtils.white,
                                    ),
                                  ),
                                ))
                          ],
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
                        fatherNameController.text.isEmpty
                            ? SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                    regularExpression: RegularExpressionUtils
                                        .alphabetSpacePattern,
                                    keyBoardType: TextInputType.name,
                                    validationType: ValidationTypeEnum.fName,
                                  ),
                                  // CustomText(
                                  //   StringUtils.villageName,
                                  //   fontWeight: FontWeight.w500,
                                  // ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                ],
                              ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    StringUtils.phoneNumber,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(
                                    height: 1.w,
                                  ),

                                  /// Mobile field
                                  CommonTextField(
                                    inputLength: 10,
                                    textEditController: mobile1Controller,
                                    regularExpression:
                                        RegularExpressionUtils.digitsPattern,
                                    keyBoardType: TextInputType.number,
                                    validationType: ValidationTypeEnum.pNumber,
                                  ),
                                ],
                              ),
                            ),
                            mobile2Controller.text.isEmpty
                                ? SizedBox()
                                : SizedBox(
                                    width: 2.w,
                                  ),
                            mobile2Controller.text.isEmpty
                                ? SizedBox()
                                : Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          StringUtils.phoneNumber,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(
                                          height: 1.w,
                                        ),

                                        /// Mobile field
                                        CommonTextField(
                                          textEditController: mobile2Controller,
                                          inputLength: 10,
                                          regularExpression:
                                              RegularExpressionUtils
                                                  .digitsPattern,
                                          keyBoardType: TextInputType.number,
                                        ),
                                      ],
                                    ),
                                  ),
                            // CustomText(
                            //   StringUtils.villageName,
                            //   fontWeight: FontWeight.w500,
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),

                        /// village field
                        // CommonTextField(
                        //   textEditController: villageController,
                        //   regularExpression:
                        //       RegularExpressionUtils.alphabetSpacePattern,
                        //   keyBoardType: TextInputType.name,
                        //   validationType: ValidationTypeEnum.village,
                        // ),
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

                            /// drop down menu
                            SizedBox(
                              width: 50.w,
                              child: FutureBuilder<List<String>>(
                                future: villageListFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator(
                                      color: ColorUtils.primaryColor,
                                    ));
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text('No village found.'));
                                  } else {
                                    List<String> standardsList = snapshot.data!;
                                    Set<String> uniqueStandards =
                                        Set<String>.from(villageList);
                                    return DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 2.w,
                                          vertical: 4.w,
                                        ),
                                        focusedErrorBorder:
                                            const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorUtils.redError,
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorUtils.greyF6,
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorUtils.greyF6,
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorUtils.greyF6,
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorUtils.redError,
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        disabledBorder:
                                            const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorUtils.greyF6,
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        errorStyle: TextStyle(
                                          color: Colors.red,
                                          fontSize: 9.sp,
                                          fontFamily: AssetsUtils.poppins,
                                        ),
                                        filled: true,
                                        fillColor: ColorUtils.greyF6,
                                        hintText: "Select village",
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
                                          value == null ? "* Required" : null,
                                      dropdownColor: ColorUtils.greyF6,
                                      value: selectedVillageValue,
                                      onChanged: (String? villageName) {
                                        setState(() {
                                          selectedVillageValue = villageName;
                                        });
                                        Form.of(context).validate();
                                      },
                                      items: uniqueStandards
                                          .map((String villageName) {
                                        return DropdownMenuItem<String>(
                                          value: villageName,
                                          child: Text(
                                              villageName.capitalizeFirst!),
                                        );
                                      }).toList(),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4.w,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  width: 50.w,
                                  child: FutureBuilder<List<String>>(
                                    future: standardsListFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator(
                                          color: ColorUtils.primaryColor,
                                        ));
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return const Center(
                                            child: Text('No standards found.'));
                                      } else {
                                        List<String> standardsList =
                                            snapshot.data!;
                                        Set<String> uniqueStandards =
                                            Set<String>.from(standardsList);
                                        return DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 2.w,
                                              vertical: 4.w,
                                            ),
                                            focusedErrorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorUtils.redError,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorUtils.greyF6,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorUtils.greyF6,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorUtils.greyF6,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorUtils.redError,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            disabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorUtils.greyF6,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            errorStyle: TextStyle(
                                              color: Colors.red,
                                              fontSize: 9.sp,
                                              fontFamily: AssetsUtils.poppins,
                                            ),
                                            filled: true,
                                            fillColor: ColorUtils.greyF6,
                                            hintText: "Select standard",
                                            hintStyle: TextStyle(
                                              color: ColorUtils.greyD3,
                                              fontFamily: AssetsUtils.poppins,
                                              fontSize: 10.5.sp,
                                            ),
                                          ),
                                          isExpanded: true,
                                          isDense: true,
                                          menuMaxHeight: 50.w,
                                          validator: (value) => value == null
                                              ? "* Required"
                                              : null,
                                          dropdownColor: ColorUtils.greyF6,
                                          value: selectedValue,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedValue = newValue;
                                            });
                                            Form.of(context).validate();
                                          },
                                          items: uniqueStandards
                                              .map((String standard) {
                                            return DropdownMenuItem<String>(
                                              value: standard,
                                              child: Text(standard),
                                            );
                                          }).toList(),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  width: 35.w,
                                  child: CommonTextField(
                                    textEditController: percentageController,
                                    regularExpression: RegularExpressionUtils
                                        .percentagePattern,
                                    keyBoardType: TextInputType.number,
                                    validationType:
                                        ValidationTypeEnum.percentage,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.19),
                          child: InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                showLoadingDialog(context: context);
                                await _uploadImageToFirebase();
                                StudentModel reqModel = StudentModel();
                                reqModel.standard = selectedValue.toString();
                                reqModel.studentFullName =
                                    '${fullNameController.text.toUpperCase()} / ${fatherNameController.text.toUpperCase()}';
                                reqModel.percentage =
                                    double.parse(percentageController.text);
                                reqModel.studentId =
                                    widget.studentId.toString();
                                reqModel.villageName =
                                    selectedVillageValue.toString();
                                reqModel.userId = widget.userId.toString();
                                reqModel.mobileNumber = mobile2Controller
                                        .text.isEmpty
                                    ? mobile1Controller.text
                                    : '${mobile1Controller.text} / ${mobile2Controller.text}';
                                reqModel.fcmToken =
                                    PreferenceManagerUtils.getIsFCM();
                                reqModel.documentStatus =
                                    DocumentStatusTypeEnum.pending.name;
                                reqModel.documentReason = '';
                                reqModel.createdDate =
                                    DateTime.now().toLocal().toString();
                                reqModel.result = selectedImage != null
                                    ? downloadURL
                                    : widget.image;
                                reqModel.imageId = imageId;
                                reqModel.isApproved = false;
                                // reqModel.documentReason ='';
                                // reqModel.documentStatus =DocumentStatusTypeEnum.pending.name;

                                final status =
                                    await StudentService.studentDetailsEdit(
                                        reqModel);
                                if (status) {
                                  hideLoadingDialog(context: context);
                                  Get.off(() => const HomeScreen());
                                } else {
                                  hideLoadingDialog(context: context);
                                  ToastUtils.showCustomToast(
                                      context: context,
                                      title: StringUtils.somethingWentWrong.tr);
                                }
                              }
                            },
                            child: Container(
                              height: Get.height * 0.06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ColorUtils.primaryColor,
                              ),
                              child: Center(
                                child: CustomText(
                                  StringUtils.save,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.19),
                          child: InkWell(
                            onTap: () {
                              commonDialog();
                            },
                            child: Container(
                              height: Get.height * 0.06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ColorUtils.primaryColor,
                              ),
                              child: Center(
                                child: CustomText(
                                  StringUtils.delete,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return SizedBox(
      height: 35.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
        child: Column(
          children: [
            SizedBox(
              height: 4.w,
            ),
            GestureDetector(
              onTap: () {
                _pickImageCamera();
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.camera,
                    color: ColorUtils.purple93,
                    size: 7.w,
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  CustomText(
                    StringUtils.takePhoto,
                    fontSize: 11.sp,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 6.w,
            ),
            GestureDetector(
              onTap: () {
                _pickImageGallery();
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.photo,
                    color: ColorUtils.purple93,
                    size: 7.w,
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  CustomText(
                    StringUtils.chooseFromGallery,
                    fontSize: 11.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///==================gallery picker================///
  Future<void> _pickImageGallery() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File selectedFile = File(image.path);

      int fileSizeInBytes = await selectedFile.length();
      double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      print('Selected Image Size: ${fileSizeInMB.toStringAsFixed(2)} MB');
      if (double.parse(fileSizeInMB.toStringAsFixed(2)) < 5) {
        int maxSizeInBytes = 3 * 1024 * 1024;

        // if (fileSizeInBytes > maxSizeInBytes) {
        File? compressedImage = await compressFile(selectedFile);

        if (compressedImage != null) {
          setState(() {
            selectedImage = XFile(compressedImage.path).path;
            widget.image = selectedImage.toString();
          });
        }
      } else {
        ToastUtils.showCustomToast(
            backgroundColor: ColorUtils.red,
            context: context,
            title: StringUtils.uploadYourImage.tr);
      }
      // } else {
      //   setState(() {
      //     selectedImage = image.path;
      //     widget.image = selectedImage.toString();
      //   });
      // }
    }
  }

  /*Future<void> _pickImageGallery() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = image.path;
        widget.image = selectedImage.toString();
      });
    } else {}
  }*/

  ///==================camera picker================///
  Future<void> _pickImageCamera() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      final File selectedFile = File(image.path);

      int fileSizeInBytes = await selectedFile.length();
      double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      print('Selected Image Size: ${fileSizeInMB.toStringAsFixed(2)} MB');
      if (double.parse(fileSizeInMB.toStringAsFixed(2)) < 5) {
        int maxSizeInBytes = 3 * 1024 * 1024;

        // if (fileSizeInBytes > maxSizeInBytes) {
        File? compressedImage = await compressFile(selectedFile);

        if (compressedImage != null) {
          setState(() {
            selectedImage = XFile(compressedImage.path).path;
            widget.image = selectedImage.toString();
          });
        }
      } else {
        ToastUtils.showCustomToast(
            backgroundColor: ColorUtils.red,
            context: context,
            title: StringUtils.uploadYourImage.tr);
      }
      // } else {
      //   setState(() {
      //     selectedImage = image.path;
      //     widget.image = selectedImage.toString();
      //   });
      // }
    }
  }

  /*Future<void> _pickImageCamera() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        selectedImage = image.path;
        widget.image = selectedImage.toString();
      });
    } else {}
  }*/

  ///dialog delete
  commonDialog() {
    showDialog(
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Dialog(
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
                  Image.asset("assets/images/alert.png",
                      width: Get.width * 0.07),
                  SizedBox(height: 2.h),
                  CustomText(
                    StringUtils.deleteTitle,
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
                              StringUtils.cancel,
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
                      PopScope(
                        canPop: false,
                        child: InkWell(
                          onTap: () async {
                            showLoadingDialog(context: context);
                            Future.delayed(
                              Duration(seconds: 7),
                              () {},
                            );
                            final status = await StudentService.deleteStudent(
                                widget.studentId);
                            if (status) {
                              hideLoadingDialog(context: context);
                              Get.offAll(() => const HomeScreen());
                            } else {}
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ColorUtils.primaryColor),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Get.height * 0.005,
                                  horizontal: Get.width * 0.04),
                              child: CustomText(
                                StringUtils.delete,
                                color: ColorUtils.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      context: context,
    );
  }

  ///=================upload image==============///
  Future<void> _uploadImageToFirebase() async {
    if (selectedImage == null) {
      return;
    }
    print('===${widget.imageId == '' || widget.imageId == 'null'}');
    try {
      String fileName = widget.imageId == '' || widget.imageId == 'null'
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : widget.imageId;
      String imagePath = 'images/$fileName.jpg';

      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(imagePath);

      await ref.putFile(File(selectedImage!));

      downloadURL = await ref.getDownloadURL();
      imageId = fileName;
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
