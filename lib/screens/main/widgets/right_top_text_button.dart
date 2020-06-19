import 'package:flutter/material.dart';

class RightTopTextButton extends StatelessWidget {
  final VoidCallback press;

  const RightTopTextButton({
    Key key,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: press,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "완료",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}