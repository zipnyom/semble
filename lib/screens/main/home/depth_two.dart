import 'package:flutter/material.dart';
import 'package:schuul/data/enums/action_type.dart';
import 'package:schuul/screens/main/widgets/custom_popup_menu.dart';
import 'package:schuul/widgets/widget.dart';

class DepthTwo extends StatelessWidget {
  const DepthTwo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("출석현황", true, [
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: CustomPopupMenuButton(
            list: [
              ActionType.bulkAttend,
              ActionType.bulkCut
            ],
          ),
        )
      ]),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Container(),
      ),
    );
  }
}
