import 'package:flutter/material.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/obj/quiz.dart';
import 'package:schuul/src/screens/main/quiz_item.dart';
import 'package:schuul/src/widgets/right_top_text_button.dart';
import 'package:schuul/src/widgets/widget.dart';


class EditQuiz extends StatefulWidget {
  const EditQuiz({Key key}) : super(key: key);
  @override
  _EditQuizState createState() => _EditQuizState();
}

class _EditQuizState extends State<EditQuiz> {
  bool isVisible = false;

  List<Quiz> list;
  void packSampleQuizs() {
    list = List<Quiz>();
    for (int i = 1; i <= 20; i++) {
      String num = i.toString();
      list.add(new Quiz("${num}번퀴즈", "2020-06-04"));
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

  void swap(int a, int b) {
    setState(() {
      Quiz tmp = list[a];
      list[a] = list[b];
      list[b] = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBarLeading(context, "퀴즈 출제", Icon(Icons.close), [
          RightTopTextButton(
            title: "저장",
            press: () {},
          )
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: AnimatedSwitcher(
          switchInCurve: Curves.elasticInOut,
          switchOutCurve: Curves.elasticInOut,
          duration: Duration(milliseconds: 500),
          child: isVisible ? UpDownFloatings() : SizedBox.shrink(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ControlTab(
              list: list,
              swap: swap,
            ),
            quizItemList(
              list: list,
              press: (bool value, int index) {
                setState(() {
                  isVisible = !isVisible;
                  list[index].checked = value;
                });
              },
            )
          ],
        ));
  }
}

class ControlTab extends StatelessWidget {
  final Function(int, int) swap;

  const ControlTab({
    Key key,
    @required this.list,
    this.swap,
  }) : super(key: key);

  final List<Quiz> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kBackgroundColor, boxShadow: [
        BoxShadow(
          offset: Offset(0, 3),
          blurRadius: 1,
          color: Color(0xFF6DAED9).withOpacity(0.21),
        )
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_up),
            onPressed: () {
              for (int i = 1; i < list.length; i++) {
                Quiz q = list[i];
                if (q.checked) {
                  swap(i - 1, i);
                }
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
            onPressed: () {
              for (int j = list.length - 2; j > -1; j--) {
                Quiz q = list[j];
                if (q.checked) {
                  swap(j, j + 1);
                }
              }
            },
          ),
        ],
      ),
    );
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
    return Expanded(
      child: ListView.separated(
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
                          builder: (context) => 
                          // QuizItemEdit(),
                          QuizItem(),
                        ));
                  },
                ));
          }),
    );
  }
}
