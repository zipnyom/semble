import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/vote_type.dart';
import 'package:schuul/src/obj/vote.dart';
import 'package:schuul/src/screens/main/vote/detail_voters_screen.dart';

class ItemResultField extends StatefulWidget {
  const ItemResultField({
    Key key,
    @required this.order,
    this.vote,
  }) : super(key: key);

  final Vote vote;
  final int order;
  @override
  _ItemResultFieldState createState() => _ItemResultFieldState();
}

class _ItemResultFieldState extends State<ItemResultField> {
  TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<QuerySnapshot>(builder: (context, pSnapshot, child) {
      int totalCount = 0;
      pSnapshot.documents.forEach((element) {
        totalCount += element["count"];
      });
      var doc = pSnapshot.documents.elementAt(widget.order);
      controller.text = doc["title"];
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Material(
          child: InkWell(
            onTap: () {
              if (widget.vote.options.contains(VoteType.ananymous)) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("익명 투표는 투표자 목록을 확인할 수 없습니다"),
                  duration: Duration(milliseconds: 500),
                ));
                return;
              }
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailVoterScreen(
                  doc: doc,
                ),
              ));
            },
            child: Container(
              width: size.width * .9,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: kTextLightColor,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: totalCount == 0
                          ? 0
                          : size.width * .9 * (doc["count"] / totalCount),
                      height: double.infinity,
                      color: kPrimaryColor.withOpacity(.5),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            enabled: false,
                            controller: controller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Text("${doc["count"]}표"),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
