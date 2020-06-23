import 'package:flutter/material.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/clicker_type.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/widgets/right_top_text_button.dart';
import 'package:schuul/src/widgets/widget.dart';


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

  setSelectedRadio(ClickerType val) {
    setState(() {
      selectedRadio = val;
    });
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

    return Scaffold(
        appBar: customAppBarLeading(context, "클리커 생성", Icon(Icons.close), [
          RightTopTextButton(
            title: "완료",
            press: () {
              if (_formKey.currentState.validate()) {
                Navigator.pop(context);
              }
            },
          )
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
                      Column(
                        children: itemList,
                      ),
                      ItemAddButton(
                        press: addInputItem,
                      ),
                      Divider(),
                      ConditionTile(
                          iconData: Icons.access_time,
                          title: "마감시간 설정",
                          press: () {}),
                      ConditionTile(
                          iconData: Icons.done_all,
                          title: "복수 선택",
                          press: () {}),
                      ConditionTile(
                          iconData: CustomIcon.user_secret,
                          title: "익명",
                          press: () {}),
                      ConditionTile(
                          iconData: Icons.playlist_add,
                          title: "선택항목 추가 허용",
                          press: () {}),
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
  final String title;
  final VoidCallback press;
  const ConditionTile({
    Key key,
    this.iconData,
    this.title,
    this.press,
  }) : super(key: key);

  @override
  _ConditionTileState createState() => _ConditionTileState();
}

class _ConditionTileState extends State<ConditionTile> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.iconData),
      title: Text(widget.title),
      trailing: IconButton(
        icon: checked
            ? Icon(
                Icons.check_circle,
                color: kPrimaryColor,
              )
            : Icon(Icons.check_circle_outline),
        onPressed: () {
          setState(() {
            checked = !checked;
          });
          widget.press();
        },
      ),
    );
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
