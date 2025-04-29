import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:Jamanvav/common/common_show_toast.dart';
import 'package:Jamanvav/common/custom_btn.dart';
import 'package:Jamanvav/common/custom_text.dart';
import 'package:Jamanvav/utils/app_enum.dart';
import 'package:Jamanvav/utils/color_utils.dart';
import 'package:Jamanvav/utils/regular_expression.dart';
import 'package:Jamanvav/utils/string_utils.dart';
import '../../common/custom_textfield.dart';
import '../../common/image_compress.dart';
import '../../model/apiModel/student_detail_model.dart';
import '../../service/firebase_service.dart';
import '../../service/student_service.dart';
import '../../utils/shared_preference_utils.dart';

class EditStudentScreen extends StatefulWidget {
  final StudentModel student;
  const EditStudentScreen({super.key, required this.student});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController fullNameController;
  late TextEditingController fatherNameController;
  late TextEditingController percentageController;
  late TextEditingController mobileController;

  XFile? pickedImage;
  String? downloadURL;
  String? imageId;

  String? selectedStandard;
  String? selectedVillage;
  Future<List<String>>? standardsListFuture;
  Future<List<String>>? villageListFuture;

  @override
  void initState() {
    super.initState();
    final fullParts = widget.student.studentFullName?.split(' / ') ?? [];
    fullNameController = TextEditingController(text: fullParts.isNotEmpty ? fullParts[0].trim() : '');
    fatherNameController = TextEditingController(text: fullParts.length > 1 ? fullParts[1].trim() : '');
    percentageController = TextEditingController(text: widget.student.percentage?.toString());
    mobileController = TextEditingController(text: widget.student.mobileNumber);
    imageId = widget.student.imageId ?? '';
    selectedStandard = widget.student.standard;
    selectedVillage = widget.student.villageName;

    final familyCode = PreferenceManagerUtils.getFamilyCode();
    standardsListFuture = FirestoreService().getStandardsByFamily(familyCode!);
    villageListFuture = FirestoreService().getVillagesByFamily(familyCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.purple2D,
      appBar: AppBar(
        backgroundColor: ColorUtils.purple2D,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: CustomText(StringUtils.editResult.tr, color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorUtils.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () => showModalBottomSheet(
                              context: context,
                              backgroundColor: ColorUtils.whiteF9,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(6.w)),
                              ),
                              builder: _imagePickerBottomSheet,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: pickedImage != null
                                  ? Image.file(File(pickedImage!.path), height: 150, width: 150, fit: BoxFit.cover)
                                  : (widget.student.result != null && widget.student.result!.isNotEmpty)
                                  ? Image.network(
                                widget.student.result!,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/images/fileUpload.png', height: 150, width: 150, fit: BoxFit.cover);
                                },
                              )
                                  : Image.asset('assets/images/fileUpload.png', height: 150, width: 150, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        CustomText(StringUtils.studentFullName),
                        CommonTextField(
                          textEditController: fullNameController,
                          // regularExpression: RegularExpressionUtils.alphabetSpacePattern,
                          validationType: ValidationTypeEnum.name,
                        ),
                        SizedBox(height: 3.h),
                        CustomText(StringUtils.fatherFullName),
                        CommonTextField(
                          textEditController: fatherNameController,
                          // regularExpression: RegularExpressionUtils.alphabetSpacePattern,
                          validationType: ValidationTypeEnum.fName,
                        ),
                        SizedBox(height: 3.h),
                        CustomText(StringUtils.percentage),
                        CommonTextField(
                          textEditController: percentageController,
                          regularExpression: RegularExpressionUtils.percentagePattern,
                          validationType: ValidationTypeEnum.percentage,
                          keyBoardType: TextInputType.number,
                        ),
                        SizedBox(height: 3.h),
                        CustomText(StringUtils.mob1),
                        CommonTextField(
                          textEditController: mobileController,
                          regularExpression: RegularExpressionUtils.digitsPattern,
                          validationType: ValidationTypeEnum.pNumber,
                          keyBoardType: TextInputType.number,
                        ),
                        SizedBox(height: 3.h),
                        CustomText(StringUtils.selectStandard),
                        FutureBuilder<List<String>>(
                          future: standardsListFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              return DropdownButtonFormField<String>(
                                value: selectedStandard,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.w),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  filled: true,
                                  fillColor: ColorUtils.greyF6,
                                ),
                                hint: Text(StringUtils.selectStandard),
                                validator: (value) => value == null ? StringUtils.selectStandard : null,
                                onChanged: (value) => setState(() => selectedStandard = value),
                                items: snapshot.data!.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                              );
                            } else {
                              return const Text("No standards available");
                            }
                          },
                        ),
                        SizedBox(height: 3.h),
                        CustomText(StringUtils.selectVillage),
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
                        SizedBox(height: 4.h),
                        Center(
                          child: CustomBtn(
                            title: StringUtils.submit.tr,
                            onTap: () async {
                              if (_formKey.currentState!.validate() && selectedStandard != null && selectedVillage != null) {
                                widget.student.studentFullName =
                                '${fullNameController.text.trim().toUpperCase()} / ${fatherNameController.text.trim().toUpperCase()}';
                                widget.student.percentage = double.tryParse(percentageController.text.trim());
                                widget.student.mobileNumber = mobileController.text.trim();
                                widget.student.villageName = selectedVillage!;
                                widget.student.standard = selectedStandard!;
                                widget.student.documentStatus =DocumentStatusTypeEnum.pending.name;

                                if (pickedImage != null) {
                                  await _uploadImageToFirebase();
                                  if (downloadURL != null) {
                                    widget.student.result = downloadURL;
                                    widget.student.imageId = imageId;
                                  }
                                }

                                final status = await StudentService.updateStudent(widget.student);
                                if (status) {
                                  Get.back();
                                  Get.snackbar('Success', 'Student updated');
                                } else {
                                  Get.snackbar('Error', 'Failed to update student', backgroundColor: Colors.red);
                                }
                              }
                            },
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
    );
  }

  Widget _imagePickerBottomSheet(BuildContext context) {
    return SizedBox(
      height: 35.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(Icons.camera, color: ColorUtils.purple93, size: 7.w),
                  SizedBox(width: 3.w),
                  CustomText(StringUtils.takePhoto, fontSize: 11.sp),
                ],
              ),
            ),
            SizedBox(height: 6.w),
            GestureDetector(
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(Icons.photo, color: ColorUtils.purple93, size: 7.w),
                  SizedBox(width: 3.w),
                  CustomText(StringUtils.chooseFromGallery, fontSize: 11.sp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      final File selectedFile = File(image.path);
      final fileSize = await selectedFile.length();
      final fileSizeMB = fileSize / (1024 * 1024);

      if (fileSizeMB <= 15) {
        final compressed = await compressFile(selectedFile);
        if (compressed != null) {
          setState(() {
            pickedImage = XFile(compressed.path);
          });
        }
      } else {
        ToastUtils.showCustomToast(
          context: context,
          backgroundColor: ColorUtils.red,
          title: StringUtils.uploadYourImage.tr,
        );
      }
    }
  }

  Future<void> _uploadImageToFirebase() async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = firebase_storage.FirebaseStorage.instance.ref('images/$fileName.jpg');
      await ref.putFile(File(pickedImage!.path));
      downloadURL = await ref.getDownloadURL();
      imageId = fileName;
    } catch (e) {
      print('Error uploading image: $e');
      ToastUtils.showCustomToast(
        context: context,
        title: 'Image upload failed',
        backgroundColor: ColorUtils.red,
      );
    }
  }
}
