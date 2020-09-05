import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/provider/class_provider.dart';
import 'package:schuul/src/data/provider/user_provider.dart';
import 'package:schuul/src/widgets/widget.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class AttendTeacherScreen extends StatefulWidget {
  @override
  _AttendTeacherScreenState createState() => _AttendTeacherScreenState();
}

class _AttendTeacherScreenState extends State<AttendTeacherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            "출결 관리",
            style: TextStyle(color: kTextColor),
          ),
          iconTheme: IconThemeData(
            color: kTextColor, //change your color here
          ),
          brightness: Brightness.light,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFFb5bfd0),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.0,
          actions: [],
        ),
        body: Consumer2<ClassProvider, UserProvider>(
          builder: (context, pClass, pUser, child) {
            DateFormat dateFormat = DateFormat('M월 d일 (E)', "ko_KO");
            return StreamBuilder(
              stream: pClass.myClass.documentSnapshot.reference
                  .collection(db_col_member)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return StickyHeadersTable(
                  columnsLength: pClass.myClass.days.length,
                  rowsLength: snapshot.data.documents.length,
                  columnsTitleBuilder: (i) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        dateFormat.format(pClass.myClass.days[i]),
                        style: TextStyle(fontSize: 16),
                      )),
                  rowsTitleBuilder: (i) {
                    Map doc = snapshot.data.documents[i].data;
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
                        Text(doc["name"])
                      ],
                    );
                  },
                  contentCellBuilder: (i, j) => Material(
                      child: InkWell(
                          onTap: () {
                            print("$i, $j");
                          },
                          child: Text("!"))),
                  legendCell: Text('학생 명단'),
                );
              },
            );
          },
        ));
  }
}
