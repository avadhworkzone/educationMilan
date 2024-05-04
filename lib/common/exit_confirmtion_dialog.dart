import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:Jamanvav/common/custom_text.dart';
import 'package:Jamanvav/utils/color_utils.dart';
import 'package:Jamanvav/utils/string_utils.dart';

class ExitConfirmationDialog {
  static Future<bool> showExitDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorUtils.white,
        title: CustomText(
          StringUtils.exitApp,
          color: ColorUtils.purple2D,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CustomText(StringUtils.areYouSureYouWantToExit,
                  color: ColorUtils.black),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: CustomText(
              StringUtils.yes,
              color: ColorUtils.purple2D,
            ),
            onPressed: () async {
              Navigator.of(context).pop(true); // User wants to exit
            },
          ),
          TextButton(
            child: CustomText(
              StringUtils.no,
              color: ColorUtils.purple2D,
            ),
            onPressed: () {
              Navigator.of(context).pop(false); // User doesn't want to exit
            },
          ),
        ],
      ),
    );
    return result ??
        false; // Return false if the dialog is dismissed by tapping outside it
  }
}
