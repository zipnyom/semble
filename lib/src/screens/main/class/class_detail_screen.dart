import 'package:flutter/material.dart';

class ClassDetailScreen extends StatefulWidget {
  @override
  _ClassDetailScreenState createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  ScrollController _scrollController;
  double height;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        print("offset = ${_scrollController.offset}");
        if (_scrollController.offset == 0) {
          setState(() {
            height = 200;
          });
        } else {
          setState(() {
            height = 100;
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
        body: Column(
      children: [
        Stack(
          children: [
            AnimatedContainer(
              height: height,
              decoration: BoxDecoration(color: Colors.brown[100]),
              duration: Duration(milliseconds: 100),
            )
          ],
        ),
        Expanded(
          child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) => ListTile(
                    title: Text("$index"),
                  )),
        )
      ],
    ));
  }
}
