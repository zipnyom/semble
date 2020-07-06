

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/widgets/sub_title.dart';

class TimerBottonSheet extends StatefulWidget {
  const TimerBottonSheet({
    Key key,
  }) : super(key: key);

  @override
  _TimerBottonSheetState createState() => _TimerBottonSheetState();
}

class _TimerBottonSheetState extends State<TimerBottonSheet> {
  int _hour = 0;
  int _minute = 0;
  int _second = 0;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: modalMaxWidth,

            // If we're showing the wide layout, make sure this modal
            // isn't too tall by using a factor of the same width
            // constraint as a constraint for the height.
            maxHeight: modalMaxWidth * 1.1),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: Container(
                padding: EdgeInsets.all(20),
                color: modalBackgroundColor,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SubTitle(
                        icon: Icons.timer, title: "시간을 선택하세요", actions: []),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("시"),
                                NumberPicker.integer(
                                    initialValue: _hour,
                                    minValue: 0,
                                    maxValue: 23,
                                    onChanged: (newValue) =>
                                        setState(() => _hour = newValue)),
                              ]),
                          Column(
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("분"),
                                NumberPicker.integer(
                                    initialValue: _minute,
                                    minValue: 0,
                                    maxValue: 59,
                                    onChanged: (newValue) =>
                                        setState(() => _minute = newValue)),
                              ]),
                          Column(
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("초"),
                                NumberPicker.integer(
                                    initialValue: _second,
                                    minValue: 0,
                                    maxValue: 59,
                                    onChanged: (newValue) =>
                                        setState(() => _second = newValue)),
                              ])
                        ],
                      ),
                    ),
                    Material(
                      child: InkWell(
                        onTap: () =>
                            Navigator.pop(context, [_hour, _minute, _second]),
                        child: Container(
                          color: kPrimaryColor,
                          height: 50,
                          child: Center(
                              child: Text(
                            "선택",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    )
                  ],
                ))));
  }
}
