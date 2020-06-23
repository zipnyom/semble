import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  Future<void> addClass(classData) async {
    Firestore.instance.collection("class").add(classData).catchError((e) {
      print(e.toString());
    });
  }

  getClass() async {
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
      print(f.data["class_name"]);
      f.reference.delete();
    });
  }
}
