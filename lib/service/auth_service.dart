import '../utils/collection_utils.dart';

class AuthService {
  static Future<bool> checkUserExist({required String docId}) async {
    return CollectionUtils.userCollection
        .doc(docId)
        .get()
        .then((value) => value.exists ? true : false)
        .catchError((e) {
      print('CHECK USER EXIST ERROR:=>$e');
      return false;
    });
  }

  static Future<bool> checkLogin(
      {required String docId, required String pin}) async {
    try {
      var value = await CollectionUtils.userCollection.doc(docId).get();
      if (value.data()?['Pin'].toString() == pin.toString()) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('CHECK USER EXIST ERROR:=>$e');
      return false;
    }
  }

  static Future<bool> signUp(Map<String, dynamic> user, String phoneNo) async {
    return CollectionUtils.userCollection
        .doc(phoneNo)
        .set(user)
        .then((value) => true)
        .catchError((e) {
      print('SIGN UP ERROR :=>$e');
      return false;
    });
  }
}
