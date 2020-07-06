import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/clicker_type.dart';
import 'package:schuul/src/data/provider/mode_provider.dart';
import 'package:schuul/src/obj/vote.dart';
import 'package:schuul/src/obj/vote_item.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/services/database.dart';
import 'package:schuul/src/widgets/condition_tile.dart';
import 'package:schuul/src/widgets/item_add_button.dart';
import 'package:schuul/src/widgets/item_input_field.dart';
import 'package:schuul/src/widgets/item_select_field.dart';
import 'package:schuul/src/widgets/right_top_text_button.dart';
import 'package:schuul/src/widgets/widget.dart';

class EditVoteScreen extends StatefulWidget {
  final Vote clicker;
  final bool respond;
  const EditVoteScreen({Key key, this.clicker, this.respond}) : super(key: key);
  @override
  _EditVoteScreenState createState() => _EditVoteScreenState();
}

class _EditVoteScreenState extends State<EditVoteScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> txtControllerList =
      List<TextEditingController>();
  final TextEditingController titleController = TextEditingController();
  ClickerType selectedRadio = ClickerType.text;
  bool _edit;
  bool _respond;
  Vote _clicker;

  setSelectedRadio(ClickerType val) {
    setState(() {
      selectedRadio = val;
    });
    if (val == ClickerType.text) {
      _clicker.options.remove(ClickerType.date);
    } else {
      _clicker.options.remove(ClickerType.text);
    }
    _clicker.options.add(val);
    print(_clicker.options);
  }

  List<Widget> itemList = []; //항목 리스트

  @override
  void initState() {
    _edit = widget.clicker != null;
    print("respond : ${widget.respond}");
    if (_edit) {
      _clicker = widget.clicker;
      titleController.text = _clicker.title;
      //sub collection 도입
      _clicker.documentSnapshot.reference
          .collection(db_col_choice)
          .orderBy("order")
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        itemList.clear();
        snapshot.documents.forEach((element) {
          TextEditingController controller = TextEditingController();
          VoteItem item = VoteItem.fromJson(element.data);
          controller.text = item.title;
          txtControllerList.add(controller);
          if (this.mounted) {
            setState(() {
              // itemList.add(ItemInputFiled(controller: controller));
              // itemList.add(ItemResultField(
              //   order: item.order,
              // ));
              itemList.add(ItemSelectField(
                controller: controller,
                // order: item.order,
              ));
            });
          }
        });

        // itemList =
        //     List<ItemInputFiled>.generate(_clicker.choices.length, (index) {
        //   TextEditingController controller = TextEditingController();
        //   controller.text = _clicker.choices[index].title;
        //   txtControllerList.add(controller);
        //   return ItemInputFiled(controller: controller);
      });
    } else {
      _clicker = Vote()..options = [ClickerType.text];
      txtControllerList.add(TextEditingController());
      txtControllerList.add(TextEditingController());
      itemList = [
        ItemInputField(controller: txtControllerList[0]),
        ItemInputField(controller: txtControllerList[1])
      ];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void addInputItem() {
      setState(() {
        TextEditingController controller = TextEditingController();
        txtControllerList.add(controller);
        itemList.add(ItemInputField(
          controller: controller,
        ));
      });
    }

    void pick() {
      print("pick me pick me !!!");
    }

    void onSubmit() async {
      if (_formKey.currentState.validate()) {
        String title = titleController.text;
        int choiceCount = 0;
        List<VoteItem> choiceList = [];
        int order = 0;
        for (TextEditingController tec in txtControllerList) {
          if (tec.text.isNotEmpty) {
            choiceList.add(
                VoteItem(title: tec.text, order: order, count: 0, voters: []));
            choiceCount++;
            order++;
          }
        }
        if (choiceCount < 2) {
          print("nono..");
          return;
        }
        Vote clicker = Vote(title, DateTime.now(), _clicker.options);
        DocumentReference ref;
        if (_edit) {
          ref = _clicker.documentSnapshot.reference;
          ref.updateData(clicker.toJson());
          QuerySnapshot snapshot =
              await ref.collection(db_col_choice).getDocuments();
          snapshot.documents.forEach((f) async {
            await f.reference.delete();
          });
        } else {
          ref = await databaseService.addItem("clicker", clicker.toJson());
        }
        for (VoteItem choice in choiceList) {
          ref.collection(db_col_choice).add(choice.toJson());
        }
        Navigator.pop(context);
      }
    }

    void onChecked(bool checked, ClickerType type) {
      if (checked) {
        _clicker.options.add(type);
      } else {
        _clicker.options.remove(type);
      }
      print(_clicker.options);
    }

    return Consumer<Mode>(builder: (context, pMode, child) {
      bool isTeacher = pMode.mode == Modes.teacher;
      return MultiProvider(
        providers: [
          StreamProvider<QuerySnapshot>.value(
              value: _clicker.documentSnapshot.reference
                  .collection(db_col_choice)
                  .snapshots()),
        ],
        child: Scaffold(
            appBar: customAppBarLeading(
                context, _edit ? "투표 정보" : "투표 생성", Icon(Icons.close), [
              RightTopTextButton(title: _edit ? "수정" : "완료", press: onSubmit)
            ]),
            body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          isTeacher ? ClickerControl() : SizedBox.shrink(),
                          TitleFiled(controller: titleController),
                          ButtonBar(
                            alignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Radio(
                                value: ClickerType.text,
                                groupValue: selectedRadio,
                                activeColor: Colors.green,
                                onChanged: (val) {
                                  print("Radio $val");
                                  if (isTeacher) setSelectedRadio(val);
                                },
                              ),
                              Text("텍스트"),
                              SizedBox(
                                width: 10,
                              ),
                              Radio(
                                value: ClickerType.date,
                                groupValue: selectedRadio,
                                activeColor: Colors.blue,
                                onChanged: (val) {
                                  print("Radio $val");
                                  if (isTeacher) setSelectedRadio(val);
                                },
                              ),
                              Text("날짜"),
                            ],
                          ),
                          Column(children: itemList),
                          if (isTeacher)
                            ItemAddButton(
                              title: "항목추가",
                              press: addInputItem,
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                    child: RaisedButton(
                                        onPressed: pick, child: Text("결정"))),
                              ],
                            ),
                          Divider(),
                          // ConditionTile(
                          //     iconData: Icons.access_time,
                          //     type: ClickerType.limited,
                          //     initialValue:
                          //         _clicker.options.contains(ClickerType.limited),
                          //     press: onChecked),
                          ConditionTile(
                              iconData: Icons.done_all,
                              type: ClickerType.multiple,
                              initialValue: _clicker.options
                                  .contains(ClickerType.multiple),
                              press: onChecked),
                          ConditionTile(
                              iconData: CustomIcon.user_secret,
                              type: ClickerType.ananymous,
                              initialValue: _clicker.options
                                  .contains(ClickerType.ananymous),
                              press: onChecked),
                          ConditionTile(
                              iconData: Icons.playlist_add,
                              type: ClickerType.addable,
                              initialValue: _clicker.options
                                  .contains(ClickerType.addable),
                              press: onChecked),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ]),
                ))),
      );
    });
  }
}

class ClickerControl extends StatefulWidget {
  const ClickerControl({
    Key key,
  }) : super(key: key);

  @override
  _ClickerControlState createState() => _ClickerControlState();
}

class _ClickerControlState extends State<ClickerControl> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    isActive = !isActive;
                  });
                },
                child: Text("시작"),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: RaisedButton(
                onPressed: () {},
                child: Text("마감"),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: isActive
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                )
              : SizedBox.shrink(),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class TitleFiled extends StatelessWidget {
  const TitleFiled({
    Key key,
    @required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      validator: (String value) {
        if (value.isEmpty) {
          return "투표 제목을 입력해주세요.";
        }
        return null;
      },
      decoration: InputDecoration(
        // icon: Icon(
        //   Icons.title,
        //   color: kPrimaryColor,
        // ),
        hintText: "투표 제목",
        // border: InputBorder.none,
      ),
    );
  }
}
