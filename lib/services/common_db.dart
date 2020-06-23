import 'package:cloud_firestore/cloud_firestore.dart';

class CommonDB {
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
