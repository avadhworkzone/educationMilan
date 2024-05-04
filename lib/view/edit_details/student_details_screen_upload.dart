import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';
import 'package:Jamanvav/common/common_image_zoom.dart';
import '../../common/custom_text.dart';
import '../../common/custom_textfield.dart';
import '../../service/firebase_service.dart';
import '../../utils/app_enum.dart';
import '../../utils/color_utils.dart';
import '../../utils/regular_expression.dart';
import '../../utils/string_utils.dart';
import 'edit_screen.dart';

class StudentDetailsScreenUpLoad extends StatefulWidget {
  final String? image;
  final num? personTage;
  final String? standard;
  final String? fullName;
  final String studentId;
  final String imageId;
  final String userId;
  final String villageName;
  final String? createdDate;
  final String? status;
  final String? mobile;

  const StudentDetailsScreenUpLoad(
      {Key? key,
      this.standard,
      this.createdDate,
      this.image,
      this.personTage,
      this.fullName,
      this.status,
      this.mobile,
      required this.userId,
      required this.imageId,
      required this.villageName,
      required this.studentId})
      : super(key: key);

  @override
  State<StudentDetailsScreenUpLoad> createState() =>
      _StudentDetailsScreenUpLoadState();
}

class _StudentDetailsScreenUpLoadState
    extends State<StudentDetailsScreenUpLoad> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();
  final TextEditingController standardController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  Future<List<String>>? standardsListFuture;
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    fullNameController.text = widget.fullName.toString();
    percentageController.text = widget.personTage.toString();
    standardController.text = widget.standard.toString();
    villageController.text = widget.villageName.toString().capitalizeFirst!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.purple2D,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: ColorUtils.white)),
                CustomText(
                  StringUtils.details,
                  color: ColorUtils.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(
                  width: 5.w,
                ),

                ///COMMENT BY B-Dev
                widget.status == DocumentStatusTypeEnum.pending.name
                    ? InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Get.to(() => EditScreen(
                              personTage: widget.personTage,
                              image: widget.image,
                              standard: widget.standard,
                              fullName: widget.fullName,
                              studentId: widget.studentId,
                              userId: widget.userId,
                              villageName: widget.villageName,
                              imageId: widget.imageId,
                              mobile: widget.mobile,
                              status: widget.status,
                              createdDate: widget.createdDate));
                        },
                        child: Image.asset("assets/images/edit.png",
                            height: Get.width * 0.08),
                      )
                    : SizedBox()
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
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: InkWell(
                          onTap: () {
                            commomImageZoom(context, widget.image.toString());
                          },
                          child: Container(
                            height: 200,
                            width: 400,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                widget.image.toString(),
                                height: 200,
                                width: 400,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
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
                        readOnly: true,
                      ),
                      SizedBox(
                        height: 2.w,
                      ),
                      CustomText(
                        StringUtils.villageName,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(
                        height: 1.w,
                      ),

                      /// village field
                      CommonTextField(
                        textEditController: villageController,
                        regularExpression:
                            RegularExpressionUtils.alphabetSpacePattern,
                        keyBoardType: TextInputType.name,
                        validationType: ValidationTypeEnum.village,
                        readOnly: true,
                      ),
                      SizedBox(
                        height: 4.w,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                width: 45.w,
                                child: CommonTextField(
                                  textEditController: standardController,
                                  regularExpression:
                                      RegularExpressionUtils.percentagePattern,
                                  keyBoardType: TextInputType.number,
                                  validationType: ValidationTypeEnum.percentage,
                                  readOnly: true,
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
                                  regularExpression:
                                      RegularExpressionUtils.percentagePattern,
                                  keyBoardType: TextInputType.number,
                                  validationType: ValidationTypeEnum.percentage,
                                  readOnly: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }

  // void commomImageZoom(BuildContext context, String imageUrl) => showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           insetPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
  //           backgroundColor: Colors.transparent,
  //           // shape:
  //           //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //           child: Stack(
  //             children: [
  //               ClipRRect(
  //                 borderRadius: BorderRadius.circular(10),
  //                 child: Center(
  //                   child: PhotoView(
  //                     // minScale: PhotoViewComputedScale.covered * 0.4,
  //                     // initialScale: PhotoViewComputedScale.contained *
  //                     //     1, // Set the initial scale size here
  //                     initialScale: PhotoViewComputedScale.contained * 1,
  //                      tightMode: true,
  //                     imageProvider: NetworkImage(
  //                       imageUrl,
  //                     ),
  //                     heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
  //                     scaleStateController: PhotoViewScaleStateController(),
  //
  //                   ),
  //                 ),
  //               ),
  //               Positioned(
  //                   top: 0,
  //                   right: 0,
  //                   child: IconButton(
  //                     splashRadius: 5,
  //                     onPressed: () => Get.back(),
  //                     icon: const Icon(Icons.cancel,
  //                         color: ColorUtils.primaryColor),
  //                   )),
  //             ],
  //           ),
  //         );
  //       },
  //     );
}
