import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/vote_type.dart';
import 'package:schuul/src/data/enums/respond_type.dart';
import 'package:schuul/src/obj/vote.dart';
import 'package:schuul/src/obj/vote_item.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/services/database.dart';
import 'package:schuul/src/widgets/condition_tile.dart';
import 'package:schuul/src/widgets/item_add_button.dart';
import 'package:schuul/src/widgets/item_input_date.dart';
import 'package:schuul/src/widgets/item_input_text.dart';
import 'package:schuul/src/widgets/right_top_text_button.dart';
import 'package:schuul/src/widgets/title_text_field.dart';
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
  VoteType selectedRadio = VoteType.text;
  Vote _vote;

  setSelectedRadio(VoteType val) {
    setState(() {
      selectedRadio = val;
    });
    // if (val == VoteType.text) {
    //   _vote.options.remove(VoteType.date);
    // } else {
    //   _vote.options.remove(VoteType.text);
    // }
    // _vote.options.add(val);
    print("setSelectedRadio => ${_vote.options}");
  }

  @override
  void initState() {
    _vote = Vote()..options = [];
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
        RespondType res =
            await customShowDialog(context, "바로 실행", "클리커를 바로 실행하시겠습니까?");
        if (res == RespondType.yes) _vote.status = VoteType.running;

        _vote.title = _vote.titleController.text.trim();
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
            await databaseService.addItem(db_col_vote, _vote.toJson());
        for (VoteItem choice in choiceList) {
          ref.collection(db_col_items).add(choice.toJson());
        }
        Navigator.pop(context);
      }
    }

    void onChecked(bool checked, VoteType type) {
      if (checked) {
        _vote.options.add(type);
      } else {
        _vote.options.remove(type);
      }
      print("onChecked => ${_vote.options}");
    }

    void onExit(BuildContext context) async {
      RespondType res =
          await customShowDialog(context, "닫기", "저장히지 않고 나가시겠습니까?");
      if (res == RespondType.yes) Navigator.of(context).pop();
    }

    return Scaffold(
        appBar: customAppBarLeadingWithDialog(
            context,
            "새로운 투표",
            Icon(Icons.close),
            onExit,
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
                      TitleTextField(
                          validateMessage: "투표 제목을 입력해주세요.",
                          hintText: "투표 제목",
                          controller: _vote.titleController),
                      ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: VoteType.text,
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
                            value: VoteType.date,
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
                          itemBuilder: (_, index) =>
                              selectedRadio == VoteType.text
                                  ? ItemInputText(
                                      controller: _vote.items[index].controller,
                                    )
                                  : ItemInputDate(
                                      controller: _vote.items[index].controller,
                                    )),
                      ItemAddButton(
                        title: "항목추가",
                        press: addInputItem,
                      ),
                      Divider(),
                      ConditionTile(
                          iconData: Icons.done_all,
                          type: VoteType.multiple,
                          initialValue:
                              _vote.options.contains(VoteType.multiple),
                          press: onChecked),
                      ConditionTile(
                          iconData: CustomIcon.user_secret,
                          type: VoteType.ananymous,
                          initialValue:
                              _vote.options.contains(VoteType.ananymous),
                          press: onChecked),
                      ConditionTile(
                          iconData: Icons.playlist_add,
                          type: VoteType.addable,
                          initialValue:
                              _vote.options.contains(VoteType.addable),
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
