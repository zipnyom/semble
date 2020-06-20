
import 'package:flutter/material.dart';
import 'package:schuul/data/enums/clicker_type.dart';
import 'package:schuul/presentation/custom_icon_icons.dart';
import 'package:schuul/screens/main/home/new_clicker.dart';

class QuizItem extends StatefulWidget {
  const QuizItem({Key key}) : super(key: key);

  @override
  _QuizItemState createState() => _QuizItemState();
}

class _QuizItemState extends State<QuizItem> {
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

  List<Widget> itemList;
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

    return Form(
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
              iconData: Icons.access_time, title: "마감시간 설정", press: () {}),
          ConditionTile(iconData: Icons.done_all, title: "복수 선택", press: () {}),
          ConditionTile(
              iconData: CustomIcon.user_secret, title: "익명", press: () {}),
          ConditionTile(
              iconData: Icons.playlist_add, title: "선택항목 추가 허용", press: () {}),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
