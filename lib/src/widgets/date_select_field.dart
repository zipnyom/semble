import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ClassProvider option = Provider.of<ClassProvider>(context);
    DateTime date = widget.type == DateType.start
        ? option.startDate == null ? DateTime.now() : option.startDate
        : option.endDate == null ? DateTime.now() : option.endDate;
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Material(
        child: InkWell(
          onTap: () async {
            DateTime selected = await showDatePicker(
                context: context,
                locale: const Locale('ko', 'KO'),
                initialDate: date,
                firstDate: date.subtract(Duration(days: 365)),
                lastDate: date.add(Duration(days: 365)));
            if (selected == null) return;
            if (widget.type == DateType.start) {
              if (option.endDate != null) {
                if (selected.isAfter(option.endDate)) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("마감일보다 늦게 시작할 수 없습니다"),
                  ));
                  return;
                }
              }
              option.startDate = selected;
            } else if (widget.type == DateType.end) {
              if (option.startDate != null) {
                if (selected.isBefore(option.startDate)) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("시작일보다 일찍 종료할 수 없습니다"),
                  ));
                  return;
                }
              }
              option.endDate = selected;
            }
            controller.text = DateFormat("yy년 MM월 dd일").format(selected);
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
                      controller: controller,
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
  }
}
