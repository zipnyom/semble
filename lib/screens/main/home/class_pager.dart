import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:schuul/screens/main/home/poster.dart';
import 'package:schuul/screens/main/home/provider/class_notifier.dart';
import 'package:schuul/screens/main/home/provider/page_notifier.dart';

import 'detail_page.dart';

const double SCALE_FACTOR = 0.9;
const double VIEW_PORT_FACTOR = 0.6;

class ClassPager extends StatefulWidget {
  @override
  _ClassPagerState createState() => _ClassPagerState();
}

class _ClassPagerState extends State<ClassPager> {
  static PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: VIEW_PORT_FACTOR)
      ..addListener(_onPageViewScrol);
  }

  @override
  void dispose() {
    if (_pageController != null) _pageController.dispose();
    super.dispose();
  }

  void _onPageViewScrol() {
    pageNotifier.value = _pageController.page;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassNotifier>(
      builder: (context, classNotifier, child) {
        return Transform.scale(
          scale: 12 / 10,
          child: PageView.builder(
            controller: _pageController,
            itemBuilder: (context, index) {
              return Consumer<PageNotifier>(
                builder: (context, page, child) {
                  double scale = 1 +
                      (SCALE_FACTOR - 1) *
                          (page.value - index.toDouble()).abs();
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 700),
                          pageBuilder: (_, __, ___) =>
                              DetailPage(classNotifier.classes[index])));
                    },
                    child: Hero(
                      tag: classNotifier.classes[index].className,
                      child: Poster(
                        scale: scale,
//                        img: classNotifier.classes[index].posterPath,
                        img: 'tmp',
                      ),
                    ),
                  );
                },
              );
            },
            itemCount: classNotifier.classes.length,
          ),
        );
      },
    );
  }
}
