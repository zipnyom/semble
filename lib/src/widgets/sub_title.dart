
import 'package:flutter/material.dart';

class SubTitle extends StatelessWidget {
  final List<Widget> actions;
  final String title;
  final IconData icon;
  const SubTitle({Key key, this.title, this.icon, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon),
      SizedBox(
        width: 10,
      ),
      Expanded(
        child: RichText(
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
      ),
      Row(
        children: actions,
      )
    ]);
  }
}