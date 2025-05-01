import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:Jamanvav/common/common_show_toast.dart';
import 'package:Jamanvav/common/custom_btn.dart';
import 'package:Jamanvav/common/custom_text.dart';
import 'package:Jamanvav/utils/color_utils.dart';
import 'package:Jamanvav/utils/string_utils.dart';
import '../../common/custom_textfield.dart';
import '../../common/image_compress.dart';
import '../../model/apiModel/student_detail_model.dart';
import '../../service/firebase_service.dart';
import '../../service/student_service.dart';
import '../../utils/app_enum.dart';
import '../../utils/regular_expression.dart';
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
  bool isUploading = false;

  List<XFile>? pickedImages = [];
  List<String> downloadURLs = [];  // To hold the final image URLs
  String? imageId;
  bool isSubmitting = false;

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

    // Parse the result into multiple URLs for display if they exist
    if (widget.student.result != null && widget.student.result!.isNotEmpty) {
      downloadURLs = widget.student.result!.split(','); // Split the result string by commas to get image URLs
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      final File selectedFile = File(image.path);
      final fileSize = await selectedFile.length();
      final fileSizeMB = fileSize / (1024 * 1024); // Convert to MB

      if (fileSizeMB <= 15) {
        final compressed = await compressFile(selectedFile);
        if (compressed != null) {
          // Upload the compressed image to Firebase Storage
          try {
            setState(() => isUploading = true); // Show loader

            final fileName = DateTime.now().millisecondsSinceEpoch.toString();
            final ref = firebase_storage.FirebaseStorage.instance.ref('images/$fileName.jpg');
            await ref.putFile(File(compressed.path));
            String downloadURL = await ref.getDownloadURL();

            setState(() {
              pickedImages!.add(XFile(compressed.path));
              downloadURLs.add(downloadURL);
              isUploading = false; // Hide loader
            });
          } catch (e) {
            setState(() => isUploading = false);
            print('Error uploading image: $e');
            ToastUtils.showCustomToast(
              context: context,
              backgroundColor: ColorUtils.red,
              title: 'faile',
            );
          }

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

  // Future<void> _uploadImagesToFirebase() async {
  //   if (pickedImages == null || pickedImages!.isEmpty) return;
  //
  //   try {
  //     List<String> uploadedURLs = [];
  //     List<String> imageIds = [];
  //
  //     for (var pickedImage in pickedImages!) {
  //       final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //       final ref = firebase_storage.FirebaseStorage.instance.ref('images/$fileName.jpg');
  //       await ref.putFile(File(pickedImage.path));
  //
  //       String downloadURL = await ref.getDownloadURL();
  //       uploadedURLs.add(downloadURL);
  //       imageIds.add(fileName);
  //     }
  //
  //     setState(() {
  //       downloadURLs.addAll(uploadedURLs); // Add the new URLs to the existing ones
  //       imageId = imageIds.join(',');
  //       print('downloadURLs-==$downloadURLs');// Save image IDs for Firebase storage
  //     });
  //   } catch (e) {
  //     print('Error uploading images: $e');
  //   }
  // }

  Widget _buildImageThumbnail(String imageURL, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageURL,
            width: 25.w,
            height: 25.w,
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
              return  Icon(Icons.error, size: 25.w);
            },
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                downloadURLs.removeAt(index); // Remove image when clicked
              });
            },
            child: Icon(Icons.remove_circle, color: ColorUtils.red, size: 8.w),
          ),
        ),
      ],
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
                        // Image Picker Section
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
                             child: isUploading
                              ? SizedBox(
                              height: 150,
                              width: 150,
                              child: Center(child: CircularProgressIndicator()),
                            )
                      : downloadURLs.isEmpty
                ? Image.asset(
                'assets/images/fileUpload.png',
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                )

                                  : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    // Display existing images from downloadURLs
                                    ...List.generate(
                                      downloadURLs.length,
                                          (index) => Padding(
                                        padding: EdgeInsets.only(right: 8.w),
                                        child: _buildImageThumbnail(downloadURLs[index], index),
                                      ),
                                    ),
                                    // Display picked images (new ones)
                                    // ...List.generate(
                                    //   pickedImages!.length,
                                    //       (index) => Padding(
                                    //     padding: EdgeInsets.only(right: 8.w),
                                    //     child: _buildImageThumbnail(pickedImages![index].path, index),
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.w),
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor: ColorUtils.whiteF9,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(6.w)),
                                            ),
                                            builder: _imagePickerBottomSheet,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            width: 25.w,
                                            height: 25.w,
                                            color: Colors.grey.withOpacity(0.3),
                                            child: Icon(
                                              Icons.add,
                                              color: ColorUtils.purple93,
                                              size: 12.w,
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
                        ),
                        SizedBox(height: 5.h),
                        CustomText(StringUtils.studentFullName),
                        CommonTextField(
                          textEditController: fullNameController,
                          validationType: ValidationTypeEnum.name,
                        ),
                        SizedBox(height: 3.h),
                        CustomText(StringUtils.fatherFullName),
                        CommonTextField(
                          textEditController: fatherNameController,
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
                          child:(isSubmitting)?
        Container(
    color: Colors.black.withOpacity(0.4),
    child: const Center(child: CircularProgressIndicator()),
    ):CustomBtn(
                            title: StringUtils.submit.tr,
                            onTap: () async {
                              if (_formKey.currentState!.validate() && selectedStandard != null && selectedVillage != null) {
                                widget.student.studentFullName =
                                '${fullNameController.text.trim().toUpperCase()} / ${fatherNameController.text.trim().toUpperCase()}';
                                widget.student.percentage = double.tryParse(percentageController.text.trim());
                                widget.student.mobileNumber = mobileController.text.trim();
                                widget.student.villageName = selectedVillage!;
                                widget.student.standard = selectedStandard!;
                                widget.student.documentStatus = DocumentStatusTypeEnum.pending.name;
                                // if (pickedImages != null && pickedImages!.isNotEmpty) {
                                //   await _uploadImagesToFirebase();
                                // }
                                setState(() => isSubmitting = true); // Show loader

// Always update the result with whatever is in `downloadURLs`
                                if (downloadURLs.isNotEmpty) {
                                  widget.student.result = downloadURLs.join(',');
                                  widget.student.imageId = imageId;
                                }


                                final status = await StudentService.updateStudent(widget.student);
                                if (status) {
                                  setState(() => isSubmitting = false); // Hide loader

                                  Get.back();
                                  Get.snackbar('Success', 'Student updated');

                                } else {
                                  setState(() => isSubmitting = false); // Hide loader

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
}
