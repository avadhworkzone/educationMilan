import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:Jamanvav/common/custom_text.dart';
import 'package:Jamanvav/common/custom_textstyle.dart';
import 'package:Jamanvav/utils/app_enum.dart';
import 'package:Jamanvav/utils/asset_utils.dart';
import 'package:Jamanvav/utils/color_utils.dart';
import 'package:Jamanvav/utils/no_leading_space_formatter.dart';
import 'package:Jamanvav/utils/regular_expression.dart';

typedef OnChangeString = void Function(String value);

class CommonTextField extends StatelessWidget {
  final TextEditingController? textEditController;
  final String? title;
  final String? initialValue;
  final bool? isValidate;
  final bool? readOnly;
  final TextInputType? keyBoardType;
  final ValidationTypeEnum? validationType;
  final String? regularExpression;
  final int? inputLength;
  final String? hintText;
  final String? validationMessage;

  final String? preFixIconPath;
  final int? maxLine;
  final Widget? sIcon;
  final Widget? pIcon;
  final bool? obscureValue;
  final bool? underLineBorder;
  final bool? showLabel;
  final OnChangeString? onChange;
  final Color? titleColor;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const CommonTextField({
    super.key,
    this.regularExpression,
    this.inputFormatters,
    this.validator,
    this.title,
    this.textEditController,
    this.isValidate = true,
    this.keyBoardType,
    this.validationType,
    this.inputLength,
    this.readOnly = false,
    this.underLineBorder = false,
    this.showLabel = false,
    this.hintText,
    this.validationMessage,
    this.maxLine,
    this.sIcon,
    this.pIcon,
    this.preFixIconPath,
    this.onChange,
    this.initialValue = '',
    this.obscureValue,
    this.titleColor = ColorUtils.charlestonGreen,
  });

  /// PLEASE IMPORT GET X PACKAGE
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        title == null || title!.isEmpty
            ? const SizedBox.shrink()
            : CustomText(
                title ?? '',
                color: ColorUtils.primary,
                fontSize: 12.sp,
              ),
        title == null || title!.isEmpty
            ? const SizedBox.shrink()
            : SizedBox(
                height: 2.5.w,
              ),
        TextFormField(
          controller: textEditController,
          style: underLineBorder!
              ? CustomTextStyle.textStyleInputField
                  .copyWith(color: ColorUtils.white)
              : CustomTextStyle.textStyleInputField
                  .copyWith(color: Colors.black),
          keyboardType: keyBoardType ?? TextInputType.text,
          maxLines: maxLine ?? 1,
          inputFormatters: [
            LengthLimitingTextInputFormatter(inputLength),
            FilteringTextInputFormatter.allow(RegExp(regularExpression ?? "")),
            NoLeadingSpaceFormatter()
          ],
          obscureText: validationType == ValidationTypeEnum.password
              ? obscureValue!
              : false,
          onChanged: onChange,
          enabled: !readOnly!,
          readOnly: readOnly!,
          validator: (value) {
            return isValidate == false
                ? null
                // : value!.isEmpty
                //     ? validationMessage ?? '* Required'
                : validationType == ValidationTypeEnum.email
                    ? ValidationMethod.validateEmail(value)
                    : validationType == ValidationTypeEnum.password
                        ? ValidationMethod.validatePassword(value)
                        : validationType == ValidationTypeEnum.pNumber
                            ? ValidationMethod.validatePhoneNumber(value)
                            : validationType == ValidationTypeEnum.name
                                ? ValidationMethod.validateName(value)
                                : validationType == ValidationTypeEnum.fName
                                    ? ValidationMethod.validateFName(value)
                                    : validationType ==
                                            ValidationTypeEnum.village
                                        ? ValidationMethod.validateVillage(
                                            value)
                                        : validationType ==
                                                ValidationTypeEnum.percentage
                                            ? ValidationMethod
                                                .validatePercentage(value)
                                            : null;
          },
          textInputAction:
              maxLine == 4 ? TextInputAction.none : TextInputAction.done,
          cursorColor: ColorUtils.grey5B,
          decoration: InputDecoration(
            isDense: true,
            // contentPadding:
            //     const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            // contentPadding:
            //     const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            hintText: hintText,
            errorStyle: TextStyle(
                color: Colors.red,
                // decoration: TextDecoration.none,
                // wordSpacing: 0,

                fontSize: 9.sp,
                fontFamily: AssetsUtils.poppins),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: ColorUtils.purple2D,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.transparent, width: 1),
            ),
            prefixIcon: pIcon,
            counterText: '',
            filled: true,
            fillColor: ColorUtils.greyF6,
            labelStyle: TextStyle(
                fontSize: 14.sp,
                color: ColorUtils.black,
                fontWeight: FontWeight.w600),
            hintStyle: TextStyle(
              color: ColorUtils.grey9C,
              fontSize: 11.sp,
              fontFamily: AssetsUtils.poppins,
            ),
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }
}
