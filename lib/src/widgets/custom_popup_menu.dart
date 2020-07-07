import 'package:flutter/material.dart';
import 'package:schuul/src/data/enums/action_type.dart';
import 'package:schuul/src/obj/action_model.dart';

class CustomPopupMenuButton extends StatelessWidget {
  final List<ActionModel> list;

  const CustomPopupMenuButton({
    Key key,
    this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: (value) {
          List<ActionModel> filtered =
              list.where((element) => element.type == value).toList();
          filtered.first.press();
        },
        child: Icon(Icons.more_vert),
        itemBuilder: (BuildContext context) =>
            List<PopupMenuEntry<ActionType>>.generate(
              list.length,
              (index) => PopupMenuItem<ActionType>(
                value: list[index].type,
                child: Align(
                    alignment: Alignment.center,
                    child: Text(list[index].type.name)),
              ),
            ));
  }
}
