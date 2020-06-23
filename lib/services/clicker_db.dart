import 'package:cloud_firestore/cloud_firestore.dart';

class ClickerDBMethod {
  Future<void> addClicker(classData) async {
    Firestore.instance.collection("class").add(classData).catchError((e) {
      print(e.toString());
    });
  }

  getClicker() async {
    return Firestore.instance
        .collection("class")
//        .where("userEmail", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> deleteAll(collectionName) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection(collectionName)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
    snapshot.documents.forEach((f) {
      f.reference.delete();
    });
  }
}
