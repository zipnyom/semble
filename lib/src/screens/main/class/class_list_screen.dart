import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/respond_type.dart';
import 'package:schuul/src/data/provider/class_provider.dart';
import 'package:schuul/src/data/provider/mode_provider.dart';
import 'package:schuul/src/data/provider/user_provider.dart';
import 'package:schuul/src/obj/class.dart';
import 'package:schuul/src/screens/main/class/class_detail_screen.dart';
import 'package:schuul/src/screens/main/class/class_student_screen.dart';
import 'package:schuul/src/screens/main/class/class_search_screen.dart';
import 'package:schuul/src/screens/main/class/new_class_first.dart';
import 'package:schuul/src/widgets/custom_box_shadow.dart';
import 'package:schuul/src/widgets/widget.dart';

class ClassListScreen extends StatefulWidget {
  @override
  _ClassListScreenState createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  List<MyClass> classList = [];
  TextEditingController classCodeTextEditingController =
      TextEditingController();

  Widget _radiusButton(BuildContext context, bool isNameSearch) {
    return Expanded(
      child: Material(
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop(isNameSearch ? true : false);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), border: Border.all()),
            child: Center(child: Text(isNameSearch ? "이름으로 검색" : "수업코드 입력")),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Mode>(builder: (context, pMode, child) {
      return Scaffold(
          appBar: AppBar(
              title: Row(
                children: [
                  Text(
                    "수업 목록",
                    style: TextStyle(color: kTextColor),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Material(
                    child: InkWell(
                      onTap: () {
                        pMode.toggle();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                        decoration: BoxDecoration(
                            color: pMode.mode == Modes.teacher
                                ? Colors.amber
                                : Colors.blue,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: [customBoxShadowThin]),
                        child: Text(
                          pMode.mode == Modes.teacher ? "선생님 모드" : "학생 모드",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              iconTheme: IconThemeData(
                color: kTextColor, //change your color here
              ),
              centerTitle: false,
              brightness: Brightness.light,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: [
                pMode.mode == Modes.teacher
                    ? IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          ClassProvider pClass = Provider.of<ClassProvider>(
                            context,
                          );
                          pClass.myClass = MyClass();
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NewClassScreen1(),
                          ));
                          // packClassList();
                        })
                    : IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          bool isNameSearch = await showDialog(
                              context: context,
                              // barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(32.0))),
                                  content: Container(
                                    height: 150,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _radiusButton(context, true),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        _radiusButton(context, false)
                                      ],
                                    ),
                                  ),
                                );
                              });

                          // barrierDismissible를 false로 줄 때에는 항상 null 을 조심
                          if (isNameSearch == null) return;
                          if (isNameSearch) {
                            // 이름으로 검색
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ClassSearchScreen(),
                            ));
                          } else {
                            await showDialog(
                                context: context,
                                // barrierDismissible: fㅌalse,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("수업코드 입력"),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0))),
                                    content: Container(
                                      height: 100,
                                      child: Column(
                                        children: [
                                          Text("강사/조교님께 전달받은 코드를 입력하세요"),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  controller:
                                                      classCodeTextEditingController,
                                                  decoration: InputDecoration(
                                                    hintText: "코드 입력..",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(RespondType.ok);
                                        },
                                        child: Text(RespondType.ok.name),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(RespondType.cancel);
                                        },
                                        child: Text(RespondType.cancel.name),
                                      ),
                                    ],
                                  );
                                });
                          }
                          // packClassList();
                        })
              ]),
          body: Consumer2<UserProvider, Mode>(
            builder: (context, pUser, pMode, child) {
              print("pUser.userDetail");
              print(pUser.userDetail.toJson());
              return Container(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: pMode.mode == Modes.teacher
                              ? Firestore.instance
                                  .collection(db_col_class)
                                  .where("creatorUid",
                                      isEqualTo: pUser.user.uid)
                                  .snapshots()
                              : Firestore.instance
                                  .collection(db_col_class)
                                  .where("members",
                                      arrayContains: pUser.user.uid)
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.data.documents.length == 0) {
                              return Center(
                                child: Text("등록된 수업이 없습니다"),
                              );
                            }
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (_, index) {
                                  MyClass item = MyClass.fromJson(
                                      snapshot.data.documents[index].data);
                                  item.documentSnapshot =
                                      snapshot.data.documents[index];
                                  String dateString = DateFormat("yy.MM.dd")
                                          .format(item.startDate) +
                                      " ~ " +
                                      DateFormat("yy.MM.dd")
                                          .format(item.endDate);
                                  return Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Material(
                                        child: InkWell(
                                          onTap: () {
                                            ClassProvider pClass =
                                                Provider.of<ClassProvider>(
                                                    context,
                                                    listen: false);
                                            pClass.myClass = item;
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  pMode.mode == Modes.teacher
                                                      ? ClassDetailScreen()
                                                      : ClassStudentScreen(),
                                            ));
                                          },
                                          child: Container(
                                              child: Card(
                                            child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 20),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    item.imageUrl == null
                                                        ? ExtendedImage.asset(
                                                            "assets/images/login_bottom.png",
                                                            width: 70,
                                                            height: 70,
                                                            fit: BoxFit.fill,
                                                            shape:
                                                                BoxShape.circle,
                                                            loadStateChanged:
                                                                myloadStateChanged)
                                                        : ExtendedImage.network(
                                                            item.imageUrl,
                                                            width: 70,
                                                            height: 70,
                                                            fit: BoxFit.fill,
                                                            cache: true,
                                                            shape:
                                                                BoxShape.circle,
                                                            loadStateChanged:
                                                                myloadStateChanged),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item.title,
                                                            style:
                                                                kListTitleStyle,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            item.description,
                                                            style:
                                                                kListSubTitleStyle,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "${item.studentCount}명의 학생",
                                                            style:
                                                                kListSubTitleStyle,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            dateString,
                                                            style:
                                                                kListSubTitleStyle,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          )),
                                        ),
                                      ));
                                });
                          }),
                    ),
                  ],
                ),
              ));
            },
          ));
    });
  }
}
