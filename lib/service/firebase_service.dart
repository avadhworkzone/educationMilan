import 'package:cloud_firestore/cloud_firestore.dart';

List<String> standardsList = [];
List<String> villageList = [];

class FirestoreService {
  final CollectionReference standardsCollection = FirebaseFirestore.instance.collection('standardList');

  final CollectionReference villageCollection = FirebaseFirestore.instance.collection('villageList');

  Future<List<String>> getStandards() async {
    QuerySnapshot querySnapshot = await standardsCollection.get();
    standardsList = querySnapshot.docs.map((doc) => (doc['standard'] as String?) ?? '').toList();
    return standardsList;
  }

  ///VILLAGE LIST.....
  Future<List<String>> getVillageName() async {
    QuerySnapshot querySnapshot = await villageCollection.get();
    villageList = querySnapshot.docs.map((doc) => (doc['villageName'] as String?) ?? '').toList();
    return villageList;
  }
}
