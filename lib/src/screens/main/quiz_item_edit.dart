import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/clicker_type.dart';
import 'package:schuul/src/data/enums/quiz_type.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/widgets/right_top_text_button.dart';
import 'package:schuul/src/widgets/widget.dart';

class QuizItemEdit extends StatefulWidget {
  const QuizItemEdit({Key key}) : super(key: key);
  @override
  _QuizItemEditState createState() => _QuizItemEditState();
}

class _QuizItemEditState extends State<QuizItemEdit> {
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
                            value: QuizType.multiChoice,
                            groupValue: selectedRadio,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              print("Radio $val");
                              setSelectedRadio(val);
                            },
                          ),
                          Text(tMultipleChoice),
                          SizedBox(
                            width: 10,
                          ),
                          Radio(
                            value: QuizType.shortAnswer,
                            groupValue: selectedRadio,
                            activeColor: Colors.blue,
                            onChanged: (val) {
                              print("Radio $val");
                              setSelectedRadio(val);
                            },
                          ),
                          Text(tShortAnswer),
                        ],
                      ),
                      isShortAnswer
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(border: Border.all()),
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
                                ItemAddButton(
                                  press: addInputItem,
                                ),
                                Divider(),
                                ConditionTile(
                                    iconData: Icons.done_all,
                                    title: "복수 선택",
                                    press: () {}),
                              ],
                            ),
                      SizedBox(
                        height: 20,
                      )
                      ,DescriptionField(controller: descriptionController,)
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
  bool isAnswer = false;
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
            Material(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isAnswer = !isAnswer;
                  });
                },
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      isAnswer ? "정답" : "오답",
                      style: TextStyle(
                          color: isAnswer ? kPrimaryColor : kTextLightColor),
                    )),
              ),
            ),
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

    return Container(
      decoration: BoxDecoration(border: Border.all()),
      padding: EdgeInsets.symmetric(horizontal:16),
      child: SizedBox(
        height: 100,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: _controller,
          validator: (String value) {
            if (value.isEmpty) {
              return "문제 지문을 입력해주세요.";
            }
            return null;
          },
          decoration: InputDecoration(
            // icon: Icon(
            //   Icons.title,
            //   color: kPrimaryColor,
            // ),
            hintText: "문제 지문",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class DescriptionField extends StatelessWidget {
  const DescriptionField({
    Key key,
    @required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(border: Border.all()),
      padding: EdgeInsets.symmetric(horizontal:16),
      child: SizedBox(
        height: 100,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: _controller,
          decoration: InputDecoration(
            hintText: "정답 해설",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}