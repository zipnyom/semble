import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/provider/class_option_provider.dart';
import 'package:schuul/src/data/provider/user_provider.dart';

class AttendStudentScreen extends StatefulWidget {
  @override
  _AttendStudentScreenState createState() => _AttendStudentScreenState();
}

class _AttendStudentScreenState extends State<AttendStudentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            "나의 출결",
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
            return StreamBuilder<DocumentSnapshot>(
                stream: pClass.myClass.documentSnapshot.reference
                    .collection(db_col_member)
                    .document(pUser.user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  DateFormat dateFormat = DateFormat('M월 d일 (E)', "ko_KO");
                  List<dynamic> attendList = snapshot.data["attend"] ?? [];
                  List<String> attendStrList = [];
                  attendList.forEach((element) {
                    attendStrList.add(
                        dateFormat.format((element as Timestamp).toDate()));
                  });
                  if (pClass.myClass.days.length == 0) {
                    return Center(
                      child: Text("등록된 수업이 없습니다"),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: pClass.myClass.days.length,
                      itemBuilder: (_, index) {
                        bool checked = false;
                        bool isAfter = false;
                        DateTime day = pClass.myClass.days[index];
                        String dateString = dateFormat.format(day);
                        if (day.isAfter(DateTime.now())) {
                          isAfter = true;
                        }
                        if (attendList.contains(dateString)) {
                          checked = true;
                        }
                        return Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: Material(
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                    child: Card(
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            dateString,
                                            style: TextStyle(
                                                color: isAfter
                                                    ? Colors.grey
                                                    : kTextColor),
                                          ),
                                          isAfter
                                              ? SizedBox.shrink()
                                              : checked
                                                  ? Text(
                                                      "출석",
                                                      style: TextStyle(
                                                          color: kPrimaryColor),
                                                    )
                                                  : Text(
                                                      "결석",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.redAccent),
                                                    )
                                        ],
                                      )),
                                )),
                              ),
                            ));
                      });
                });
          },
        ));
  }
}
