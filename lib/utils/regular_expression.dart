import 'package:Jamanvav/utils/string_utils.dart';
import 'package:get/get.dart';

class RegularExpressionUtils {
  ///IN USED..
  static String emailPattern = r"[a-zA-Z0-9$_@.-]";
  static String alphabetSpacePattern = "[a-zA-Z ]";

  ///NOT USED CURRENTLY...

  static String passwordPattern = r"[a-zA-Z0-9#!_@$%^&*-]";
  static String alphabetDigitSpacePattern = r"[a-zA-Z0-9#&$%_@.'?+ ]";
  static String alphabetDigitsNotSpacePattern = r"[a-zA-Z0-9]";
  static String alphabetDigitsSpacePlusPattern = r"[a-zA-Z0-9+ ]";
  static String digitsPattern = r"[0-9]";
  static String pricePattern = r'^\d+\.?\d*';
  static String percentagePattern = r'^\d+\.?\d{0,2}';

  /// Validation Expression Pattern
  static String emailValidationPattern = r"([a-zA-Z0-9_@.])";
}

/// VALIDATION METHOD
class ValidationMethod {
  /// EMAIL VALIDATION METHOD
  static String? validateEmail(value) {
    bool regex =
        RegExp(RegularExpressionUtils.emailValidationPattern).hasMatch(value!);
    if ((value as String).isEmpty) {
      return StringUtils.emailIsRequired.tr;
    } else if (regex == false) {
      return StringUtils.pleaseEnterValidEmail.tr;
    }
    return null;
  }

  bool isValidEmail(String value) {
    final emailRegExp = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
      caseSensitive: false,
    );
    return emailRegExp.hasMatch(value);
  }

  /// PASSWORD VALIDATION METHOD
  static String? validatePassword(value) {
    if (value == null) {
      return ValidationMsg.isRequired;
    } else if (value.length < 8) {
      return StringUtils.minimumCharterHint.tr;
    }
    return null;
  }

  /// PHONE NUMBER VALIDATION METHOD
  static String? validatePhoneNumber(value) {
    if (value == null) {
      return ValidationMsg.isRequired;
    } else if (value.length > 10) {
      return StringUtils.enterDigit.tr;
    } else if (value.length < 10) {
      return StringUtils.enterDigit.tr;
    }
    return null;
  }

  /// NAME VALIDATION METHOD
  static String? validateName(value) {
    bool regex =
        RegExp(RegularExpressionUtils.alphabetSpacePattern).hasMatch(value);
    if (value == null) {
      return ValidationMsg.nameValidation.tr;
    } else if (regex == false) {
      return ValidationMsg.nameValidation.tr;
    }
    StringUtils.isValidName = 'true';
    return null;
  }

  /// FATHER VALIDATION METHOD
  static String? validateFName(value) {
    bool regex =
        RegExp(RegularExpressionUtils.alphabetSpacePattern).hasMatch(value);
    if (value == null) {
      return ValidationMsg.fNameValidation.tr;
    } else if (regex == false) {
      return ValidationMsg.fNameValidation.tr;
    }
    StringUtils.isValidFName = 'true';
    return null;
  }

  /// VILLAGE VALIDATION METHOD
  static String? validateVillage(value) {
    bool regex =
        RegExp(RegularExpressionUtils.alphabetSpacePattern).hasMatch(value);
    if (value == null) {
      return ValidationMsg.villageValidation.tr;
    } else if (regex == false) {
      return ValidationMsg.villageValidation.tr;
    }
    StringUtils.isValidName = 'true';
    return null;
  }

  /// PHONE NUMBER VALIDATION METHOD
  static String? validatePercentage(value) {
    if (value.isEmpty) {
      return ValidationMsg.personaTageValidation.tr;
    }

    double? parsedValue = double.tryParse(value);

    if (parsedValue == null || parsedValue < 1 || parsedValue > 100) {
      return '1 - 100 (%)';
    }
    return null;
  }
}

/// VALIDATION MESSAGE WITH
class ValidationMsg {
  static String isRequired = "is required";
  static String nameValidation = StringUtils.nameValidation;
  static String fNameValidation = StringUtils.fNameValidation;
  static String villageValidation = StringUtils.villageValidation;
  static String personaTageValidation = StringUtils.personaTageValidation;
  static String nameInvalid = StringUtils.nameInvalid;
  static String fullname = StringUtils.fullname;

  ///phone number
  static String mobileNoLength = StringUtils.mobileNoLength;
  static String mobileNoLengthMoreThan10 = StringUtils.mobileNoLengthMoreThan10;
  static String phoneIsRequired = StringUtils.phoneIsRequired;
}
