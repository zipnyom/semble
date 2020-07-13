import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/obj/class.dart';
import 'package:schuul/src/widgets/custom_box_shadow.dart';
import 'package:schuul/src/widgets/widget.dart';

class ClassDetailScreen extends StatefulWidget {
  final MyClass myClass;
  final double height;

  const ClassDetailScreen({Key key, this.myClass, this.height})
      : super(key: key);
  @override
  _ClassDetailScreenState createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  ScrollController _scrollController;
  double topPadding;
  MyClass _myClass;

  @override
  void initState() {
    super.initState();
    topPadding = 100;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        topPadding = 225;
      });
    });
    _myClass = widget.myClass;
    _scrollController = ScrollController()
      ..addListener(() {
        print("offset = ${_scrollController.offset}");
        if (_scrollController.offset <= 10) {
          setState(() {
            topPadding = 225;
          });
        } else {
          setState(() {
            topPadding = 100;
          });
        }
      });
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: 300,
            child: ExtendedImage.network(_myClass.imageUrl,
                fit: BoxFit.fill,
                cache: true,
                loadStateChanged: myloadStateChanged),
          ),
          AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
              padding: EdgeInsets.only(top: topPadding),
              width: double.infinity,
              height: double.infinity,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                      boxShadow: [customBoxShadowReverse],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      color: Colors.white),
                  child: ListView(
                    controller: _scrollController,
                    physics: ClampingScrollPhysics(),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _myClass.title,
                            style: kHeadingextStyle,
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {},
                          )
                        ],
                      ),
                      Row(
                        children: [
                          ExtendedImage.network(_myClass.imageUrl,
                              width: 35,
                              height: 35,
                              fit: BoxFit.fill,
                              cache: true,
                              shape: BoxShape.circle,
                              loadStateChanged: myloadStateChanged),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      )
                    ],
                  ))),
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }
}
