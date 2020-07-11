import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/provider/class_option_provider.dart';
import 'package:schuul/src/obj/class.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/screens/main/class/class_detail_screen.dart';
import 'package:schuul/src/screens/main/class/new_class_first.dart';
import 'package:schuul/src/widgets/sub_title.dart';
import 'package:schuul/src/widgets/widget.dart';

class ClassListScreen extends StatefulWidget {
  @override
  _ClassListScreenState createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  List<MyClass> classList = [];

  packClassList() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    List<MyClass> bufferList = List<MyClass>();
    QuerySnapshot snapshot = await Firestore.instance
        .collection(db_col_class)
        .where("creator", isEqualTo: user.uid)
        .getDocuments();
    snapshot.documents.forEach((element) {
      bufferList
          .add(MyClass.fromJson(element.data)..documentSnapshot = element);
    });
    if (this.mounted) {
      setState(() {
        classList = bufferList;
      });
    }
  }

  @override
  void initState() {
    packClassList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar("나의 수업", false, [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                ClassProvider classProvider =
                    Provider.of<ClassProvider>(context, listen: false);
                classProvider.myClass = MyClass();
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NewClassScreen1(),
                ));
                packClassList();
              })
        ]),
        body: Container(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SubTitle(
                title: "수업 리스트",
                icon: CustomIcon.graduation_cap,
                actions: [],
              ),
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: classList.length,
                  itemBuilder: (_, index) {
                    MyClass item = classList[index];
                    String dateString =
                        DateFormat("yy.MM.dd").format(item.startDate) +
                            " ~ " +
                            DateFormat("yy.MM.dd").format(item.endDate);
                    return Padding(
                        padding: EdgeInsets.all(10),
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              double height =
                                  MediaQuery.of(context).size.height;
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ClassDetailScreen(
                                  myClass: item,
                                  height: height,
                                ),
                              ));
                            },
                            child: Container(
                                child: Card(
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ExtendedImage.network(item.imageUrl,
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.fill,
                                          cache: true,
                                          shape: BoxShape.circle,
                                          loadStateChanged: myloadStateChanged),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title,
                                              style: kListTitleStyle,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              item.description,
                                              style: kListSubTitleStyle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${item.studentCount}명의 학생",
                                              style: kListSubTitleStyle,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              dateString,
                                              style: kListSubTitleStyle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                            )),
                          ),
                        ));
                  })
            ],
          ),
        )));
  }
}
