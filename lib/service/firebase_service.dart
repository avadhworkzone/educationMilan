import 'package:cloud_firestore/cloud_firestore.dart';

List<String> standardsList = [];
List<String> villageList = [];

class FirestoreService {
  Future<List<String>> getStandardsByFamily(String familyCode) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('families')
          .doc(familyCode)
          .collection('standerd')
          .doc('standerd')
          .get();

      if (doc.exists) {
        List<dynamic> data = doc['standerd'] ?? [];
        standardsList = data.map((e) => e.toString()).toList();
      }
      return standardsList;
    } catch (e) {
      print('Error fetching standards: $e');
      return [];
    }
  }

  Future<List<String>> getVillagesByFamily(String familyCode) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('families')
          .doc(familyCode)
          .collection('village')
          .doc('villages')
          .get();

      if (doc.exists) {
        List<dynamic> data = doc['villages'] ?? [];
        villageList = data.map((e) => e.toString()).toList();
      }
      return villageList;
    } catch (e) {
      print('Error fetching villages: $e');
      return [];
    }
  }
}
