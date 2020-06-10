import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:schuul/constants.dart';
import 'package:schuul/screens/main/home/model/class_model.dart';
import 'package:schuul/screens/main/home/provider/class_notifier.dart';
import 'package:schuul/screens/main/widgets/info_card.dart';
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
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 20, right: 20),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("조정석님,", style: kHeadingextStyle),
                Text("오늘도 즐거운 수업 되세요!", style: kSubheadingextStyle),
                SizedBox(height: 100,),
                Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.03),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Wrap(
                    runSpacing: 20,
                    spacing: 20,
                    children: <Widget>[
                      InfoCard(
                        title: "Confirmed Cases",
                        iconColor: Color(0xFFFF8C00),
                        effectedNum: 1062,
                        press: () {},
                      ),
                      InfoCard(
                        title: "Total Deaths",
                        iconColor: Color(0xFFFF2D55),
                        effectedNum: 75,
                        press: () {},
                      ),
                      InfoCard(
                        title: "Total Recovered",
                        iconColor: Color(0xFF50E3C2),
                        effectedNum: 689,
                        press: () {},
                      ),
                      InfoCard(
                        title: "New Cases",
                        iconColor: Color(0xFF5856D6),
                        effectedNum: 75,
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
                ),
              ],
            ),
          ],
        ),
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
