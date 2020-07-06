import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';

class ItemResultField extends StatefulWidget {
  const ItemResultField({
    Key key,
    @required this.order,
  }) : super(key: key);

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
                  width: totalCount == 0 ? size.width * .9 * (doc["count"] / totalCount),
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
                  // Material(
                  //   child: InkWell(
                  //     onTap: () {},
                  //     child: Padding(
                  //         padding: EdgeInsets.all(10),
                  //         child: Icon(
                  //           Icons.arrow_forward_ios,
                  //           color: kTextLightColor,
                  //         )),
                  //   ),
                  // )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
