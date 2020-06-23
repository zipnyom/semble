
import 'package:flutter/material.dart';
import 'package:schuul/src/data/enums/action_type.dart';

class CustomPopupMenuButton extends StatelessWidget {
  final List<ActionType> list;

  const CustomPopupMenuButton({
    Key key,
    this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: (value) {
          print(value);
        },
        child: Icon(Icons.more_vert),
        itemBuilder: (BuildContext context) =>
            List<PopupMenuEntry<ActionType>>.generate(
              list.length,
              (index) => PopupMenuItem<ActionType>(
                value: list[index],
                child: Align(
                    alignment: Alignment.center, child: Text(list[index].name)),
              ),
            ));
  }
}