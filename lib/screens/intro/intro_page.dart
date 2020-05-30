import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/data/join_or_login.dart';
import 'package:schuul/screens/auth/login.dart';

class IntroBannerPage extends StatefulWidget {
  @override
  _IntroBannerPageState createState() => _IntroBannerPageState();
}

final int _itemCount = 3;

final _introMessages = [
  '출석체크, 출석관리에 많은 스트레스가 있으신가요?',
  '참석자가 스마트폰으로 직접 출석체크할 수 있다면 얼마나 편리할까요?',
  'Semble로 시간과 노력을 절약해보세요!'
];

class _IntroBannerPageState extends State<IntroBannerPage> {
  PageController _pageController = PageController();
  LittleDotsPainter _littleDotsPainter = LittleDotsPainter(_itemCount, 0);
  Size size;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(onPageChanged);
  }

  void onPageChanged() {
//    print(_pageController.page);
    setState(() {
      _littleDotsPainter = LittleDotsPainter(_itemCount, _pageController.page);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (size == null) size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _images(size),
          Positioned(
              left: size.width / 2 - _itemCount * 5,
              right: size.width / 2 - _itemCount * 5,
              bottom: 5,
              height: size.width / _itemCount / 5,
              child: CustomPaint(painter: _littleDotsPainter)),
        ],
      ),
    );
  }

  PageView _images(Size size) {
    return PageView.builder(
      controller: _pageController,
      itemBuilder: (BuildContext context, int index) {
//        if (_pageController.position.haveDimensions == false)
//          return Container();
        int roundPage = 0;
        if (_pageController != null && _pageController.position.haveDimensions)
          roundPage = _pageController.page.round();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
//                child: Image.network(
//              "https://picsum.photos/220/300",
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/loading.gif',
                image: "https://picsum.photos/220/300",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: size.height * 0.2,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 20.0,
                    left: size.width * 0.1,
                    right: size.width * 0.1,
                    child: Text(
                      _introMessages[roundPage],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  _pageController != null &&
                          _pageController.position.haveDimensions &&
                          _pageController.page < _itemCount - 1.5
                      ? Container()
                      : Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: SizedBox(
                            height: 70,
                            width: size.width,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MultiProvider(providers: [
                                    ChangeNotifierProvider<JoinOrLogin>.value(
                                      value: JoinOrLogin(),
                                    ),

                                  ], child: AuthPage());
                                }));
                              },
                              child: Text("시작하기"),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        );
      },
      itemCount: _itemCount,
    );
  }
}

class LittleDotsPainter extends CustomPainter {
  final int numOfDots;
  final double page;

  LittleDotsPainter(this.numOfDots, this.page);

  @override
  void paint(Canvas canvas, Size size) {
    if (page > _itemCount - 1.5) return;
    for (int i = 0; i < numOfDots; i++) {
      canvas.drawCircle(
          Offset(size.width / numOfDots * i + (size.width / numOfDots / 2), 0),
          size.width / _itemCount / 4,
          Paint()
            ..color = Colors.red
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke);
    }
    canvas.drawCircle(
        Offset(size.width / numOfDots * page + (size.width / numOfDots / 2), 0),
        size.width / _itemCount / 4,
        Paint()..color = Colors.greenAccent);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return (oldDelegate as LittleDotsPainter).page != page;
  }
}
