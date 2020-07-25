import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/respond_type.dart';
import 'package:schuul/src/data/provider/class_provider.dart';
import 'package:schuul/src/widgets/widget.dart';

class MemberAcceptScreen extends StatefulWidget {
  @override
  _MemberAcceptScreenState createState() => _MemberAcceptScreenState();
}

class _MemberAcceptScreenState extends State<MemberAcceptScreen> {
  _deleteRequest(String uid, String classDocumentId,
      DocumentReference documentReference) async {
    // request  삭제
    await documentReference.delete();
    //유저 request 목록에서 수업 삭제
    Firestore.instance.document("user/$uid").updateData({
      db_field_requestList: FieldValue.arrayRemove([classDocumentId])
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarLeading(context, "멤버 등록 요청", Icon(Icons.close), []),
      body: Scaffold(
          body: Consumer<ClassProvider>(
        builder: (context, pClass, child) => StreamBuilder(
          stream: pClass.myClass.documentSnapshot.reference
              .collection(db_col_request)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data.documents.isEmpty) {
              return Center(
                child: Text("새로운 멤버등록 요청이 없습니다"),
              );
            }

            return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (_, index) {
                  Map doc = snapshot.data.documents[index].data;
                  bool hasPhoto = false;
                  if (doc.containsKey("photoUrl") &&
                      doc["photoUrl"] != null &&
                      doc["photoUrl"].length > 0) {
                    hasPhoto = true;
                  }
                  return Padding(
                      padding: EdgeInsets.all(10),
                      child: Material(
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                              child: Card(
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: Row(
                                  children: [
                                    hasPhoto
                                        ? ExtendedImage.network(doc["photoUrl"],
                                            width: 75,
                                            height: 75,
                                            fit: BoxFit.fill,
                                            cache: true,
                                            shape: BoxShape.circle,
                                            loadStateChanged:
                                                myloadStateChanged)
                                        : ExtendedImage.asset(
                                            "assets/images/login_bottom.png",
                                            width: 75,
                                            height: 75,
                                            fit: BoxFit.fill,
                                            shape: BoxShape.circle,
                                            loadStateChanged:
                                                myloadStateChanged),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Text(doc["name"]),
                                    ),
                                    IconButton(
                                      color: kPrimaryColor,
                                      icon: Icon(Icons.check),
                                      onPressed: () async {
                                        RespondType res =
                                            await customShowDialog(context,
                                                "멤버 승인", "멤버를 승인하시겠습니까?");
                                        if (res == RespondType.yes) {
                                          //멤버 컬렉션에 추가
                                          pClass.myClass.documentSnapshot
                                              .reference
                                              .collection(db_col_member)
                                              .document(doc["uid"])
                                              .setData(doc);
                                          //멤버 인덱스 array에 추가
                                          pClass.myClass.documentSnapshot
                                              .reference
                                              .updateData({
                                            db_field_member:
                                                FieldValue.arrayRemove(
                                                    [doc["uid"]])
                                          });
                                          // 리퀘스트 컬렉션에서 제거
                                          _deleteRequest(
                                              doc["uid"],
                                              pClass.myClass.documentSnapshot
                                                  .reference.documentID,
                                              snapshot.data.documents[index]
                                                  .reference);
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      color: kRedColor,
                                      icon: Icon(Icons.close),
                                      onPressed: () async {
                                        RespondType res =
                                            await customShowDialog(context,
                                                "멤버 거절", "멤버 요청을 거절하시겠습니까?");
                                        if (res == RespondType.yes) {
                                          _deleteRequest(
                                              doc["uid"],
                                              pClass.myClass.documentSnapshot
                                                  .reference.documentID,
                                              snapshot.data.documents[index]
                                                  .reference);
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                )),
                          )),
                        ),
                      ));
                });
          },
        ),
      )),
    );
  }
}
