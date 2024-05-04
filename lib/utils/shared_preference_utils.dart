import 'package:get_storage/get_storage.dart';

class PreferenceManagerUtils {
  static final getStorage = GetStorage();

  static const userData = "USER_DATA";
  static String isLogin = "isLogin";
  static String isLang = "isLang";
  static String fcm = "fcm";
  static String phoneNo = 'phoneNo';

  ///IsLogin
  static Future setIsLogin(bool value) async {
    await getStorage.write(isLogin, value);
  }

  static bool getIsLogin() {
    return getStorage.read(isLogin) ?? false;
  }

  ///fcm
  static Future setIsFCM(String value) async {
    await getStorage.write(fcm, value);
  }

  static String getIsFCM() {
    return getStorage.read(fcm) ?? "";
  }

  ///language
  static Future setIsLang(bool value) async {
    await getStorage.write(isLang, value);
  }

  static bool getIsLang() {
    return getStorage.read(isLang) ?? true;
  }

  ///phone no
  static Future setPhoneNo(String value) async {
    await getStorage.write(phoneNo, value);
  }

  static String getPhoneNo() {
    return getStorage.read(phoneNo) ?? "";
  }

  /// USER DATA
  static Future<void> setUserData(String value) async {
    await getStorage.write(userData, value);
  }

  static String getUserData() {
    return getStorage.read(userData) ?? "";
  }

  static Future<void> clearPreference() async {
    await getStorage.erase();
  }
}
