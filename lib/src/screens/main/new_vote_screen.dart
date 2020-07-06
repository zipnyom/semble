import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/clicker_type.dart';
import 'package:schuul/src/obj/vote.dart';
import 'package:schuul/src/obj/vote_item.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/services/database.dart';
import 'package:schuul/src/widgets/condition_tile.dart';
import 'package:schuul/src/widgets/item_add_button.dart';
import 'package:schuul/src/widgets/item_input_field.dart';
import 'package:schuul/src/widgets/right_top_text_button.dart';
import 'package:schuul/src/widgets/vote_title_field.dart';
import 'package:schuul/src/widgets/widget.dart';

class NewVoteScreen extends StatefulWidget {
  const NewVoteScreen({
    Key key,
  }) : super(key: key);
  @override
  _NewVoteScreenState createState() => _NewVoteScreenState();
}

class _NewVoteScreenState extends State<NewVoteScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ClickerType selectedRadio = ClickerType.text;
  Vote _vote;

  setSelectedRadio(ClickerType val) {
    setState(() {
      selectedRadio = val;
    });
    if (val == ClickerType.text) {
      _vote.options.remove(ClickerType.date);
    } else {
      _vote.options.remove(ClickerType.text);
    }
    _vote.options.add(val);
    print("setSelectedRadio => ${_vote.options}");
  }

  @override
  void initState() {
    _vote = Vote()..options = [ClickerType.text];
    _vote.items.add(VoteItem());
    _vote.items.add(VoteItem());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void addInputItem() {
      setState(() {
        _vote.items.add(VoteItem()..controller = TextEditingController());
      });
    }

    void onSubmit() async {
      if (_formKey.currentState.validate()) {
        _vote.title = _vote.titleController.text;
        _vote.created = DateTime.now();
        List<VoteItem> choiceList = [];
        int choiceCount = 0;
        int order = 0;
        for (VoteItem item in _vote.items) {
          if (item.controller.text.isNotEmpty) {
            choiceList.add(VoteItem(
                title: item.controller.text,
                order: order,
                count: 0,
                voters: []));
            choiceCount++;
            order++;
          }
        }
        if (choiceCount < 2) {
          print("choice count less than 2");
          return;
        }
        DocumentReference ref =
            await databaseService.addItem("vote", _vote.toJson());
        for (VoteItem choice in choiceList) {
          ref.collection(db_col_choice).add(choice.toJson());
        }
        Navigator.pop(context);
      }
    }

    void onChecked(bool checked, ClickerType type) {
      if (checked) {
        _vote.options.add(type);
      } else {
        _vote.options.remove(type);
      }
      print("onChecked => ${_vote.options}");
    }

    return Scaffold(
        appBar: customAppBarLeading(context, "투표 생성", Icon(Icons.close),
            [RightTopTextButton(title: "완료", press: onSubmit)]),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      VoteTitleField(controller: _vote.titleController),
                      ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: ClickerType.text,
                            groupValue: selectedRadio,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              setSelectedRadio(val);
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
                              setSelectedRadio(val);
                            },
                          ),
                          Text("날짜"),
                        ],
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: _vote.items.length,
                          itemBuilder: (_, index) => ItemInputField(
                                controller: _vote.items[index].controller,
                              )),
                      ItemAddButton(
                        title: "항목추가",
                        press: addInputItem,
                      ),
                      Divider(),
                      ConditionTile(
                          iconData: Icons.done_all,
                          type: ClickerType.multiple,
                          initialValue:
                              _vote.options.contains(ClickerType.multiple),
                          press: onChecked),
                      ConditionTile(
                          iconData: CustomIcon.user_secret,
                          type: ClickerType.ananymous,
                          initialValue:
                              _vote.options.contains(ClickerType.ananymous),
                          press: onChecked),
                      ConditionTile(
                          iconData: Icons.playlist_add,
                          type: ClickerType.addable,
                          initialValue:
                              _vote.options.contains(ClickerType.addable),
                          press: onChecked),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ]),
            )));
  }
}
