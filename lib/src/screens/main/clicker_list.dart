import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/action_type.dart';
import 'package:schuul/src/data/enums/clicker_type.dart';
import 'package:schuul/src/data/provider/select_provider.dart';
import 'package:schuul/src/obj/action_model.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/screens/main/clicker_detail.dart';
import 'package:schuul/src/obj/clicker.dart';
import 'package:schuul/src/screens/main/new_clicker.dart';
import 'package:schuul/src/widgets/custom_box_shadow.dart';
import 'package:schuul/src/widgets/custom_popup_menu.dart';
import 'package:schuul/src/widgets/filterchip.dart';
import 'package:schuul/src/widgets/widget.dart';

class ClickerList extends StatefulWidget {
  ClickerList({Key key}) : super(key: key);
  @override
  _ClickerListState createState() => _ClickerListState();
}

class _ClickerListState extends State<ClickerList> {
  List<Clicker> clickerList = [];

  void packSampleClickers() async {
    // List<Clicker> bufferList = List<Clicker>();

    // QuerySnapshot snapshot = await Firestore.instance
    //     .collection("clicker")
    //     .getDocuments()
    //     .catchError((e) {
    //   print(e.toString());
    // });

    // snapshot.documents.forEach((element) {
    //   bufferList.add(Clicker.fromJson(element.data));
    // });
    // print(bufferList);

    // setState(() {
    //   clickerList = bufferList;
    // });

    // for (int i = 1; i <= 20; i++) {
    //   String num = i.toString();
    //   list.add(Clicker(
    //       "투표$num", DateTime.now(), false, ["사과", "배"], [ClickerType.text]));
    // }
    // for (Clicker model in list) {
    //   print(model.toJson());
    // }

    List<Clicker> bufferList = List<Clicker>();
    Firestore.instance
        .collection("clicker")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      bufferList.clear();
      snapshot.documents.forEach((element) {
        bufferList
            .add(Clicker.fromJson(element.data)..documentSnapshot = element);
      });
      print(bufferList);
      if (this.mounted) {
        setState(() {
          clickerList = bufferList;
        });
      }
    });
  }

  @override
  void initState() {
    packSampleClickers();
    super.initState();
  }

  bulkDeletePress() {
    for (Clicker clicker in clickerList) {
      if (clicker.checked) {
        clicker.documentSnapshot.reference.delete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarLeading(context, "투표", Icon(Icons.close), [
        IconButton(
          iconSize: 20,
          icon: Icon(CustomIcon.pencil),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewClicker(),
                ));
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 15),
          child: CustomPopupMenuButton(
            list: [ActionModel(ActionType.bulkDelete, bulkDeletePress)],
          ),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // CustomChip(),
              // CategoryChips(),
              SizedBox(
                height: 10,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: clickerList.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (_, index) {
                    return CheckboxListTile(
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                clickerList[index].title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Wrap(
                                runSpacing: 10,
                                spacing: 10,
                                children: List<CustomChip>.generate(
                                    clickerList[index].options.length,
                                    (index2) => CustomChip(
                                          color: Colors.blueAccent,
                                          title: clickerList[index]
                                              .options[index2]
                                              .name,
                                        )),
                              ),
                            ],
                          ),
                        ),
                        subtitle:
                            Text(clickerList[index].created.toIso8601String()),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: clickerList[index].checked,
                        onChanged: (bool value) {
                          setState(() {
                            clickerList[index].checked = value;
                          });
                        },
                        checkColor: Colors.white,
                        secondary: IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider.value(
                                          value: Select(),
                                          child: NewClicker(
                                            clicker: clickerList[index],
                                          ),
                                        )));
                          },
                        ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class CustomChip extends StatelessWidget {
  final Color color;
  final String title;

  const CustomChip({
    Key key,
    this.color,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
        // boxShadow: [customBoxShadow]
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }
}

class CategoryChips extends StatelessWidget {
  const CategoryChips({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TitleContainer(myTitle: "분류 필터"),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Wrap(
              spacing: 5.0,
              runSpacing: 3.0,
              children: <Widget>[
                FilterChipWidget(
                  chipName: ClickerType.complete.name,
                  isSelected: false,
                ),
                FilterChipWidget(
                  chipName: ClickerType.ing.name,
                  isSelected: false,
                ),
                FilterChipWidget(
                  chipName: ClickerType.canceled.name,
                  isSelected: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TitleContainer extends StatelessWidget {
  const TitleContainer({
    Key key,
    @required this.myTitle,
  }) : super(key: key);

  final String myTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          myTitle,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
