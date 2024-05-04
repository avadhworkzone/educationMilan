import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:EduPulse/common/common_show_toast.dart';
import 'package:EduPulse/common/custom_btn.dart';
import 'package:EduPulse/common/custom_text.dart';
import 'package:EduPulse/utils/app_enum.dart';
import 'package:EduPulse/utils/color_utils.dart';
import 'package:EduPulse/utils/string_utils.dart';
import 'package:EduPulse/view/home%20screen/home_screen.dart';
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
  const UploadStudentDetailsScreen(
      {super.key,
      this.villageName,
      this.studentFullName,
      this.standard,
      this.mobile,
      this.percentage});

  @override
  State<UploadStudentDetailsScreen> createState() =>
      _UploadStudentDetailsScreenState();
}

class _UploadStudentDetailsScreenState
    extends State<UploadStudentDetailsScreen> {
  File? pickedImage;
  bool isPicked = false;
  bool isImageSelected = false;
  int selectedIndex = -1;
  bool isAtLeastOneImageSelected = false;
  String? imageId;

  List<XFile> selectedImages = [];
  XFile? selectedImage;
  String? downloadURL;
  String? image = '';
  Future<void> _pickImageGallery() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final File selectedFile = File(image.path);

      int fileSizeInBytes = await selectedFile.length();

      double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      print('Selected Image Size: ${fileSizeInMB.toStringAsFixed(2)} MB');
      if (double.parse(fileSizeInMB.toStringAsFixed(2)) <= 15) {
        // int maxSizeInBytes = 3 * 1024 * 1024;
        // if (fileSizeInBytes > maxSizeInBytes) {
        File? compressedImage = await compressFile(selectedFile);
        if (compressedImage != null) {
          setState(() {
            selectedImage = XFile(compressedImage.path);
          });
        }
      } else {
        ToastUtils.showCustomToast(
            backgroundColor: ColorUtils.red,
            context: context,
            title: StringUtils.uploadYourImage);
      }

      // } else {
      //   setState(() {
      //     selectedImage = image;
      //   });
      // }
    } else {}
  }

  /*Future<void> _pickImageGallery() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = image;
        // isImageSelected = true;
        // isAtLeastOneImageSelected = true;
      });
      // _uploadImageToFirebase();
    } else {}
  }*/

  Future<void> _pickImageCamera() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      final File selectedFile = File(image.path);

      int fileSizeInBytes = await selectedFile.length();
      double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      print('Selected Image Size: ${fileSizeInMB.toStringAsFixed(2)} MB');
      if (double.parse(fileSizeInMB.toStringAsFixed(2)) < 15) {
        // int maxSizeInBytes = 3 * 1024 * 1024;

        // if (fileSizeInBytes > maxSizeInBytes) {
        File? compressedImage = await compressFile(selectedFile);

        if (compressedImage != null) {
          setState(() {
            selectedImage = XFile(compressedImage.path);
          });
        }
      } else {
        ToastUtils.showCustomToast(
            backgroundColor: ColorUtils.red,
            context: context,
            title: StringUtils.uploadYourImage);
      }
      // } else {
      //   setState(() {
      //     selectedImage = image;
      //   });
      // }
    } else {}
    /* if (image != null) {
      setState(() {
        selectedImage = image;
      });
    } else {}*/
  }

  void _addToSelectedImages() {
    if (selectedImage != null) {
      setState(() {
        selectedImages.add(selectedImage!);
        selectedImage = null;
        isAtLeastOneImageSelected =
            true; // Set to true when an image is selected
        // isImageSelected = false;
      });
    }
  }

  // void _deleteImage(int index) {
  //   setState(() {
  //     selectedImages.removeAt(index);
  //   });
  // }

  String getFileNameFromPath(String path) {
    List<String> pathParts = path.split('/');
    return pathParts.last;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorUtils.purple2D,
        body: SafeArea(
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
                  height: Get.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: ColorUtils.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.w),
                          topLeft: Radius.circular(10.w))),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            /// upload a photo text
                            Center(
                              child: CustomText(
                                StringUtils.uploadAPhotoOfYourResult.tr,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(
                              height: 5.w,
                            ),

                            /// show image container
                            GestureDetector(
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
                              child: Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                    color: ColorUtils.whiteF9,
                                    borderRadius: BorderRadius.circular(5.w)),
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(20),
                                  dashPattern: const [6, 6],
                                  color: Colors.grey,
                                  strokeWidth: 2,
                                  child: selectedImage != null
                                      ? Center(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.file(
                                              File(selectedImage!.path),
                                              height: 200,
                                              width: 400,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.w),
                                            child: Image.asset(
                                              "assets/images/uploadImage.png",
                                              width: 30.w,
                                              height: 30.w,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.w,
                            ),

                            /// seprator
                            Row(children: [
                              Expanded(
                                  child: Divider(
                                thickness: 1,
                                color: ColorUtils.purple2D,
                                indent: 22.w,
                                endIndent: 3.w,
                              )),
                              CustomText(StringUtils.or),
                              Expanded(
                                  child: Divider(
                                thickness: 1,
                                color: ColorUtils.purple2D,
                                indent: 3.w,
                                endIndent: 22.w,
                              )),
                            ]),
                            SizedBox(
                              height: 5.w,
                            ),

                            /// choose from gallery button && add Image
                            CustomBtn(
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
                              title: StringUtils.addImage.tr,
                              width: 32.w,
                              height: 10.w,
                              fontSize: 11.sp,
                            ),
                            SizedBox(
                              height: 8.w,
                            ),

                            /// show image file list

                            SizedBox(
                              height: 5.w,
                            ),
                            PopScope(
                              canPop: false,
                              child: CustomBtn(
                                  onTap: () async {
                                    if (selectedImage == null) {
                                      ToastUtils.showCustomToast(
                                        context: context,
                                        title: StringUtils.image,
                                      );
                                    } else {
                                      showLoadingDialog(context: context);
                                      await _uploadImageToFirebase();
                                      StudentModel reqModel = StudentModel();
                                      reqModel.percentage = widget.percentage;
                                      reqModel.standard = widget.standard;
                                      reqModel.userId =
                                          PreferenceManagerUtils.getPhoneNo();
                                      reqModel.studentFullName =
                                          widget.studentFullName;
                                      reqModel.mobileNumber = widget.mobile;
                                      reqModel.villageName = widget.villageName;
                                      reqModel.isApproved = false;
                                      reqModel.imageId = imageId;

                                      reqModel.fcmToken =
                                          PreferenceManagerUtils.getIsFCM();
                                      reqModel.documentStatus =
                                          DocumentStatusTypeEnum.pending.name;
                                      reqModel.documentReason = "";
                                      reqModel.createdDate =
                                          DateTime.now().toLocal().toString();
                                      reqModel.result = downloadURL;
                                      final status =
                                          await StudentService.studentDetails(
                                              reqModel);
                                      if (status) {
                                        hideLoadingDialog(context: context);
                                        Get.offAll(() => const HomeScreen());
                                      } else {
                                        hideLoadingDialog(context: context);
                                        ToastUtils.showCustomToast(
                                            context: context,
                                            title:
                                                StringUtils.somethingWentWrong);
                                      }
                                    }
                                  },
                                  title: StringUtils.submit.tr),
                            ),
                          ],
                        ),
                        // Positioned(
                        //     left: 0,
                        //     right: 0,
                        //     bottom: 90,
                        //     child: Align(
                        //       alignment: Alignment.center,
                        //       child: Text(StringUtils.copyRightsMadvise),
                        //     )),
                      ],
                    ),
                  ),
                )
              ],
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

  Future<void> _uploadImageToFirebase() async {
    if (selectedImage == null) {
      return;
    }

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String imagePath = 'images/$fileName.jpg';

      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(imagePath);

      await ref.putFile(File(selectedImage!.path));

      downloadURL = await ref.getDownloadURL();
      imageId = fileName;
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
