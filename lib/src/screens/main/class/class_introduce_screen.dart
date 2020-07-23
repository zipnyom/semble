import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/provider/class_option_provider.dart';
import 'package:schuul/src/data/provider/user_provider.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/screens/main/attend/attend_screen.dart';
import 'package:schuul/src/widgets/custom_box_shadow.dart';
import 'package:schuul/src/widgets/widget.dart';

import 'class_setting_screen.dart';

class ClassIntroduceScreen extends StatefulWidget {
  const ClassIntroduceScreen({Key key}) : super(key: key);
  @override
  _ClassIntroduceScreenState createState() => _ClassIntroduceScreenState();
}

class _ClassIntroduceScreenState extends State<ClassIntroduceScreen> {
  ScrollController _scrollController;
  double topPadding;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();

    topPadding = 100;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        topPadding = 225;
      });
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
    _scrollController
        .dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  Widget _buildRegistered(ClassProvider pClass, UserProvider pUser) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            children: [
              buildCardButton("출결", CustomIcon.check_double, kPrimaryColor, () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AttendScreen(),
                ));
              }),
              SizedBox(
                width: 20,
              ),
              buildCardButton(
                  "투표", CustomIcon.thumbs_up, Colors.blueAccent[100], () {}),
              //mj
            ],
          ),
          Row(
            children: [
              buildCardButton(
                "일정",
                CustomIcon.calendar,
                Colors.grey[500],
                () {},
              ),
              SizedBox(
                width: 20,
              ),
              buildCardButton("게시판", Icons.note, Colors.blueAccent[100], () {}),
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
      ),
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
                  showSimpleDialog(context, "수업 등록", "수업등록 요청이 취소되었습니다.");
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          // SizedBox(
                          //   width: 10,
                          // ),
                          // IconButton(
                          //   icon: Icon(CustomIcon.cog),
                          //   onPressed: () {},
                          // )
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
                          Text(pClass.myClass.title)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: pClass.myClass.members.contains(pUser.user.uid)
                            ? _buildRegistered(pClass, pUser)
                            : pUser.userDetail.requestList.contains(
                                    pClass.myClass.documentSnapshot.documentID)
                                ? _buildProcessing(pClass, pUser)
                                : _buildRequest(pClass, pUser),
                      )
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
