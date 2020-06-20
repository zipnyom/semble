import 'package:flutter/material.dart';
import 'package:schuul/constants.dart';
import 'package:schuul/data/enums/action_type.dart';
import 'package:schuul/data/enums/quiz_type.dart';
import 'package:schuul/presentation/custom_icon_icons.dart';
import 'package:schuul/screens/main/home/quiz_detail.dart';
import 'package:schuul/screens/main/widgets/custom_popup_menu.dart';
import 'package:schuul/screens/main/widgets/filterchip.dart';
import 'package:schuul/widgets/widget.dart';

import 'model/quiz.dart';
import 'new_quiz.dart';

class QuizList extends StatefulWidget {
  QuizList({Key key}) : super(key: key);
  @override
  _QuizListState createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
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
      appBar: customAppBarLeading(context, "퀴즈", Icon(Icons.close), [
        IconButton(
          iconSize: 20,
          icon: Icon(CustomIcon.pencil),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewQuiz(),
                ));
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 15),
          child: CustomPopupMenuButton(
            list: [ActionType.bulkDelete],
          ),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: TextEditingController(),
                        onChanged: (value) {
                          print(value);
                        },
                        decoration: InputDecoration(
                            icon: Icon(
                              CustomIcon.search,
                              color: kTextLightColor,
                            ),
                            hintText: "검색..",
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
              // CategoryChips(),
              SizedBox(
                height: 10,
              ),
              ListView.separated(
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
                                list[index].quizName,
                                overflow: TextOverflow.ellipsis,
                              ),
                              CustomChip(
                                color: kPrimaryColor,
                                title: "정답률 89%",
                              ),
                              CustomChip(
                                color: Colors.deepOrange,
                                title: "만점 6명",
                              ),
                            ],
                          ),
                        ),
                        subtitle: Text(list[index].timeStamp),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: list[index].checked,
                        onChanged: (bool value) {
                          setState(() {
                            list[index].checked = value;
                          });
                        },
                        checkColor: Colors.white,
                        secondary: IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizDetail(
                                    id: 1,
                                    title: "한국에서 튤립을 재배할 수 있을까?",
                                  ),
                                ));
                          },
                        ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class CustomChip extends StatelessWidget {
  final Color color;
  final String title;

  const CustomChip({
    Key key,
    this.color,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
        // boxShadow: [customBoxShadow]
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }
}

class CategoryChips extends StatelessWidget {
  const CategoryChips({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TitleContainer(myTitle: "분류 필터"),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Wrap(
              spacing: 5.0,
              runSpacing: 3.0,
              children: <Widget>[
                FilterChipWidget(
                  chipName: QuizType.complete.name,
                  isSelected: false,
                ),
                FilterChipWidget(
                  chipName: QuizType.ing.name,
                  isSelected: false,
                ),
                FilterChipWidget(
                  chipName: QuizType.canceled.name,
                  isSelected: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TitleContainer extends StatelessWidget {
  const TitleContainer({
    Key key,
    @required this.myTitle,
  }) : super(key: key);

  final String myTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          myTitle,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
