import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
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
import 'package:Jamanvav/utils/string_utils.dart';
import 'package:Jamanvav/view/home%20screen/home_screen.dart';
import '../../common/image_compress.dart';
import '../../model/apiModel/student_detail_model.dart';
import '../../service/student_service.dart';
import '../../utils/loading_dialog.dart';
import '../../utils/shared_preference_utils.dart';

class UploadStudentDetailsScreen extends StatefulWidget {
  final String? studentFullName;
  final String? villageName;
  final String? standard;
  final num? percentage;
  final String? mobile;

  const UploadStudentDetailsScreen({
    super.key,
    this.villageName,
    this.studentFullName,
    this.standard,
    this.mobile,
    this.percentage,
  });

  @override
  State<UploadStudentDetailsScreen> createState() => _UploadStudentDetailsScreenState();
}

class _UploadStudentDetailsScreenState extends State<UploadStudentDetailsScreen> {
  List<XFile>? selectedImages = [];
  String? downloadURL;
  String? imageId;

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
            selectedImages!.add(XFile(compressed.path));
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

  Future<void> _uploadImagesToFirebase() async {
    if (selectedImages == null || selectedImages!.isEmpty) return;

    try {
      List<String> downloadURLs = [];
      List<String> imageIds = [];

      for (var selectedImage in selectedImages!) {
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final ref = firebase_storage.FirebaseStorage.instance.ref('images/$fileName.jpg');
        await ref.putFile(File(selectedImage.path));

        String downloadURL = await ref.getDownloadURL();
        downloadURLs.add(downloadURL);
        imageIds.add(fileName);
      }

      setState(() {
        this.downloadURL = downloadURLs.join(',');
        this.imageId = imageIds.join(',');
      });
    } catch (e) {
      print('Error uploading images: $e');
    }
  }

  Widget _buildImageThumbnail(XFile image, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(image.path),
            width: 25.w,
            height: 25.w,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedImages!.removeAt(index);
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
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios, color: ColorUtils.white),
                ),
                CustomText(StringUtils.appName, color: ColorUtils.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
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
                    topLeft: Radius.circular(10.w),
                    topRight: Radius.circular(10.w),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
                child: Column(
                  children: [
                    CustomText(StringUtils.uploadAPhotoOfYourResult.tr, fontSize: 12.sp, fontWeight: FontWeight.w600),
                    SizedBox(height: 10.w),
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        backgroundColor: ColorUtils.whiteF9,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(6.w)),
                        ),
                        builder: _imagePickerBottomSheet,
                      ),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(20),
                        dashPattern: const [6, 6],
                        color: Colors.grey,
                        strokeWidth: 2,
                        child: Container(
                          width: double.infinity,
                          height: 60.w,
                          alignment: Alignment.center,
                          child: selectedImages!.isEmpty
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 30.w, color: ColorUtils.purple93),
                              SizedBox(height: 10),
                              Text("Tap to add images", style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                            ],
                          )
                              : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                // Show added images
                                ...List.generate(
                                  selectedImages!.length,
                                      (index) => Padding(
                                    padding: EdgeInsets.only(right: 8.w),
                                    child: _buildImageThumbnail(selectedImages![index], index),
                                  ),
                                ),
                                // Show the plus button after the last image
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
                                      );                                    },
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
                    SizedBox(height: 20.w),
                    CustomBtn(
                      title: StringUtils.submit.tr,
                      onTap: () async {
                        if (selectedImages == null || selectedImages!.isEmpty) {
                          ToastUtils.showCustomToast(context: context, title: StringUtils.image.tr);
                          return;
                        }

                        showLoadingDialog(context: context);
                        await _uploadImagesToFirebase();

                        final reqModel = StudentModel(
                          studentFullName: widget.studentFullName,
                          villageName: widget.villageName ?? '',
                          standard: widget.standard,
                          percentage: widget.percentage,
                          mobileNumber: widget.mobile,
                          imageId: imageId,
                          result: downloadURL,
                          userId: PreferenceManagerUtils.getPhoneNo(),
                          familyCode: PreferenceManagerUtils.getFamilyCode(),
                          createdDate: DateTime.now().toIso8601String(),
                          isApproved: false,
                          fcmToken: PreferenceManagerUtils.getIsFCM(),
                          documentStatus: DocumentStatusTypeEnum.pending.name,
                          documentReason: '',
                        );

                        final success = await StudentService.createStudent(reqModel);
                        hideLoadingDialog(context: context);

                        if (success) {
                          Get.offAll(() => const HomeScreen());
                        } else {
                          ToastUtils.showCustomToast(
                            context: context,
                            title: StringUtils.somethingWentWrong.tr,
                            backgroundColor: ColorUtils.red,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
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
    );
  }
}
