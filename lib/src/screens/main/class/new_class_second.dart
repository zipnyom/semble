import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/date_type.dart';
import 'package:schuul/src/data/enums/respond_type.dart';
import 'package:schuul/src/data/provider/class_option_provider.dart';
import 'package:schuul/src/obj/class.dart';
import 'package:schuul/src/services/database.dart';
import 'package:schuul/src/widgets/date_select_field.dart';
import 'package:schuul/src/widgets/day_select_field.dart';
import 'package:schuul/src/widgets/right_top_text_button.dart';
import 'package:schuul/src/widgets/widget.dart';
import 'package:table_calendar/table_calendar.dart';

final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

class NewClassScreen2 extends StatefulWidget {
  const NewClassScreen2({
    Key key,
  }) : super(key: key);
  @override
  _NewClassScreen2State createState() => _NewClassScreen2State();
}

class _NewClassScreen2State extends State<NewClassScreen2>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ClassType selectedRadio = ClassType.regular;
  // MyClass _class;

  //calendar
  bool isDispose;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  setSelectedRadio(ClassType val) {
    ClassProvider classProvider = Provider.of<ClassProvider>(context);
    setState(() {
      selectedRadio = val;
    });
    classProvider.myClass.type = val;
    print("setSelectedRadio => ${classProvider.myClass.type}");
  }

  @override
  void initState() {
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
      ClassProvider option = Provider.of<ClassProvider>(context, listen: false);
      if (_formKey.currentState.validate()) {
        RespondType res =
            await customShowDialog(context, "수업 생성", "수업을 생성하시겠습니까?");
        if (res == RespondType.no) {
          return;
        }

        FirebaseUser user = await FirebaseAuth.instance.currentUser();

        ClassProvider classProvider = Provider.of<ClassProvider>(context);

        classProvider.myClass.title =
            classProvider.myClass.titleController.text.trim();
        classProvider.myClass.description =
            classProvider.myClass.descriptionController.text.trim();
        classProvider.myClass.created = DateTime.now();
        classProvider.myClass.creator = user.uid;
        classProvider.myClass.startDate = option.startDate;
        classProvider.myClass.endDate = option.endDate;
        classProvider.myClass.weekDays = option.weekDays;
        classProvider.myClass.days = option.days;

        DocumentReference documentReference = await databaseService.addItem(
            db_col_class, classProvider.myClass.toJson());

        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child("classImage/${user.uid}/${documentReference.documentID}");

        if (classProvider.myClass.imageLocalPath != null) {
          StorageTaskSnapshot storageTaskSnapshot = await storageReference
              .putFile(File(classProvider.myClass.imageLocalPath))
              .onComplete;
          if (storageTaskSnapshot.error == null) {
            final String downloadUrl =
                await storageTaskSnapshot.ref.getDownloadURL();
            documentReference.updateData({"imageUrl": downloadUrl});
          }
        }
        Navigator.popUntil(context, (route) => route.isFirst);
        // Navigator.popUntil(context, ModalRoute.withName('/'));
      }
    }

    return Scaffold(
        appBar: customAppBarLeftText(context, "수업 일정 입력", "이전",
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
                      SizedBox(
                        height: 15,
                      ),
                      Text("기간"),
                      SizedBox(
                        height: 5,
                      ),
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
    return Consumer<ClassProvider>(builder: (context, pOption, child) {
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
          },
          todayDayBuilder: (context, date, _) {
            return Container(
              child: Center(
                child: Text("${date.day}"),
              ),
            );
          },
          markersBuilder: (context, date, events, holidays) {
            final children = <Widget>[];
            if (events.isNotEmpty) {
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
