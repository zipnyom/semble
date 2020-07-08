import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/date_type.dart';
import 'package:schuul/src/data/provider/class_option_provider.dart';

class DateSelectField extends StatefulWidget {
  const DateSelectField({
    Key key,
    this.type,
  }) : super(key: key);

  final DateType type;

  @override
  _DateSelectFieldState createState() => _DateSelectFieldState();
}

class _DateSelectFieldState extends State<DateSelectField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<ClassOption>(builder: (context, option, child) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Material(
          child: InkWell(
            onTap: () {
              showDatePicker(
                  context: context,
                  initialDate: widget.type == null
                      ? DateTime.now()
                      : widget.type == DateType.start
                          ? option.startDate
                          : option.endDate,
                  firstDate: option.startDate.subtract(Duration(days: 365)),
                  lastDate: option.startDate.add(Duration(days: 365)));
            },
            child: Container(
              width: size.width * .4,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: kTextLightColor,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: TextEditingController(),
                        decoration: InputDecoration(
                            enabled: false,
                            border: InputBorder.none,
                            hintText:
                                widget.type == DateType.start ? "시작일" : "종료일"),
                      ),
                    ),
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
