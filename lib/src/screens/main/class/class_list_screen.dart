import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/provider/class_option_provider.dart';
import 'package:schuul/src/data/provider/events_provider.dart';
import 'package:schuul/src/obj/class.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/screens/main/class/new_class_first.dart';
import 'package:schuul/src/widgets/sub_title.dart';
import 'package:schuul/src/widgets/widget.dart';

class ClassListScreen extends StatefulWidget {
  @override
  _ClassListScreenState createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  List<Class> classList = [];

  packClassList() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    List<Class> bufferList = List<Class>();
    QuerySnapshot snapshot = await Firestore.instance
        .collection(db_col_class)
        .where("creator", isEqualTo: user.uid)
        .getDocuments();
    snapshot.documents.forEach((element) {
      bufferList.add(Class.fromJson(element.data)..documentSnapshot = element);
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
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: ClassDateInfo()),
                  ],
                  child: NewClassScreen1(),
                ),
              ));
            },
          )
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
                    Class item = classList[index];
                    return Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          child: Card(
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(item.title))),
                        ));
                  })
            ],
          ),
        )));
  }
}
