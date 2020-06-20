import 'package:flutter/material.dart';
import 'package:schuul/constants.dart';
import 'package:schuul/data/enums/clicker_type.dart';
import 'package:schuul/presentation/custom_icon_icons.dart';
import 'package:schuul/screens/main/home/quiz_detail.dart';
import 'package:schuul/screens/main/home/quiz_item_detail.dart';
import 'package:schuul/screens/main/notice_list.dart';
import 'package:schuul/screens/main/widgets/right_top_text_button.dart';
import 'package:schuul/widgets/widget.dart';

import 'model/quiz.dart';

class NewQuiz extends StatefulWidget {
  const NewQuiz({Key key}) : super(key: key);
  @override
  _NewQuizState createState() => _NewQuizState();
}

class _NewQuizState extends State<NewQuiz> {
  bool isVisible = false;

  List<Quiz> list;
  void packSampleQuizs() {
    list = List<Quiz>();
    for (int i = 1; i <= 20; i++) {
      String num = i.toString();
      list.add(
          new Quiz("퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈" + num, "2020-06-04"));
    }
    // for (Quiz model in list) {
    //   print(model.toJson());
    // }
  }

  @override
  void initState() {
    packSampleQuizs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBarLeading(context, "퀴즈 출제", Icon(Icons.close), [
          RightTopTextButton(
            title: "저장",
            press: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
          )
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: AnimatedSwitcher(
          switchInCurve: Curves.elasticInOut,
          switchOutCurve: Curves.elasticInOut,
          duration: Duration(milliseconds: 500),
          child: isVisible ? UpDownFloatings() : SizedBox.shrink(),
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                quizItemList(
                  list: list,
                  press: (bool value, int index) {
                    setState(() {
                      list[index].checked = value;
                    });
                  },
                )
              ],
            ),
          ),
        ));
  }
}

class UpDownFloatings extends StatelessWidget {
  const UpDownFloatings({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.arrow_upward),
              ),
              SizedBox(
                height: 20,
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.arrow_downward),
              ),
              SizedBox(
                height: 20,
              )
            ],
          )
        ],
      ),
    );
  }
}

class quizItemList extends StatelessWidget {
  const quizItemList({
    Key key,
    @required this.list,
    this.press,
  }) : super(key: key);

  final List<Quiz> list;
  final Function(bool, int) press;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (_, index) {
          return CheckboxListTile(
              title: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    Text(
                      "${index + 1}번 문제",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: kTextLightColor, fontSize: 13),
                    ),
                    // CustomChip(
                    //   color: kPrimaryColor,
                    //   title: "정답률 89%",
                    // ),
                    // CustomChip(
                    //   color: Colors.deepOrange,
                    //   title: "만점 6명",
                    // ),
                  ],
                ),
              ),
              subtitle: Text(
                list[index].quizName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              value: list[index].checked,
              onChanged: (bool value) => press(value, index),
              checkColor: Colors.white,
              secondary: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizItemDetail(),
                      ));
                },
              ));
        });
  }
}
