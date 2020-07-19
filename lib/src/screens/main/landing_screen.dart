import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:schuul/src/constants.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({
    Key key,
  }) : super(key: key);
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  myTest() async {
    Firestore.instance.runTransaction((transaction) async {
      DocumentReference metaDocument =
          Firestore.instance.collection('metadata').document('classList');
      DocumentSnapshot freshSnap = await transaction.get(metaDocument);
      var titleMap = freshSnap.data["items"];
      print(titleMap);
    });
  }

  @override
  void initState() {
    // myTest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: StreamBuilder(
          stream: Firestore.instance.collection(db_col_event).snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: 100,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 100),
                  child: SlideAnimation(
                    horizontalOffset: 300.0,
                    child: FadeInAnimation(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Container(
                        child: Card(
                          child: Text("${index}번 카드"),
                        ),
                      ),
                    )),
                  ),
                );
              },
            );
          }),
    ));
  }
}
