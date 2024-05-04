import 'dart:ui';

import 'package:EduPulse/utils/string_utils.dart';

Map<String, String> gu = {
  StringUtils.appVersion: "",
  StringUtils.appName: "કાત્રોડિયા પરિવાર",
  StringUtils.details: "વિગતો",
  StringUtils.copyRightsMadvise: "@copyright madviseinfotech®",
  StringUtils.somethingWentWrong: "કંઈક ખોટું થયું!",
  StringUtils.logout: "લૉગ આઉટ",
  StringUtils.update: "અપડેટ કરો",
  StringUtils.signupSuccessfully: "સફળતાપૂર્વક સાઇન અપ કરો",
  StringUtils.invalidPin: "અમાન્ય પિન",
  StringUtils.pleaseEnterPin: "કૃપા કરીને પિન દાખલ કરો",
  StringUtils.deleteSuccessfully: "સફળતાપૂર્વક કાઢી નાખ્યું",
  StringUtils.uploadYourImage: "તમારી છબી 15 MB કરતા ઓછી અપલોડ કરો",
  StringUtils.isValidEmail: "Is Valid Email",
  StringUtils.minimumCharterHint: "minimum charter hint",
  StringUtils.enterYourNumber: "તમારો નંબર દાખલ કરો",
  StringUtils.enterYourEmail: "તમારું ઈમેલ એડ્રેસ લખો",
  StringUtils.enterDigit: "કૃપા કરીને માન્ય ફોન નંબર દાખલ કરો",
  StringUtils.isValidName: "Is Valid Name",
  StringUtils.isValidFName: "Is Valid Father Name",
  StringUtils.noInterNetMessage:
      "કોઈ ઈન્ટરનેટ કનેક્શન મળ્યું નથી \n તમારું કનેક્શન તપાસો",

  /// splash screen
  StringUtils.snehMilan: 'Snehmilan',
  StringUtils.logoutTitle: 'શું તમે ખરેખર લોગ આઉટ કરવા માંગો છો?',
  StringUtils.updateAvailable: 'અપડેટ ઉપલબ્ધ છે',
  StringUtils.deleteTitle: 'શું તમે ખરેખર કાઢી નાખવા માંગો છો?',
  StringUtils.delete: 'કાઢી નાખો',
  StringUtils.cancel: 'રદ કરો',

  /// Signup Screen
  StringUtils.welcome: 'Welcome!',
  StringUtils.fullName: 'પૂરું નામ',
  StringUtils.studentFullName: 'વિદ્યાર્થી નું પૂરું નામ',
  StringUtils.fatherFullName: 'પિતાજી નું પૂરું નામ ',
  StringUtils.villageName: 'ગામ નું નામ',
  StringUtils.phoneNumber: 'ફોન નંબર ',
  StringUtils.signUp: 'SIGN UP',
  StringUtils.login: 'LOGIN',
  StringUtils.pleaseSelectOneImageFromTheList:
      'કૃપા કરીને સૂચિમાંથી એક છબી પસંદ કરો',
  StringUtils.pleaseChooseAtLeastOneImageBeforeSubmitting:
      'સબમિટ કરતા પહેલા કૃપા કરીને ઓછામાં ઓછી એક છબી પસંદ કરો',
  StringUtils.signupDone: "સફળતાપૂર્વક Signup...",
  StringUtils.alreadyExist: "નંબર પહેલેથી જ અસ્તિત્વમાં છે!",
  StringUtils.addPin: 'Add PIN',
  StringUtils.createPin: 'PIN બનાવો',
  StringUtils.enterEmail: 'ઈમેલ દાખલ કરો',
  StringUtils.confirmPin: 'PIN ની પુષ્ટિ કરો',
  StringUtils.forgetPin: 'પિન ભૂલી ગયા છો?',
  StringUtils.next: 'આગળ',
  StringUtils.image: 'કૃપા કરીને છબી પસંદ કરો',
  StringUtils.requestSend: 'તમારી વિનંતી સફળતાપૂર્વક મોકલી',
  StringUtils.emailIsRequired: "ઇમેઇલ આવશ્યક છે",
  StringUtils.pleaseEnterValidEmail: "કૃપા કરીને માન્ય ઇમેઇલ દાખલ કરો",

  /// student detail screen
  StringUtils.studentDetails: 'વિદ્યાર્થીની વિગતો',
  StringUtils.standard: 'ધોરણ',
  StringUtils.percentage: 'ટકાવારી(%)',
  StringUtils.selectStandard: 'ધોરણ પસંદ કરો',
  StringUtils.uploadAPhotoOfYourResult: 'તમારા પરિણામનો ફોટો અપલોડ કરો',
  StringUtils.dragAndDropResultHere: 'પરિણામ અહીં ખેંચો અને છોડો',
  StringUtils.or: 'Or',
  StringUtils.xYZShah10thResult: 'XYZ Shah 10th result',
  StringUtils.text100: '100%',

  /// exit dialog
  StringUtils.yes: "હા",
  StringUtils.no: "ના",
  StringUtils.exitApp: "બહાર નીકળો",
  StringUtils.areYouSureYouWantToExit:
      "શું તમે ખરેખર આ એપ્લિકેશનમાંથી બહાર નીકળવા માંગો છો?",

  ///Home Screen
  StringUtils.noResult: "કોઈ પરિણામો મળ્યાં નથી",
  StringUtils.signUpSuccessfully: "સફળતાપૂર્વક સાઇન અપ",
  StringUtils.save: "સાચવો",
  StringUtils.viewReason: "કારણ જુઓ",
  StringUtils.reasonForReject: "અસ્વીકાર નુ કારણ જુઓ",
  StringUtils.mob1: "મોબાઈલ નંબર ૧",
  StringUtils.mob2: "મોબાઈલ નંબર ૨",
  StringUtils.nameValidation: "કૃપા કરીને વિદ્યાર્થીનું પૂરું નામ દાખલ કરો",
  StringUtils.fNameValidation: "કૃપા કરીને પિતાનું પૂરું નામ દાખલ કરો",
  StringUtils.villageValidation: "કૃપા કરીને ગામનું નામ દાખલ કરો",
  StringUtils.personaTageValidation: "ટકાવારી દાખલ કરો",
  StringUtils.nameInvalid:
      "અમાન્ય પૂર્ણ નામ ફોર્મેટ. પ્રથમ નામ અને છેલ્લું નામ વાપરો.",
  StringUtils.fullname: "પૂરું નામ જરૂરી છે",
  StringUtils.mobileNoLength: "ફોન નંબર 10 અંકનો હોવો જોઈએ",
  StringUtils.phoneIsRequired: "ફોન નંબર જરૂરી છે",
  StringUtils.mobileNoLengthMoreThan10: "ફોન નંબર 10 અક્ષરથી વધુ ન હોઈ શકે",
  StringUtils.addImage: "છબી ઉમેરો",
  StringUtils.submit: "સબમિટ કરો",
  StringUtils.lang: "ભાષા પસંદ કરો",
  StringUtils.selectVillage: "ગામ પસંદ કરો",
  StringUtils.chooseFromGallery: "ગેલેરીમાંથી પસંદ કરો",
  StringUtils.takePhoto: "ફોટો પાડો",
  StringUtils.forEnglishGrade: "જો તમારી પાસે ગ્રેડ છે તો ટકાવારીમાં 99 મૂકો.",
  StringUtils.lastDate:
      "પરિણામ સબમિટ કરવાની છેલ્લી તારીખ છે. કૃપા કરીને તે પહેલાં સબમિટ કરો.     ",
};
