import 'package:cloud_firestore/cloud_firestore.dart';

class TextConfig {
  static const user = 'UserDetails';
  static const studentDetails = 'StudentDetails';
  static const appMetaData = 'appMetaData';
}

class CollectionUtils {
  static final userCollection =
      FirebaseFirestore.instance.collection(TextConfig.user);
  static final studentDetails =
      FirebaseFirestore.instance.collection(TextConfig.studentDetails);
  static final appMetaDataCollection =
      FirebaseFirestore.instance.collection(TextConfig.appMetaData);
}
