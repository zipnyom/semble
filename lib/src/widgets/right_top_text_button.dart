import 'package:flutter/material.dart';

class RightTopTextButton extends StatelessWidget {

  final VoidCallback press;
  final String title;
  const RightTopTextButton({
    Key key,
    this.press, this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: press,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}