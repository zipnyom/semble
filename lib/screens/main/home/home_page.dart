import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:schuul/constants.dart';
import 'package:schuul/presentation/custom_icon_icons.dart';
import 'package:schuul/screens/main/home/model/class_model.dart';
import 'package:schuul/screens/main/home/provider/class_notifier.dart';
import 'package:schuul/screens/main/widgets/attendance_card.dart';
import 'package:schuul/services/class_database.dart';

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

    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: SizedBox(
                height: size.height * .3,
                width: size.width * .5,
                child:
                    SvgPicture.asset("assets/icons/undraw_teacher_35j2.svg")),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(.5)),
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20),
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
                    ClassSubTitle(
                        icon: CustomIcon.attach, title: "$today 출석현황"),
                    NarrowGap(),
                    CheckStatus(),
                    SizedBox(
                      height: 30,
                    ),
                    ClassSubTitle(icon: CustomIcon.doc, title: "공지사항"),
                    NarrowGap(),

                    InfoListItem(
                      title: "안녕하세요 여러분 조정석입니다. 슬기로운 의사생활 때려치고 강의를 시작했어요",
                      date: "20/06/02",
                    ),
                    InfoListItem(
                        title: "다음주 토요일 수업에 퀴즈 할 예정입니다.", date: "20/06/03"),
                    InfoListItem(
                      title: "지각 정책 안내",
                      date: "20/06/10",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider<ClassNotifier>.value(value: classNotifier),
//         ChangeNotifierProvider<PageNotifier>.value(value: pageNotifier),
//       ],
//       child: SafeArea(
//         child: Container(
//           constraints: BoxConstraints.expand(),
//           child: Consumer2<ClassNotifier, PageNotifier>(
//             builder: (context, movieNotifier, pageNotifier, child) {
//               if (movieNotifier.classes.isEmpty) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               ClassModel classModel =
//                   classNotifier.classes[pageNotifier.value.floor()];
//               return Stack(
//                 children: <Widget>[
//                   Positioned(
//                       top: 0,
//                       left: 0,
//                       right: 0,
//                       height: size.width,
// //                  child:
// //                      PostPager(page: _page, pageController: _pageController)),
//                       child: ClassPager()),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
  }
}

class InfoListItem extends StatelessWidget {
  final String title;
  final String date;

  const InfoListItem({
    Key key,
    this.title,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
    ]);
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

class CheckStatus extends StatelessWidget {
  const CheckStatus({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: kPrimaryColor.withOpacity(0.03),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Wrap(
        runSpacing: 10,
        spacing: 20,
        children: <Widget>[
          AttendanceCard(
            title: "출석",
            iconColor: Color(0xFFFF8C00),
            effectedNum: 60,
            totalNum: 100,
            press: () {},
          ),
          AttendanceCard(
            title: "결석",
            iconColor: Color(0xFFFF2D55),
            effectedNum: 12,
            totalNum: 100,
            press: () {},
          ),
          AttendanceCard(
            title: "지각",
            iconColor: Colors.blueAccent,
            effectedNum: 18,
            totalNum: 100,
            press: () {},
          ),
          AttendanceCard(
            title: "사전협의",
            iconColor: Color(0xFF5856D6),
            effectedNum: 10,
            totalNum: 100,
            press: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return DetailsScreen();
              //     },
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}

class ClassSubTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const ClassSubTitle({Key key, this.title, this.icon}) : super(key: key);

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

class ClassTitle extends StatelessWidget {
  const ClassTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "슬기로운 영어 생활",
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
