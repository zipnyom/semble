import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/respond_type.dart';
import 'package:schuul/src/data/provider/class_option_provider.dart';
import 'package:schuul/src/obj/class.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/screens/main/class/class_introduce_screen.dart';
import 'package:schuul/src/widgets/widget.dart';

import 'class_detail_screen.dart';

class ClassSearchScreen extends StatefulWidget {
  @override
  _ClassSearchScreenState createState() => _ClassSearchScreenState();
}

class _ClassSearchScreenState extends State<ClassSearchScreen> {
  TextEditingController controller;
  List<String> matchedTitleList = [];
  List<String> titleList = [];
  Map titleMap = Map();

  packTitle() async {
    Firestore.instance
        .document("metadata/classList")
        .snapshots()
        .listen((event) {
      if (event.data.isEmpty)
        titleMap = Map();
      else {
        titleMap = event.data["items"];
        titleList = titleMap.keys.toList();
      }
    });
  }

  @override
  void initState() {
    packTitle();
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarLeading(context, "수업 검색", Icon(Icons.close), []),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        matchedTitleList = [];
                        return;
                      }
                      setState(() {
                        matchedTitleList = titleList
                            .where((element) => element.indexOf(value) != -1)
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                        icon: Icon(
                          CustomIcon.search,
                          color: kTextLightColor,
                        ),
                        hintText: "검색어 입력..",
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Consumer<ClassProvider>(
              builder: (context, pClass, child) => ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: matchedTitleList.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      onTap: () async {
                        String documentId = titleMap[matchedTitleList[index]];
                        DocumentSnapshot doc = await Firestore.instance
                            .document("class/$documentId")
                            .get();
                        MyClass item = MyClass.fromJson(doc.data);
                        item.documentSnapshot = doc;
                        pClass.myClass = item;
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ClassIntroduceScreen(),
                        ));
                      },
                      title: Text(matchedTitleList[index]),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
