import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/provider/class_option_provider.dart';
import 'package:schuul/src/data/provider/user_provider.dart';
import 'package:schuul/src/obj/class.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/screens/main/attend/attend_screen.dart';
import 'package:schuul/src/screens/main/class/class_setting_screen.dart';
import 'package:schuul/src/widgets/custom_box_shadow.dart';
import 'package:schuul/src/widgets/widget.dart';

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

  @override
  Widget build(BuildContext context) {
    Widget _buildCardButton(
        String title, IconData iconData, Color color, Function press,
        {double width}) {
      return Expanded(
        child: Material(
          child: InkWell(
            onTap: press,
            child: Card(
              child: Center(
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          iconData,
                          color: color,
                        ),
                        SizedBox(
                          width: width ?? 30,
                        ),
                        Text(title)
                      ],
                    )),
              ),
            ),
          ),
        ),
      );
    }

    return Consumer2<ClassProvider, UserProvider>(
      builder: (context, pClass, pUser, child) {
        print("pClass.myClass");
        print(pClass.myClass);

        return Scaffold(
          body: Stack(
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                          boxShadow: [customBoxShadowReverse],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)),
                          color: Colors.white),
                      child: Column(
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
                              Text(pClass.myClass.title)
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "[수업 소개]",
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(pClass.myClass.description),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("해당 수업의 학생이 아닙니다. 등록 요청하시겠습니까?"),
                                RaisedButton(
                                  onPressed: () {
                                    pClass.myClass.documentSnapshot.reference
                                        .collection("request")
                                        .add({
                                      "uid": pUser.user.uid,
                                      "time": FieldValue.serverTimestamp()
                                    });
                                  },
                                )
                              ],
                            ),
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
          ),
        );
      },
    );
  }
}
