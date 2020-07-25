import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/provider/class_provider.dart';
import 'package:schuul/src/data/provider/user_provider.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/screens/main/attend/attend_student_screen.dart';
import 'package:schuul/src/screens/main/calendar_page.dart';
import 'package:schuul/src/screens/main/notice_list.dart';
import 'package:schuul/src/screens/main/vote/vote_list_screen.dart';
import 'package:schuul/src/widgets/custom_box_shadow.dart';
import 'package:schuul/src/widgets/widget.dart';

import 'class_setting_screen.dart';

class ClassStudentScreen extends StatefulWidget {
  const ClassStudentScreen({Key key}) : super(key: key);
  @override
  _ClassStudentScreenState createState() => _ClassStudentScreenState();
}

class _ClassStudentScreenState extends State<ClassStudentScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  double topPadding;
  FirebaseUser user;
  Animation<double> _animation;
  AnimationController _controller;
  bool isDone = false;

  Future<bool> _doAttend(
      BuildContext context, ClassProvider pClass, UserProvider pUser) async {
    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true)
      ..style(message: "로딩중..");
    await pr.show();
    String uid = pUser.user.uid;
    DocumentReference doc = pClass.myClass.documentSnapshot.reference
        .collection(db_col_member)
        .document("$uid");

    doc.updateData({
      "attend": FieldValue.arrayUnion([DateTime.now()])
    });
    await pr.hide();
    return true;
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _animation.addListener(() {
      setState(() {});
    });

    topPadding = 100;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        topPadding = 225;
      });
      _controller.repeat(reverse: true);
    });
    _scrollController = ScrollController()
      ..addListener(() {
        print("offset = ${_scrollController.offset}");
        if (_scrollController.offset <= 10) {
          setState(() {
            topPadding = 225;
          });
        } else {
          setState(() {
            topPadding = 100;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController
        .dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  Widget _buildRegistered(
      BuildContext context, ClassProvider pClass, UserProvider pUser) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: isDone
              ? SizedBox.shrink()
              : Column(
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                        stream: pClass.myClass.documentSnapshot.reference
                            .collection(db_col_member)
                            .document(pUser.user.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          DateFormat dateFormat =
                              DateFormat('M월 d일 (E)', "ko_KO");
                          List<dynamic> attendList =
                              snapshot.data["attend"] ?? [];
                          List<String> dayStrList = [];

                          pClass.myClass.days.forEach((element) {
                            dayStrList.add(dateFormat.format(element));
                          });

                          String todayStr = dateFormat.format(DateTime.now());

                          //오늘이 수업 날짜가 아니라면 출석 버튼을 보여주지 않아도 됨.
                          if (dayStrList.contains(todayStr) == false) {
                            return SizedBox.shrink();
                          }

                          //오늘이 수업 날짜라면
                          List<String> attendStrList = [];
                          attendList.forEach((element) {
                            attendStrList.add(dateFormat
                                .format((element as Timestamp).toDate()));
                          });

                          //이미 출석 체크를 했다면
                          if (attendList.contains(todayStr) == true) {
                            Text("출석 체크가 완료됐습니다");
                          }

                          // 출석을 하지 않앗다면
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.priority_high,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "7월 23일의 출석 체크를 지금 할 수 있습니다.",
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Dismissible(
                                key: Key("mycard"),
                                confirmDismiss: (value) async {
                                  return _doAttend(context, pClass, pUser);
                                },
                                onDismissed: (value) {
                                  _controller.stop();
                                  setState(() {
                                    isDone = true;
                                  });
                                },
                                background: Container(),
                                child: Container(
                                  transform: Matrix4.translationValues(
                                      _animation.value * 20 - 10, 0, 0),
                                  height: 80,
                                  width: 300,
                                  decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(26))),
                                  child: Center(
                                    child: Text(
                                      "밀어서 출석체크",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                  ],
                ),
        ),
        Row(
          children: [
            buildCardButton("출결", CustomIcon.check_double, kPrimaryColor, () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AttendStudentScreen(),
              ));
            }),
            SizedBox(
              width: 20,
            ),
            buildCardButton("투표", CustomIcon.thumbs_up, Colors.blueAccent[100],
                () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VoteListScreen(),
              ));
            }),
            //mj
          ],
        ),
        Row(
          children: [
            buildCardButton(
              "일정",
              CustomIcon.calendar,
              Colors.grey[500],
              () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CalendarPage()));
              },
            ),
            SizedBox(
              width: 20,
            ),
            buildCardButton("게시판", Icons.note, Colors.blueAccent[100], () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NoticeListScreen()));
            }),
            //mj
          ],
        ),
        Row(
          children: [
            buildCardButton("설정", CustomIcon.cog, Colors.grey[500], () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ClassSettingScreen(),
              ));
            }),
            //mj
          ],
        ),
      ],
    );
  }

  Widget _buildProcessing(ClassProvider pClass, UserProvider pUser) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.check), Text("요청되었습니다. 관리자 승인 대기중입니다")],
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Colors.amberAccent[200],
                child: Text("요청 취소"),
                onPressed: () async {
                  await pClass.myClass.documentSnapshot.reference
                      .collection(db_col_request)
                      .document(pUser.user.uid)
                      .delete();
                  await pUser.userDetail.documentSnapshot.reference.updateData({
                    db_field_requestList: FieldValue.arrayRemove(
                        [pClass.myClass.documentSnapshot.documentID])
                  });
                  showSimpleDialog(context, "수업 등록", "수업등록 요청이 취소되었습니��.");
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequest(ClassProvider pClass, UserProvider pUser) {
    return Row(
      children: [
        Text(
          "[수업 소개]",
        ),
        SizedBox(
          width: 5,
        ),
        Text(pClass.myClass.description),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("수강중인 수업이 아닙니다. 등록 요청하시겠습니까?"),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: kPrimaryColor,
                child: Text("등록 요청하기"),
                onPressed: () async {
                  await pClass.myClass.documentSnapshot.reference
                      .collection(db_col_request)
                      .document(pUser.user.uid)
                      .setData({
                    "uid": pUser.user.uid,
                    "name": pUser.user.displayName,
                    "photoUrl": pUser.user.photoUrl,
                    "time": FieldValue.serverTimestamp()
                  });
                  await pUser.userDetail.documentSnapshot.reference.updateData({
                    db_field_requestList: FieldValue.arrayUnion(
                        [pClass.myClass.documentSnapshot.documentID])
                  });
                  showSimpleDialog(context, "수업 등록",
                      "수업 등록이 요청되었습니다. 관리자의 승인이 완료되면 해당 수업을 조회하실 수 있습니다.");
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer2<ClassProvider, UserProvider>(
        builder: (context, pClass, pUser, child) {
      return Stack(
        children: [
          SizedBox(
            height: 300,
            child: pClass.myClass.imageUrl == null
                ? AssetImage(defaultImagePath)
                : ExtendedImage.network(pClass.myClass.imageUrl,
                    fit: BoxFit.fill,
                    cache: true,
                    loadStateChanged: myloadStateChanged),
          ),
          AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
              padding: EdgeInsets.only(top: topPadding),
              width: double.infinity,
              height: double.infinity,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                      boxShadow: [customBoxShadowReverse],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      color: Colors.white),
                  child: ListView(
                    controller: _scrollController,
                    physics: ClampingScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              pClass.myClass.title,
                              style: kHeadingextStyle,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          pClass.myClass.creatorImageUrl == null
                              ? ExtendedImage.asset(
                                  "assets/images/login_bottom.png",
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.fill,
                                  shape: BoxShape.circle,
                                  loadStateChanged: myloadStateChanged)
                              : ExtendedImage.network(
                                  pClass.myClass.creatorImageUrl,
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.fill,
                                  cache: true,
                                  shape: BoxShape.circle,
                                  loadStateChanged: myloadStateChanged),
                          SizedBox(
                            width: 20,
                          ),
                          Text(pClass.myClass.creatorName)
                        ],
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      pClass.myClass.members.contains(pUser.user.uid)
                          ? _buildRegistered(context, pClass, pUser)
                          : pUser.userDetail.requestList.contains(
                                  pClass.myClass.documentSnapshot.documentID)
                              ? _buildProcessing(pClass, pUser)
                              : _buildRequest(pClass, pUser)
                    ],
                  ))),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [customBoxShadow]),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          )
        ],
      );
    }));
  }
}
