import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';
import 'package:EduPulse/utils/color_utils.dart';

void commomImageZoom(BuildContext context, String imageUrl) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
          backgroundColor: Colors.transparent,
          // shape:
          //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Center(
                  child: PhotoView(
                    // minScale: PhotoViewComputedScale.covered * 0.4,
                    // initialScale: PhotoViewComputedScale.contained *
                    //     1, // Set the initial scale size here
                    initialScale: PhotoViewComputedScale.contained * 1,
                    tightMode: true,
                    imageProvider: NetworkImage(
                      imageUrl,
                    ),
                    heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
                    scaleStateController: PhotoViewScaleStateController(),
                  ),
                ),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    splashRadius: 5,
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.cancel,
                        color: ColorUtils.primaryColor),
                  )),
            ],
          ),
        );
      },
    );
