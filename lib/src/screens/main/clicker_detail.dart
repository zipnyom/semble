import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:schuul/src/data/enums/action_type.dart';
import 'package:schuul/src/obj/action_model.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/obj/response.dart';
import 'package:schuul/src/widgets/custom_popup_menu.dart';
import 'package:schuul/src/widgets/indicator.dart';
import 'package:schuul/src/widgets/sub_title.dart';
import 'package:schuul/src/widgets/widget.dart';

class ClickerDetail extends StatefulWidget {
  final int id;
  final String title;

  const ClickerDetail({Key key, this.id, this.title}) : super(key: key);

  @override
  _ClickerDetailState createState() => _ClickerDetailState();
}

class _ClickerDetailState extends State<ClickerDetail> {
  int touchedIndex;

  List<Response> list;
  void packSampleResponses() {
    list = List<Response>();
    for (int i = 1; i <= 20; i++) {
      String num = i.toString();
      list.add(new Response("클리커N", "학생$num", "yes"));
    }
    // for (Response model in list) {
    //   print(model.toJson());
    // }
  }

  @override
  void initState() {
    packSampleResponses();
    super.initState();
  }

  deletePress() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar("클리커 정보", true, [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: CustomPopupMenuButton(
              list: [ActionModel(ActionType.delete, deletePress)],
            ),
          )
        ]),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: 10,
                ),
                SubTitle(
                  icon: CustomIcon.comment,
                  title: widget.title,
                  actions: [],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Indicator(
                      color: const Color(0xff0293ee),
                      text: 'YES',
                      isSquare: false,
                      size: touchedIndex == 0 ? 18 : 16,
                      textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
                    ),
                    Indicator(
                      color: const Color(0xfff8b250),
                      text: 'NO',
                      isSquare: false,
                      size: touchedIndex == 1 ? 18 : 16,
                      textColor: touchedIndex == 1 ? Colors.black : Colors.grey,
                    ),
                    Indicator(
                      color: const Color(0xff845bef),
                      text: 'Not Sure',
                      isSquare: false,
                      size: touchedIndex == 2 ? 18 : 16,
                      textColor: touchedIndex == 2 ? Colors.black : Colors.grey,
                    ),
                  ],
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                        pieTouchData:
                            PieTouchData(touchCallback: (pieTouchResponse) {
                          setState(() {
                            if (pieTouchResponse.touchInput is FlLongPressEnd ||
                                pieTouchResponse.touchInput is FlPanEnd) {
                              touchedIndex = -1;
                            } else {
                              touchedIndex =
                                  pieTouchResponse.touchedSectionIndex;
                            }
                          });
                        }),
                        startDegreeOffset: 180,
                        borderData: FlBorderData(
                          show: false,
                        ),
                        // sectionsSpace: 12,
                        centerSpaceRadius: 50,
                        sections: showingSections()),
                  ),
                ),
                SubTitle(
                  icon: CustomIcon.user,
                  title: "응답 리스트",
                  actions: [],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                          title: Text(list[index].resposne),
                          subtitle: Text(list[index].studentId));
                    })
              ]),
            )));
  }

  List<PieChartSectionData> showingSections() {
    double radius = 80;
    return List.generate(
      3,
      (i) {
        final isTouched = i == touchedIndex;
        final double opacity = isTouched ? 1 : 0.6;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: const Color(0xff0293ee).withOpacity(opacity),
              value: 40,
              title: '40%',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,
            );
          case 1:
            return PieChartSectionData(
              color: const Color(0xfff8b250).withOpacity(opacity),
              value: 50,
              title: '50%',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff90672d)),
              titlePositionPercentageOffset: 0.55,
            );
          case 2:
            return PieChartSectionData(
              color: const Color(0xff845bef).withOpacity(opacity),
              value: 10,
              title: '10%',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff4c3788)),
              titlePositionPercentageOffset: 0.6,
            );
          default:
            return null;
        }
      },
    );
  }
}
