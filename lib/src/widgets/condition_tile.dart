import 'package:flutter/material.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/clicker_type.dart';
import 'package:schuul/src/screens/main/timer_bottom_sheet.dart';

class ConditionTile extends StatefulWidget {
  final IconData iconData;
  final ClickerType type;
  final bool initialValue;
  final Function(bool, ClickerType) press;
  const ConditionTile({
    Key key,
    this.iconData,
    this.press,
    this.type,
    this.initialValue,
  }) : super(key: key);

  @override
  _ConditionTileState createState() => _ConditionTileState();
}

class _ConditionTileState extends State<ConditionTile> {
  bool checked;
  @override
  void initState() {
    checked = widget.initialValue;
    super.initState();
  }
  void pressed() {
    setState(() {
      checked = !checked;
    });
    widget.press(checked, widget.type);
  }

  Future<void> _showBottomSheet() async {
    List<int> hourlist = await showModalBottomSheet<List<int>>(
        context: context, builder: (context) => TimerBottonSheet());
    print(hourlist);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          if (widget.type == ClickerType.limited) {
            _showBottomSheet();
          } else {
            pressed();
          }
        },
        child: ListTile(
          leading: Icon(widget.iconData),
          title: Text(widget.type.name),
          trailing: IconButton(
            icon: checked
                ? Icon(
                    Icons.check_circle,
                    color: kPrimaryColor,
                  )
                : Icon(Icons.check_circle_outline),
            onPressed: pressed,
          ),
        ),
      ),
    );
  }
}
