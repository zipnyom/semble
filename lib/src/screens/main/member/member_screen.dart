import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/provider/class_option_provider.dart';
import 'package:schuul/src/screens/main/member/member_accept_screen.dart';
import 'package:schuul/src/widgets/widget.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class MemberScreen extends StatefulWidget {
  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  final columns = 50;
  final rows = 100;

  List<List<String>> _makeData() {
    final List<List<String>> output = [];
    for (int i = 0; i < columns; i++) {
      final List<String> row = [];
      for (int j = 0; j < rows; j++) {
        row.add('T$i : L$j');
      }
      output.add(row);
    }
    return output;
  }

  /// Simple generator for column title
  List<String> _makeTitleColumn() => List.generate(columns, (i) => 'Top $i');

  /// Simple generator for row title
  List<String> _makeTitleRow() => List.generate(rows, (i) => 'Left $i');

  @override
  Widget build(BuildContext context) {
    List<List<String>> data = _makeData();
    List<String> titleColumn = _makeTitleColumn();
    List<String> titleRow = _makeTitleRow();
    return Scaffold(
      appBar: customAppBarLeading(context, "학생 관리", Icon(Icons.close), []),
      body: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              ListTile(
                title: Row(
                  children: [
                    Text("새로운 요청"),
                    SizedBox(
                      width: 16,
                    ),
                    Consumer<ClassProvider>(builder: (context, pClass, child) {
                      return StreamBuilder(
                        stream: pClass.myClass.documentSnapshot.reference
                            .collection(db_col_request)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.active) {
                            return CircularProgressIndicator();
                          }
                          if (snapshot.data.documents.length == 0) {
                            return SizedBox.shrink();
                          }
                          return Badge(
                            padding: EdgeInsets.all(8),
                            badgeColor: Colors.redAccent[200],
                            badgeContent: Text(
                              "${snapshot.data.documents.length}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MemberAcceptScreen(),
                  ));
                },
              ),
              Consumer<ClassProvider>(
                builder: (context, pClass, child) => StreamBuilder(
                    stream: pClass.myClass.documentSnapshot.reference
                        .collection(db_col_member)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.active) {
                        return Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [CircularProgressIndicator()],
                          ),
                        );
                      }
                      if (snapshot.data.documents.isEmpty) {
                        return Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("아직 등록된 학생이 없습니다")],
                          ),
                        );
                      }
                      List<DocumentSnapshot> docList = snapshot.data.documents;
                      List<String> keys = docList.first.data.keys.toList();

                      return Expanded(
                        child: StickyHeadersTable(
                          columnsLength: keys.length,
                          rowsLength: snapshot.data.documents.length,
                          columnsTitleBuilder: (i) => Text(keys[i]),
                          rowsTitleBuilder: (i) {
                            Map doc = docList[i].data;
                            bool hasPhoto = false;
                            if (doc.containsKey("photoUrl") &&
                                doc["photoUrl"] != null &&
                                doc["photoUrl"].length > 0) {
                              hasPhoto = true;
                            }
                            return Row(
                              children: [
                                hasPhoto
                                    ? ExtendedImage.network(doc["photoUrl"],
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.fill,
                                        cache: true,
                                        shape: BoxShape.circle,
                                        loadStateChanged: myloadStateChanged)
                                    : ExtendedImage.asset(
                                        "assets/images/login_bottom.png",
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.fill,
                                        shape: BoxShape.circle,
                                        loadStateChanged: myloadStateChanged),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(docList[i].data["name"])
                              ],
                            );
                          },
                          contentCellBuilder: (i, j) => Material(
                              child: InkWell(
                                  onTap: () {
                                    print("$i, $j");
                                  },
                                  child: Text(data[i][j]))),
                          legendCell: Text('학생 명단'),
                        ),
                      );
                      // return ListView.builder(
                      //     shrinkWrap: true,
                      //     physics: ClampingScrollPhysics(),
                      //     itemCount: snapshot.data.documents.length,
                      //     itemBuilder: (_, index) {
                      //       return ListTile(
                      //         title: snapshot.data.documents[index]
                      //             ["displayName"],
                      //       );
                      //     });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
