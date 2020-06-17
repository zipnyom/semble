import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:schuul/constants.dart';
import 'package:schuul/data/enums/attend_type.dart';
import 'package:schuul/presentation/custom_icon_icons.dart';
import 'package:schuul/screens/main/home/model/class_model.dart';
import 'package:schuul/screens/main/home/provider/class_notifier.dart';
import 'package:schuul/screens/main/notice_list.dart';
import 'package:schuul/screens/main/widgets/info_card.dart';
import 'package:schuul/services/class_database.dart';
import 'package:schuul/widgets/widget.dart';

const double side_gap = 16;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int _selectedIndex = 0;
  static Size size;

  static double searchTop = side_gap;
  static double nowPlayingTop = searchTop + 66 + side_gap;
  static double posterTop = nowPlayingTop + 72;
  static double ratingTop = size.width + posterTop + side_gap;
  static double titleTop = ratingTop + 18 + 8;
  static double genreTop = titleTop + 26 + 8;

  void getClass() async {
    List<ClassModel> list = List<ClassModel>();
//    list.add(ClassModel(className: "test1", startDate: 1, endDate: 3));
//    list.add(ClassModel(className: "test2", startDate: 1, endDate: 3));
//    list.add(ClassModel(className: "test3", startDate: 1, endDate: 3));
    QuerySnapshot snapshot = await ClassDatabaseMethods().getClass();
    snapshot.documents.forEach((element) {
      list.add(ClassModel.fromJson(element.data));
    });
    classNotifier.classes = list;
  }

  @override
  void initState() {
    getClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    String today = "${now.month}/${now.day}";

    return Scaffold(
      appBar: customAppBar("Today", false, []),
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Background(size: size),
            Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(.5)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("조정석님,", style: kHeadingextStyle),
                      Text("오늘도 즐거운 수업 되세요!", style: kSubheadingextStyle),
                      Text("수업명 : 슬기로운 영어생활"),
                      SizedBox(
                        height: 50,
                      ),
                      // ClassTitle(),
                      SizedBox(
                        height: 20,
                      ),
                      SubTitle(icon: CustomIcon.attach, title: "$today 출석현황"),
                      NarrowGap(),
                      AttendanceStatus(),
                      SizedBox(
                        height: 30,
                      ),
                      SubTitle(icon: CustomIcon.doc, title: "공지사항"),
                      NarrowGap(),
                      NoticeList()
                    ],
                  ),
                ),
              ),
            ),
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NoticeListPage(
                        id: id,
                      )));
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

class SubTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const SubTitle({Key key, this.title, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon),
      SizedBox(
        width: 10,
      ),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
            )
          ],
        ),
      ),
    ]);
  }
}
