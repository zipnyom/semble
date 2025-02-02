import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/provider/class_provider.dart';
import 'package:schuul/src/data/provider/user_provider.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/screens/main/attend/attend_teacher_screen.dart';
import 'package:schuul/src/screens/main/class/class_setting_screen.dart';
import 'package:schuul/src/screens/main/member/member_screen.dart';
import 'package:schuul/src/widgets/custom_box_shadow.dart';
import 'package:schuul/src/widgets/widget.dart';

class ClassTeacherScreen extends StatefulWidget {
  const ClassTeacherScreen({Key key}) : super(key: key);
  @override
  _ClassTeacherScreenState createState() => _ClassTeacherScreenState();
}

class _ClassTeacherScreenState extends State<ClassTeacherScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassProvider>(
      builder: (context, pClass, child) {
        return Scaffold(
          body: Stack(
            children: [
              SizedBox(
                height: 300,
                child: pClass.myClass.imageUrl == null
                    ? ExtendedImage.asset(defaultImagePath)
                    : ExtendedImage.network(pClass.myClass.imageUrl,
                        fit: BoxFit.fill,
                        cache: true,
                        loadStateChanged: myloadStateChanged),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
                right: 20,
                top: topPadding - 50,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [customBoxShadow, customBoxShadowReverse]),
                  child: SizedBox(
                    height: 35,
                    width: 35,
                    child: IconButton(
                        padding: EdgeInsets.all(0),
                        iconSize: 20,
                        icon: Icon(Icons.edit),
                        onPressed: () {}),
                  ),
                ),
              ),
              AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                  padding: EdgeInsets.only(top: topPadding),
                  width: double.infinity,
                  height: double.infinity,
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                              Consumer<UserProvider>(
                                  builder: (context, pUser, child) {
                                return Text(pUser.user.displayName);
                              })
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    buildCardButton(
                                        "출결",
                                        CustomIcon.check_double,
                                        kPrimaryColor, () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            AttendTeacherScreen(),
                                      ));
                                    }),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    buildCardButton("투표", CustomIcon.thumbs_up,
                                        Colors.blueAccent[100], () {}),
                                    //mj
                                  ],
                                ),
                                Row(
                                  children: [
                                    buildCardButton(
                                      "학생",
                                      Icons.people,
                                      kPrimaryColor,
                                      () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => MemberScreen(),
                                        ));
                                      },
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    buildCardButton("게시판", Icons.note,
                                        Colors.blueAccent[100], () {}),
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
                                    buildCardButton(
                                        "설정", CustomIcon.cog, Colors.grey[500],
                                        () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            ClassSettingScreen(),
                                      ));
                                    }),
                                    //mj
                                  ],
                                ),
                              ],
                            ),
                          ),
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
          ),
        );
      },
    );
  }
}
