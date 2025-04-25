import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/apiModel/student_detail_model.dart';
import '../utils/shared_preference_utils.dart';

class StudentService {
  /// Create student under: families/{familyCode}/users/{phone}/students/{studentId}
  static Future<bool> createStudent(StudentModel studentDetail) async {
    try {
      final familyCode = PreferenceManagerUtils.getFamilyCode();
      final phone = PreferenceManagerUtils.getPhoneNo();

      final docRef = FirebaseFirestore.instance
          .collection('families')
          .doc(familyCode)
          .collection('users')
          .doc(phone)
          .collection('results')
          .doc(); // auto-generated ID

      studentDetail.studentId = docRef.id;
      studentDetail.userId = phone;
      studentDetail.familyCode = familyCode;
      studentDetail.createdDate = DateTime.now().toIso8601String();

      await docRef.set(studentDetail.toJson());

      return true;
    } catch (e) {
      print('CREATE STUDENT ERROR: $e');
      return false;
    }
  }

  /// Get student data for current family/user
  static Stream<List<StudentModel>> getAppointmentData() {
    final familyCode = PreferenceManagerUtils.getFamilyCode();
    final phone = PreferenceManagerUtils.getPhoneNo();

    final studentRef = FirebaseFirestore.instance
        .collection('families')
        .doc(familyCode)
        .collection('users')
        .doc(phone)
        .collection('students')
        .orderBy('createdDate', descending: true);

    return studentRef.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => StudentModel.fromJson(doc.data()))
        .toList());
  }

  /// Update student details
  static Future<bool> updateStudent(StudentModel studentDetail) async {
    try {
      final familyCode = PreferenceManagerUtils.getFamilyCode();
      final phone = PreferenceManagerUtils.getPhoneNo();

      final docRef = FirebaseFirestore.instance
          .collection('families')
          .doc(familyCode)
          .collection('users')
          .doc(phone)
          .collection('results')
          .doc(studentDetail.studentId); // same collection as in createStudent

      // Optionally update modified date
      // studentDetail.updatedDate = DateTime.now().toIso8601String();

      await docRef.update(studentDetail.toJson());
      return true;
    } catch (e, stackTrace) {
      print('UPDATE STUDENT ERROR: $e');
      print('STACK TRACE: $stackTrace');
      return false;
    }
  }
  ///get result
  static Stream<List<StudentModel>> getResultsForCurrentUser() {
    final familyCode = PreferenceManagerUtils.getFamilyCode();
    final phone = PreferenceManagerUtils.getPhoneNo();

    return FirebaseFirestore.instance
        .collection('families')
        .doc(familyCode)
        .collection('users')
        .doc(phone)
        .collection('results')
        .orderBy('createdDate', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => StudentModel.fromJson(doc.data())).toList());
  }


  /// Delete student
  static Future<bool> deleteStudent(String studentId) async {
    try {
      final familyCode = PreferenceManagerUtils.getFamilyCode();
      final phone = PreferenceManagerUtils.getPhoneNo();

      final docRef = FirebaseFirestore.instance
          .collection('families')
          .doc(familyCode)
          .collection('users')
          .doc(phone)
          .collection('results')
          .doc(studentId);

      await docRef.delete();
      return true;
    } catch (e) {
      print('DELETE STUDENT ERROR: $e');
      return false;
    }
  }
}
