import '../model/apiModel/student_detail_model.dart';
import '../utils/collection_utils.dart';

class StudentService {
  static Future<bool> studentDetails(StudentModel studentDetail) async {
    final doc = CollectionUtils.studentDetails.doc();
    studentDetail.studentId = doc.id;
    return doc
        .set(studentDetail.toJson())
        .then((value) => true)
        .catchError((e) {
      print('SIGN UP ERROR :=>$e');
      return false;
    });
  }

  ///=======================get data===================///
  static Stream<List<StudentModel>> getAppointmentData() {
    return CollectionUtils.studentDetails
        .orderBy('createdDate', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => StudentModel.fromJson(e.data())).toList());
  }

  ///=======================update data===================///
  static Future<bool> studentDetailsEdit(StudentModel studentDetail) async {
    final doc = CollectionUtils.studentDetails.doc(studentDetail.studentId);
    return doc
        .update(studentDetail.toJson())
        .then((value) => true)
        .catchError((e) {
      print('APPOINTMENT UPDATE ERROR :=>$e');
      return false;
    });
  }

  ///delete data
  static Future<bool> deleteAccountData(String id) async {
    return CollectionUtils.studentDetails
        .doc(id)
        .delete()
        .then((value) => true)
        .catchError((e) {
      print(' delete ERROR :=>$e');
      return false;
    });
  }

  ///=======================delete data===================///
  static Future<bool> deleteStudent(String studentId) async {
    try {
      await CollectionUtils.studentDetails.doc(studentId).delete();
      return true;
    } catch (e) {
      print('DELETE ERROR :=> $e');
      return false;
    }
  }
}
