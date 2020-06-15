import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/constants.dart';
import 'package:schuul/data/enums/attend_type.dart';
import 'package:schuul/data/page_provider.dart';
import 'package:schuul/screens/main/home/model/attendance.dart';
import 'package:schuul/screens/main/widgets/sub_tab_item.dart';
import 'package:schuul/widgets/widget.dart';

class AttDetailPage extends StatefulWidget {
  final AttendType type;
  AttDetailPage({Key key, this.type}) : super(key: key);

  @override
  _AttDetailPageState createState() => _AttDetailPageState();
}

class _AttDetailPageState extends State<AttDetailPage> {
  List<Attendance> list;
  var _tapPosition;
  void packSampleAttendance() {
    list = List<Attendance>();
    for (int i = 1; i <= 5; i++) {
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

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String today = "${now.year}-${now.month}-${now.day}";

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<PageProvider>.value(value: PageProvider())
        ],
        child: Scaffold(
          appBar: customAppBar("출석현황", true),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                SizedBox(
                  height: 20,
                ),
                ListView.builder(
                    shrinkWrap: true,
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
                        secondary: 
                        // PopupMenuButton()
                        Material(
                            child: InkWell(
                                onTapDown: (details) {
                                  print("test2");
                                },
                                child: Icon(Icons.more_vert))),
                      );
                    })
              ],
            ),
          ),
        ));
  }

  void _storePosition(TapDownDetails details) {
    print("test");
    setState(() {
      _tapPosition = details.globalPosition;
    });
  }

  _showPopupMenu() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        PopupMenuItem(
          child: Text("View"),
        ),
        PopupMenuItem(
          child: Text("Edit"),
        ),
        PopupMenuItem(
          child: Text("Delete"),
        ),
      ],
      elevation: 8.0,
    );
  }
}
