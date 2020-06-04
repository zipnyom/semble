import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/screens/main/home/model/class_model.dart';
import 'package:schuul/screens/main/home/provider/class_notifier.dart';
import 'package:schuul/screens/main/home/provider/page_notifier.dart';
import 'package:schuul/widgets/widget.dart';

import 'class_pager.dart';

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

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    List<ClassModel> list = List<ClassModel>();
    list.add(ClassModel(name: "test1", start: 1, end: 3));
    list.add(ClassModel(name: "test2", start: 1, end: 3));
    list.add(ClassModel(name: "test3", start: 1, end: 3));

    classNotifier.classes = list;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ClassNotifier>.value(value: classNotifier),
        ChangeNotifierProvider<PageNotifier>.value(value: pageNotifier),
      ],
      child: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          child: Consumer2<ClassNotifier, PageNotifier>(
            builder: (context, movieNotifier, pageNotifier, child) {
              if (movieNotifier.classes.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              ClassModel classModel =
                  classNotifier.classes[pageNotifier.value.floor()];
              return Stack(
                children: <Widget>[
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: size.width,
//                  child:
//                      PostPager(page: _page, pageController: _pageController)),
                      child: ClassPager()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
