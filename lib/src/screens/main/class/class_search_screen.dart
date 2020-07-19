import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/obj/class.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/widgets/widget.dart';

import 'class_detail_screen.dart';

class ClassSearchScreen extends StatefulWidget {
  @override
  _ClassSearchScreenState createState() => _ClassSearchScreenState();
}

class _ClassSearchScreenState extends State<ClassSearchScreen> {
  String searchText = "";
  TextEditingController controller;
  @override
  void initState() {
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
                      setState(() {
                        searchText = value;
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
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection(db_col_class)
                    .where(
                      "title",
                      isLessThanOrEqualTo: searchText,
                    )
                    .limit(10)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (_, index) {
                        MyClass item = MyClass.fromJson(
                            snapshot.data.documents[index].data);
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
                                    builder: (context) => ClassDetailScreen(),
                                  ));
                                },
                                child: Container(
                                    child: Card(
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 20),
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
                                              loadStateChanged:
                                                  myloadStateChanged),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
          ],
        ),
      ),
    );
  }
}
