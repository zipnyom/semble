import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/provider/class_option_provider.dart';

class DaySelectField extends StatefulWidget {
  const DaySelectField({
    this.day,
    Key key,
  }) : super(key: key);

  final int day;

  @override
  _DaySelectFieldState createState() => _DaySelectFieldState();
}

class _DaySelectFieldState extends State<DaySelectField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<ClassInfo>(builder: (context, option, child) {
      bool select = option.containWeekDay(widget.day);
      String dayString;
      switch (widget.day) {
        case 1:
          dayString = monday;
          break;
        case 2:
          dayString = tuesday;
          break;
        case 3:
          dayString = wednesday;
          break;
        case 4:
          dayString = thursday;
          break;
        case 5:
          dayString = friday;
          break;
        case 6:
          dayString = saturday;
          break;
        case 7:
          dayString = sunday;
          break;
      }
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Material(
          child: InkWell(
            onTap: () {
              if (option.containWeekDay(widget.day)) {
                option.removeWeekDay(widget.day);
              } else {
                option.addWeekDay(widget.day);
              }
            },
            child: Container(
              width: size.width * .1,
              decoration: BoxDecoration(
                color: select
                    ? Colors.blueAccent.withOpacity(.5)
                    : Colors.transparent,
                border: Border.all(
                  width: 2,
                  color: kTextLightColor,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(dayString)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
