import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/constants.dart';
import 'package:schuul/data/enums/attend_type.dart';
import 'package:schuul/data/page_provider.dart';
import 'package:schuul/screens/main/home/model/attendance.dart';
import 'package:schuul/screens/main/widgets/sub_tab_item.dart';
import 'package:schuul/widgets/widget.dart';

class AttDetailPage extends StatelessWidget {
  final AttendType type;
  AttDetailPage({Key key, this.type}) : super(key: key);
  List<Attendance> list;
  void packSampleAttendance() {
    list = List<Attendance>();
    for (int i = 1; i <= 5; i++) {
      String num = i.toString();
      list.add(new Attendance("강의 " + num, "학생 " + num, "2020-06-03",
          "테스트출석" + num + "의 설명", "컨퍼머" + num, "방법" + (i + 5).toString()));
    }
    for (Attendance model in list) {
      print(model.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String today = "${now.year}-${now.month}-${now.day}";

    packSampleAttendance();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<PageProvider>.value(value: PageProvider())
        ],
        child: Scaffold(
          appBar: customAppBar("출석현황", true),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left),
                        onPressed: () {},
                      ),
                      Text(today),
                      IconButton(
                        icon: Icon(Icons.chevron_right),
                        onPressed: () {},
                      ),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SubTabItem(
                        iconColor: kAttendColor, title: AttendType.attend.name),
                    SubTabItem(
                        iconColor: kTardyColor, title: AttendType.tardy.name),
                    SubTabItem(
                        iconColor: kCutColor, title: AttendType.cut.name),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(list[index].className),
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ));
  }
}
