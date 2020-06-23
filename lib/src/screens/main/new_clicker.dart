import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/clicker_type.dart';
import 'package:schuul/src/obj/clicker.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/widgets/right_top_text_button.dart';
import 'package:schuul/src/widgets/sub_title.dart';
import 'package:schuul/src/widgets/widget.dart';
import 'package:numberpicker/numberpicker.dart';

class NewClicker extends StatefulWidget {
  const NewClicker({Key key}) : super(key: key);
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

  List<ClickerType> clickerTypeList = [ClickerType.text];

  setSelectedRadio(ClickerType val) {
    setState(() {
      selectedRadio = val;
    });
    if (val == ClickerType.text) {
      clickerTypeList.remove(ClickerType.date);
    } else {
      clickerTypeList.remove(ClickerType.text);
    }
    clickerTypeList.add(val);
    print(clickerTypeList);
  }

  List<Widget> itemList; //항목 리스트

  @override
  void initState() {
    TextEditingController first = TextEditingController();
    TextEditingController second = TextEditingController();
    txtControllerList.add(first);
    txtControllerList.add(second);
    itemList = [
      ItemInputFiled(controller: first),
      ItemInputFiled(controller: second)
    ];
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
        for (TextEditingController tec in txtControllerList) {
          if (tec.text.isNotEmpty) {
            choiceCount++;
            print(tec.text);
          }
        }
        if (choiceCount < 2) {
          print("nono..");
        }
        // Navigator.pop(context);
      }
    }

    void onChecked(bool checked, ClickerType type) {
      if (checked) {
        clickerTypeList.add(type);
      } else {
        clickerTypeList.remove(type);
      }
      print(clickerTypeList);
    }

    return Scaffold(
        appBar: customAppBarLeading(context, "클리커 생성", Icon(Icons.close),
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
                      Column(
                        children: itemList,
                      ),
                      ItemAddButton(
                        press: addInputItem,
                      ),
                      Divider(),
                      ConditionTile(
                          iconData: Icons.access_time,
                          type: ClickerType.limited,
                          press: onChecked),
                      ConditionTile(
                          iconData: Icons.done_all,
                          type: ClickerType.multiple,
                          press: onChecked),
                      ConditionTile(
                          iconData: CustomIcon.user_secret,
                          type: ClickerType.ananymous,
                          press: onChecked),
                      ConditionTile(
                          iconData: Icons.playlist_add,
                          type: ClickerType.addable,
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

class ConditionTile extends StatefulWidget {
  final IconData iconData;
  final ClickerType type;
  final Function(bool, ClickerType) press;
  const ConditionTile({
    Key key,
    this.iconData,
    this.press,
    this.type,
  }) : super(key: key);

  @override
  _ConditionTileState createState() => _ConditionTileState();
}

class _ConditionTileState extends State<ConditionTile> {
  bool checked = false;

  void pressed() {
    setState(() {
      checked = !checked;
    });
    widget.press(checked, widget.type);
  }

  Future<void> _showBottomSheet() async {
    showModalBottomSheet(
        context: context, builder: (context) => TimerBottonSheet());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          if (widget.type == ClickerType.limited) {
            _showBottomSheet();
          } else {
            pressed();
          }
        },
        child: ListTile(
          leading: Icon(widget.iconData),
          title: Text(widget.type.name),
          trailing: IconButton(
            icon: checked
                ? Icon(
                    Icons.check_circle,
                    color: kPrimaryColor,
                  )
                : Icon(Icons.check_circle_outline),
            onPressed: pressed,
          ),
        ),
      ),
    );
  }
}

class TimerBottonSheet extends StatefulWidget {
  const TimerBottonSheet({
    Key key,
  }) : super(key: key);

  @override
  _TimerBottonSheetState createState() => _TimerBottonSheetState();
}

class _TimerBottonSheetState extends State<TimerBottonSheet> {
  int _currentValue = 0;
  int _currentValue2 = 0;
  int _currentValue3 = 0;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: modalMaxWidth,

            // If we're showing the wide layout, make sure this modal
            // isn't too tall by using a factor of the same width
            // constraint as a constraint for the height.
            maxHeight: modalMaxWidth * 1.1),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: Container(
                padding: EdgeInsets.all(20),
                color: modalBackgroundColor,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SubTitle(
                        icon: Icons.timer, title: "시간을 선택하세요", actions: []),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("시"),
                                NumberPicker.integer(
                                    initialValue: _currentValue,
                                    minValue: 0,
                                    maxValue: 23,
                                    onChanged: (newValue) => setState(
                                        () => _currentValue = newValue)),
                              ]),
                          Column(
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("분"),
                                NumberPicker.integer(
                                    initialValue: _currentValue2,
                                    minValue: 0,
                                    maxValue: 59,
                                    onChanged: (newValue) => setState(
                                        () => _currentValue2 = newValue)),
                              ]),
                          Column(
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("초"),
                                NumberPicker.integer(
                                    initialValue: _currentValue3,
                                    minValue: 0,
                                    maxValue: 59,
                                    onChanged: (newValue) => setState(
                                        () => _currentValue3 = newValue)),
                              ])
                        ],
                      ),
                    ),
                    Material(
                      child: InkWell(
                        onTap: () => Navigator.pop(context,
                            [_currentValue, _currentValue2, _currentValue3]),
                        child: Container(
                          color: kPrimaryColor,
                          height: 50,
                          child: Center(
                              child: Text(
                            "선택",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    )
                  ],
                ))));
  }
}

class ItemAddButton extends StatelessWidget {
  final VoidCallback press;

  const ItemAddButton({Key key, this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: press,
        child: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: kTextLightColor,
              ),
            ),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "항목추가",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class ItemInputFiled extends StatefulWidget {
  const ItemInputFiled({
    Key key,
    @required TextEditingController controller,
  })  : controller = controller,
        super(key: key);

  final TextEditingController controller;

  @override
  _ItemInputFiledState createState() => _ItemInputFiledState();
}

class _ItemInputFiledState extends State<ItemInputFiled> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: kTextLightColor,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "항목 입력",
                    // border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Material(
              child: InkWell(
                onTap: () {
                  setState(() {
                    widget.controller.clear();
                  });
                },
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      CustomIcon.cancel_circle,
                      color: kTextLightColor,
                    )),
              ),
            )
          ],
        ),
      ),
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
          return "클리커 제목을 입력해주세요.";
        }
        return null;
      },
      decoration: InputDecoration(
        // icon: Icon(
        //   Icons.title,
        //   color: kPrimaryColor,
        // ),
        hintText: "클리커 제목",
        // border: InputBorder.none,
      ),
    );
  }
}
