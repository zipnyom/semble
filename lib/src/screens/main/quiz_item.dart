import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/quiz_type.dart';
import 'package:schuul/src/widgets/right_top_text_button.dart';
import 'package:schuul/src/widgets/widget.dart';

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
  final TextEditingController descriptionController = TextEditingController();
  QuizType selectedRadio = QuizType.multiChoice;
  bool isLoading = false;
  bool isShortAnswer = false;

  setSelectedRadio(QuizType val) {
    setState(() {
      if (val == QuizType.shortAnswer) {
        isShortAnswer = true;
      } else {
        isShortAnswer = false;
      }
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
        appBar: customAppBarLeading(context, "문제 편집", Icon(Icons.close), [
          RightTopTextButton(
            title: "완료",
            press: () {
              if (_formKey.currentState.validate()) {
                Navigator.pop(context);
              }
            },
          )
        ]),
        body: Stack(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                              "사소한 무질서를 방치하면 큰 문제로 이어질 가능성이 높으므로 경범죄로부터 발본색원해야 한다는 범죄 심리학 이론은 무엇인가?"),
                          SizedBox(
                            height: 30,
                          ),
                          isShortAnswer
                              ? Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  child: TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    controller: TextEditingController(),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "정답 입력",
                                      // border: InputBorder.none,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Column(
                                      children: itemList,
                                    ),
                                    ConditionTile(
                                        iconData: Icons.done_all,
                                        title: "복수 선택",
                                        press: () {}),
                                  ],
                                ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ]),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        child: InkWell(onTap: () {}, child: Text("test")),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
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
  bool checked = false;
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
            IconButton(
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
