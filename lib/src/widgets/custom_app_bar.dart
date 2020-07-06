import 'package:flutter/material.dart';
import 'package:schuul/src/constants.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool centerTitle;
  final List<Widget> actions;

  const CustomAppBar({Key key, this.title, this.centerTitle, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(
          title,
          style: TextStyle(color: kTextColor),
        ),
        iconTheme: IconThemeData(
          color: kTextColor, //change your color here
        ),
        centerTitle: centerTitle,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: actions);
  }
}
