import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/action_type.dart';
import 'package:schuul/src/data/enums/attend_type.dart';
import 'package:schuul/src/obj/action_model.dart';
import 'package:schuul/src/obj/attendance.dart';
import 'package:schuul/src/widgets/choicecip.dart';
import 'package:schuul/src/widgets/custom_popup_menu.dart';
import 'package:schuul/src/widgets/filterchip.dart';
import 'package:schuul/src/widgets/sub_tab_item.dart';
import 'package:schuul/src/widgets/widget.dart';

class AttDetailPage extends StatefulWidget {
  final AttendType type;
  AttDetailPage({Key key, this.type}) : super(key: key);
  @override
  _AttDetailPageState createState() => _AttDetailPageState();
}

class _AttDetailPageState extends State<AttDetailPage> {
  List<Attendance> list;
  void packSampleAttendance() {
    list = List<Attendance>();
    for (int i = 1; i <= 20; i++) {
      String num = i.toString();
      list.add(new Attendance("강의 " + num, "학생 " + num, "2020-06-03",
          "테스트출석" + num + "의 설명", "컨퍼머" + num, "방법" + (i + 5).toString()));
    }
    // for (Attendance model in list) {
    //   print(model.toJson());
    // }
  }

  @override
  void initState() {
    packSampleAttendance();
    super.initState();
  }

  attendPress() {}
  tardyPress() {}
  cutPress() {}
  bulkAttendPress() {}
  bulkTardyPress() {}
  bulkCutPress() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("출석현황", true, [
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: CustomPopupMenuButton(
            list: [
              ActionModel(ActionType.bulkAttend, bulkAttendPress),
              ActionModel(ActionType.bulkTardy, bulkTardyPress),
              ActionModel(ActionType.bulkCut, bulkCutPress),
            ],
          ),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ChooseDate(),
              // CustomChip(),
              CategoryChips(
                defaultType: widget.type,
              ),
              SortChips(),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    return CheckboxListTile(
                        title: Text(list[index].studentName),
                        subtitle: Text(list[index].timeStamp),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: list[index].checked,
                        onChanged: (bool value) {
                          print(list[index].checked);
                          setState(() {
                            list[index].checked = value;
                          });
                          print(list[index].checked);
                        },
                        checkColor: Colors.white,
                        secondary: CustomPopupMenuButton(
                          list: [
                            ActionModel(ActionType.attend, attendPress),
                            ActionModel(ActionType.tardy, tardyPress),
                            ActionModel(ActionType.cut, cutPress),
                          ],
                        ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class ChooseDate extends StatefulWidget {
  const ChooseDate({
    Key key,
  }) : super(key: key);

  @override
  _ChooseDateState createState() => _ChooseDateState();
}

class _ChooseDateState extends State<ChooseDate> {
  static DateTime curDate = DateTime.now();
  String curDateString = DateFormat('M월 d일 (E)', "ko_KO").format(curDate);

  @override
  Widget build(BuildContext context) {
    double iconSize = 35;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      IconButton(
        icon: Icon(Icons.chevron_left),
        iconSize: iconSize,
        onPressed: () {
          setState(() {
            curDate = curDate.subtract(Duration(days: 1));
            curDateString = DateFormat('M월 d일 (E)', "ko_KO").format(curDate);
          });
        },
      ),
      Material(
        child: InkWell(
          onTap: () async {
            DateTime result = await showDatePicker(
              context: context,
              locale: const Locale('ko', 'KO'),
              initialDate: DateTime.now(),
              firstDate: DateTime(2019),
              lastDate: DateTime(2024),
            );

            if (result != null) {
              print(DateFormat().locale);
              String strResult =
                  DateFormat('M월 d일 (E)', "ko_KO").format(result);
              setState(() {
                curDate = result;
                curDateString = strResult;
              });
            }
          },
          child: Text(
            curDateString,
            style: TextStyle(
                color: Colors.black,
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      IconButton(
        icon: Icon(Icons.chevron_right),
        iconSize: 35,
        onPressed: () {
          setState(() {
            curDate = curDate.add(Duration(days: 1));
            curDateString = DateFormat('M월 d일 (E)', "ko_KO").format(curDate);
          });
        },
      ),
    ]);
  }
}

class SortChips extends StatelessWidget {
  const SortChips({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TitleContainer(myTitle: "정렬"),
        Container(
            child: Wrap(
          spacing: 5.0,
          runSpacing: 5.0,
          children: <Widget>[
            ChoiceChipWidget([
              "이름순",
              "시간순",
              "분류순",
            ], "이름순"),
          ],
        )),
      ],
    );
  }
}

class CategoryChips extends StatelessWidget {
  final AttendType defaultType;
  const CategoryChips({
    Key key,
    this.defaultType,
  }) : super(key: key);

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
                // FilterChipWidget(
                //   voteType: AttendType.attend.name,
                //   isSelected: defaultType == AttendType.attend,
                // ),
                // FilterChipWidget(
                //   voteType: AttendType.tardy.name,
                //   isSelected: defaultType == AttendType.tardy,
                // ),
                // FilterChipWidget(
                //   voteType: AttendType.cut.name,
                //   isSelected: defaultType == AttendType.cut,
                // ),
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

class CustomChip extends StatelessWidget {
  const CustomChip({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SubTabItem(iconColor: kAttendColor, title: AttendType.attend.name),
        SubTabItem(iconColor: kTardyColor, title: AttendType.tardy.name),
        SubTabItem(iconColor: kCutColor, title: AttendType.cut.name),
      ],
    );
  }
}
