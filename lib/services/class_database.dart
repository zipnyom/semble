import 'package:cloud_firestore/cloud_firestore.dart';

class ClassDatabaseMethods {
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
}
