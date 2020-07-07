import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';

class ItemInputDate extends StatefulWidget {
  const ItemInputDate({
    Key key,
    @required TextEditingController controller,
  })  : controller = controller,
        super(key: key);

  final TextEditingController controller;

  @override
  _ItemInputDateState createState() => _ItemInputDateState();
}

class _ItemInputDateState extends State<ItemInputDate> {
  DateTime selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Material(
        child: InkWell(
          onTap: () async {
            DateTime result = await showDatePicker(
              context: context,
              locale: const Locale('ko', 'KO'),
              initialDate: selected == null ? DateTime.now() : selected,
              firstDate: DateTime(2019),
              lastDate: DateTime(2024),
            );

            if (result != null) {
              selected = result;
              String strResult =
                  DateFormat('M월 d일 (E)', "ko_KO").format(result);
              widget.controller.text += strResult;
            }
          },
          child: Container(
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
                      enabled: false,
                      controller: widget.controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "항목 입력",
                        // border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Material(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.controller.clear();
                      });
                    },
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          CustomIcon.cancel_circle,
                          color: kTextLightColor,
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
