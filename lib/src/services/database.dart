import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<DocumentReference> addItem(String collection, dynamic item) async {
    return await Firestore.instance
        .collection(collection)
        .add(item)
        .catchError((e) {
      print(e.toString());
    });
  }

  selectAll(String collection) async {
    return Firestore.instance
        .collection(collection)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> deleteAll(collection) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection(collection)
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

DatabaseService databaseService = DatabaseService();
