import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/date_type.dart';
import 'package:schuul/src/data/enums/respond_type.dart';
import 'package:schuul/src/data/provider/class_option_provider.dart';
import 'package:schuul/src/data/provider/events_provider.dart';
import 'package:schuul/src/obj/class.dart';
import 'package:schuul/src/services/database.dart';
import 'package:schuul/src/widgets/date_select_field.dart';
import 'package:schuul/src/widgets/day_select_field.dart';
import 'package:schuul/src/widgets/right_top_text_button.dart';
import 'package:schuul/src/widgets/title_text_field.dart';
import 'package:schuul/src/widgets/widget.dart';
import 'package:table_calendar/table_calendar.dart';

final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

class NewClassScreen extends StatefulWidget {
  const NewClassScreen({
    Key key,
  }) : super(key: key);
  @override
  _NewClassScreenState createState() => _NewClassScreenState();
}

class _NewClassScreenState extends State<NewClassScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ClassType selectedRadio = ClassType.regular;
  Class _class;

  //calendar
  bool isDispose;
  // Map<DateTime, List> _events = Map<DateTime, List>();
  // Map<DateTime, List> _events = Map<DateTime, List>();
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  setSelectedRadio(ClassType val) {
    setState(() {
      selectedRadio = val;
    });
    _class.type = val;
    print("setSelectedRadio => ${_class.type}");
  }

  @override
  void initState() {
    _class = Class();

    // Events events = Provider.of<Events>(context);
    // events.addList([
    //   DateTime.now().add(Duration(days: 1)),
    //   DateTime.now().add(Duration(days: 2)),
    //   DateTime.now().add(Duration(days: 3)),
    //   DateTime.now().add(Duration(days: 4))
    // ]);
    // _events = {
    //   DateTime.now().add(Duration(days: 1)): ["AAA"],
    //   DateTime.now().add(Duration(days: 2)): ["AAA"],
    //   DateTime.now().add(Duration(days: 3)): ["AAA"],
    //   DateTime.now().add(Duration(days: 4)): ["AAA"],
    // };

    //calendar
    final _selectedDay = DateTime.now();
    // _selectedEvents = _events[_selectedDay] ?? [];
    // _selectedEvents = events.event[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    isDispose = true;
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    void onSubmit() async {
      ClassInfo option = Provider.of<ClassInfo>(context, listen: false);
      if (_formKey.currentState.validate()) {
        RespondType res =
            await customShowDialog(context, "수업 생성", "수업을 생성하시겠습니까?");
        if (res == RespondType.no) {
          return;
        }

        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        _class.title = _class.titleController.text.trim();
        _class.created = DateTime.now();
        _class.creator = user.uid;
        _class.startDate = option.startDate;
        _class.endDate = option.endDate;
        _class.weekDays = option.weekDays;
        _class.days = option.days;

        DocumentReference ref =
            await databaseService.addItem(db_col_class, _class.toJson());
        Navigator.pop(context);
      }
    }

    void onExit(BuildContext context) async {
      RespondType res =
          await customShowDialog(context, "닫기", "저장히지 않고 나가시겠습니까?");
      if (res == RespondType.yes) Navigator.of(context).pop();
    }

    return Scaffold(
        appBar: customAppBarLeadingWithDialog(
            context,
            "수업 정보 입력",
            Icon(Icons.close),
            onExit,
            [RightTopTextButton(title: "완료", press: onSubmit)]),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TitleTextField(
                          validateMessage: "수업명을 입력해주세요",
                          hintText: "수업명",
                          controller: _class.titleController),
                      SizedBox(
                        height: 15,
                      ),
                      Text("기간"),
                      SizedBox(
                        height: 5,
                      ),

                      // ButtonBar(
                      //   alignment: MainAxisAlignment.start,
                      //   children: <Widget>[
                      //     Radio(
                      //       value: ClassType.regular,
                      //       groupValue: selectedRadio,
                      //       activeColor: Colors.green,
                      //       onChanged: (val) {
                      //         setSelectedRadio(val);
                      //       },
                      //     ),
                      //     Text("정기 수업"),
                      //     SizedBox(
                      //       width: 10,
                      //     ),
                      //     Radio(
                      //       value: ClassType.irregular,
                      //       groupValue: selectedRadio,
                      //       activeColor: Colors.blue,
                      //       onChanged: (val) {
                      //         setSelectedRadio(val);
                      //       },
                      //     ),
                      //     Text("비정기 수업"),
                      //   ],
                      // ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DateSelectField(
                              type: DateType.start,
                            ),
                            DateSelectField(
                              type: DateType.end,
                            ),
                          ]),
                      SizedBox(
                        height: 10,
                      ),
                      Text("요일"),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                            7,
                            (index) => DaySelectField(
                                  day: index + 1,
                                )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("- 설정하신 수업일이 달력에 동그라미로 표시가 됩니다."),
                      SizedBox(
                        height: 5,
                      ),
                      Text("- 직접 날짜를 눌러 선택/해제 할 수 있습니다."),
                      SizedBox(
                        height: 5,
                      ),
                      _buildTableCalendarWithBuilders()
                    ],
                  ),
                ),
              ]),
            )));
  }

  Widget _buildTableCalendarWithBuilders() {
    return Consumer<ClassInfo>(builder: (context, pOption, child) {
      return TableCalendar(
        locale: 'ko_KR',
        calendarController: _calendarController,
        events: pOption.event,
        holidays: _holidays,
        initialCalendarFormat: CalendarFormat.month,
        formatAnimation: FormatAnimation.slide,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        availableGestures: AvailableGestures.horizontalSwipe,
        availableCalendarFormats: const {
          CalendarFormat.month: '',
          CalendarFormat.week: '',
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: true,
          weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
          holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
        ),
        headerStyle: HeaderStyle(
          centerHeaderTitle: true,
          formatButtonVisible: false,
        ),
        builders: CalendarBuilders(
          selectedDayBuilder: (context, date, _) {
            return Container(
              child: Center(
                child: Text("${date.day}"),
              ),
            );
            // return FadeTransition(
            //     opacity:
            //         Tween(begin: 0.0, end: 1.0).animate(_animationController),

            // child: Container(
            //   margin: const EdgeInsets.all(4.0),
            //   padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            //   color: Colors.deepOrange[300],
            //   width: 100,
            //   height: 100,
            //   child: Text(
            //     '${date.day}',
            //     style: TextStyle().copyWith(fontSize: 16.0),
            //   ),
            // ),
            // );
          },
          todayDayBuilder: (context, date, _) {
            return Container(
              child: Center(
                child: Text("${date.day}"),
              ),
            );
            // return Container(
            //   margin: const EdgeInsets.all(4.0),
            //   padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            //   color: Colors.amber[400],
            //   width: 100,
            //   height: 100,
            //   child: Text(
            //     '${date.day}',
            //     style: TextStyle().copyWith(fontSize: 16.0),
            //   ),
            // );
          },
          markersBuilder: (context, date, events, holidays) {
            final children = <Widget>[];
            if (events.isNotEmpty) {
              // children.add(
              //   Positioned(
              //     right: 1,
              //     bottom: 1,
              //     child: _buildEventsMarker(date, events),
              //   ),
              // );
              children.add(_buildEventsMarker(date, events));
            }

            if (holidays.isNotEmpty) {
              children.add(
                Positioned(
                  right: -2,
                  top: -2,
                  child: _buildHolidaysMarker(),
                ),
              );
            }

            return children;
          },
        ),
        onDaySelected: (date, events) {
          if (pOption.contains(date))
            pOption.delete(date);
          else
            pOption.add(date);
          // _onDaySelected(date, events);
          // _animationController.forward(from: 0.0);
        },
        onVisibleDaysChanged: _onVisibleDaysChanged,
        onCalendarCreated: _onCalendarCreated,
      );
    });
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return FadeTransition(
      opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Container(
          // margin: const EdgeInsets.all(4.0),
          // padding: const EdgeInsets.only(top: 5.0, left: 6.0),
          decoration: BoxDecoration(
              color: Colors.deepOrange[200],
              borderRadius: BorderRadius.circular(26)),
          width: 100,
          height: 100,
          child: Center(
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }
}
