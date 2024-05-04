import 'package:flutter/material.dart';
import 'package:Jamanvav/utils/color_utils.dart';

class DecorationUtils {
  static BoxDecoration shadowDecoration = BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.20),
        ),
        const BoxShadow(
          color: Colors.white,
          spreadRadius: 0.1,
          blurRadius: 03.0,
        ),
      ],
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: ColorUtils.primary));

  /// TEXT FIELD OUTLINE DECORATION
  static InputBorder outLineSilverSand = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: ColorUtils.greyE7));

  static BoxDecoration homeDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(color: ColorUtils.black.withOpacity(0.1), blurRadius: 3)
      ]);
}
