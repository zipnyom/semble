import 'package:flutter/material.dart';
import 'package:schuul/src/data/enums/clicker_type.dart';
import 'package:schuul/src/obj/clicker.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/services/database.dart';
import 'package:schuul/src/widgets/condition_tile.dart';
import 'package:schuul/src/widgets/item_add_button.dart';
import 'package:schuul/src/widgets/item_input_field.dart';
import 'package:schuul/src/widgets/right_top_text_button.dart';
import 'package:schuul/src/widgets/widget.dart';

class NewClicker extends StatefulWidget {
  final Clicker clicker;
  const NewClicker({Key key, this.clicker}) : super(key: key);
  @override
  _NewClickerState createState() => _NewClickerState();
}

class _NewClickerState extends State<NewClicker> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> txtControllerList =
      List<TextEditingController>();
  final TextEditingController titleController = TextEditingController();
  ClickerType selectedRadio = ClickerType.text;
  bool isLoading = false;
  bool edit;
  Clicker _clicker;

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

  List<Widget> itemList; //항목 리스트

  @override
  void initState() {
    edit= widget.clicker != null;
    if (edit) {
      _clicker = widget.clicker;
      titleController.text = _clicker.title;
      itemList =
          List<ItemInputFiled>.generate(_clicker.choices.length, (index) {
        TextEditingController controller = TextEditingController();
        controller.text = _clicker.choices[index];
        txtControllerList.add(controller);
        return ItemInputFiled(controller: controller);
      });
    } else {
      _clicker = Clicker()..options = [ClickerType.text];
      txtControllerList.add(TextEditingController());
      txtControllerList.add(TextEditingController());
      itemList = [
        ItemInputFiled(controller: txtControllerList[0]),
        ItemInputFiled(controller: txtControllerList[1])
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
        itemList.add(ItemInputFiled(
          controller: controller,
        ));
      });
    }

    void onSubmit() {
      if (_formKey.currentState.validate()) {
        String title = titleController.text;
        print(title);
        print(selectedRadio);
        int choiceCount = 0;
        List<String> choiceList = [];
        for (TextEditingController tec in txtControllerList) {
          if (tec.text.isNotEmpty) {
            choiceCount++;
            print(tec.text);
            choiceList.add(tec.text);
          }
        }
        if (choiceCount < 2) {
          print("nono..");
          return;
        }

        Clicker clicker =
            Clicker(title, DateTime.now(), false, choiceList, _clicker.options);
        databaseService.addItem("clicker", clicker.toJson());
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

    return Scaffold(
        appBar: customAppBarLeading(context,
            edit ? "투표 정보" : "투표 생성", Icon(Icons.close), [
          RightTopTextButton(
              title: edit ? "수정" : "완료", press: onSubmit)
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
                              print("Radio $val");
                              setSelectedRadio(val);
                            },
                          ),
                          Text("날짜"),
                        ],
                      ),
                      Column(children: itemList),
                      ItemAddButton(
                        press: addInputItem,
                      ),
                      Divider(),
                      ConditionTile(
                          iconData: Icons.access_time,
                          type: ClickerType.limited,
                          initialValue:
                              _clicker.options.contains(ClickerType.limited),
                          press: onChecked),
                      ConditionTile(
                          iconData: Icons.done_all,
                          type: ClickerType.multiple,
                          initialValue:
                              _clicker.options.contains(ClickerType.multiple),
                          press: onChecked),
                      ConditionTile(
                          iconData: CustomIcon.user_secret,
                          type: ClickerType.ananymous,
                          initialValue:
                              _clicker.options.contains(ClickerType.ananymous),
                          press: onChecked),
                      ConditionTile(
                          iconData: Icons.playlist_add,
                          type: ClickerType.addable,
                          initialValue:
                              _clicker.options.contains(ClickerType.addable),
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
