import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/attend_type.dart';
import 'package:schuul/src/data/provider/mode_provider.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/screens/main/vote_list_screen.dart';
import 'package:schuul/src/obj/class_model.dart';
import 'package:schuul/src/screens/main/quiz_list.dart';
import 'package:schuul/src/screens/main/notice_detail.dart';
import 'package:schuul/src/screens/main/notice_list.dart';
import 'package:schuul/src/widgets/custom_appbar_item.dart';
import 'package:schuul/src/widgets/custom_box_shadow.dart';
import 'package:schuul/src/widgets/info_card.dart';
import 'package:schuul/src/widgets/sub_title.dart';
import 'package:schuul/src/services/database.dart';
import 'package:schuul/src/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:showcaseview/showcaseview.dart';

const double side_gap = 16;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isVisible = false;

  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  GlobalKey _four = GlobalKey();
  GlobalKey _five = GlobalKey();

  static Size size;
  void getClass() async {
    List<ClassModel> list = List<ClassModel>();
//    list.add(ClassModel(className: "test1", startDate: 1, endDate: 3));
//    list.add(ClassModel(className: "test2", startDate: 1, endDate: 3));
//    list.add(ClassModel(className: "test3", startDate: 1, endDate: 3));
    QuerySnapshot snapshot = await databaseService.selectAll("class");
    snapshot.documents.forEach((element) {
      list.add(ClassModel.fromJson(element.data));
    });
    // classNotifier.classes = list;
  }

  @override
  void initState() {
    getClass();
    WidgetsBinding.instance.addPostFrameCallback((_) => startShowcase());
    super.initState();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    print("ha. ha.");
    super.didUpdateWidget(oldWidget);
  }

  void startShowcase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeen = prefs.getBool('showcase') ?? false;
    print('hasSeen : $hasSeen');
    if (!hasSeen) {
      await prefs.setBool('showcase', true);
      ShowCaseWidget.of(context).startShowCase([_one, _two, _three, _four]);
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    String today = "${now.month}/${now.day}";

    return Scaffold(
      appBar: customAppBar("Today", false, [
        CAppBarItem(
          gKey: _one,
          iconData: CustomIcon.videocam,
          press: () {
            setState(() {
              isVisible = !isVisible;
              // ShowCaseWidget.of(context)
              //     .startShowCase([_one, _two, _three, _four]);
            });
          },
          description: "이 버튼을 눌러 강의를 시작하세요\n출석체크 기능이 활성화됩니다",
        ),
        CAppBarItem(
          gKey: _two,
          iconData: CustomIcon.comment,
          press: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => VoteListScreen()));
          },
          description: "투표를 통해 학생들의 생각을 물어볼 수 있습니다.",
        ),
        CAppBarItem(
          gKey: _three,
          iconData: CustomIcon.lightbulb,
          press: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => QuizList()));
          },
          description: "퀴즈를 만들고 학생들에게 풀게 할 수 있습니다.",
        ),
      ]),
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Background(size: size),
            Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(.5)),
              child: Consumer<Mode>(
                builder: (context, pMode, child) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("조정석님 \(${pMode.mode.name}\),",
                            style: kHeadingextStyle),
                        Text("오늘도 즐거운 수업 되세요!", style: kSubheadingextStyle),
                        Text("수업명 : 슬기로운 영어생활"),
                        SizedBox(
                          height: 50,
                        ),
                        // ClassTitle(),
                        SizedBox(
                          height: 20,
                        ),
                        SubTitle(
                            icon: CustomIcon.attach,
                            title: "$today 출석현황",
                            actions: []),
                        NarrowGap(),
                        AttendanceStatus(),
                        SizedBox(
                          height: 30,
                        ),
                        SubTitle(icon: CustomIcon.doc, title: "공지사항", actions: [
                          Material(
                              child: InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NoticeListPage())),
                                  child: Icon(Icons.more_horiz)))
                          // IconButton(
                          //   icon: Icon(Icons.more_horiz),
                          //   onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => NoticeListPage()));
                          //   },
                          // )
                        ]),
                        NarrowGap(),
                        NoticeList()
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 700),
              child: isVisible
                  ? Container(
                      child: Center(
                        child: Image.asset("assets/ripple.gif"),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 700),
              child: isVisible
                  ? Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    boxShadow: [customBoxShadow],
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "출석이 진행중입니다...",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Material(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isVisible = false;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [customBoxShadow],
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Text(
                                      "취소",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }
}

class NoticeList extends StatelessWidget {
  const NoticeList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InfoListItem(
          id: 1,
          title: sampleTitle1,
          date: "20/06/02",
        ),
        InfoListItem(id: 2, title: sampleTitle2, date: "20/06/03"),
        InfoListItem(
          id: 3,
          title: sampleTitle3,
          date: "20/06/10",
        ),
      ],
    );
  }
}

class Background extends StatelessWidget {
  const Background({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: SizedBox(
          height: size.height * .3,
          width: size.width * .5,
          child: SvgPicture.asset("assets/icons/undraw_teacher_35j2.svg")),
    );
  }
}

class InfoListItem extends StatelessWidget {
  final int id;
  final String title;
  final String date;

  const InfoListItem({
    Key key,
    this.id,
    this.title,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NoticeDetailPage()));
        },
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.07),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -7),
                    blurRadius: 33,
                    color: Color(0xFF6DAED9).withOpacity(0.11),
                  ),
                ],
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(date)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ]),
      ),
    );
  }
}

class NarrowGap extends StatelessWidget {
  const NarrowGap({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15,
    );
  }
}

class AttendanceStatus extends StatelessWidget {
  const AttendanceStatus({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InfoCard(
          type: AttendType.attend,
          iconColor: kAttendColor,
          count: 60,
          total: 100,
        ),
        InfoCard(
          type: AttendType.tardy,
          iconColor: kTardyColor,
          count: 12,
          total: 100,
        ),
        InfoCard(
          type: AttendType.cut,
          iconColor: kCutColor,
          count: 18,
          total: 100,
        ),
      ],
    );
  }
}
