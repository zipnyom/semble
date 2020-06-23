import 'package:flutter/material.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/action_type.dart';
import 'package:schuul/src/data/enums/clicker_type.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/screens/main/clicker_detail.dart';
import 'package:schuul/src/obj/clicker.dart';
import 'package:schuul/src/screens/main/new_clicker.dart';
import 'package:schuul/src/widgets/custom_box_shadow.dart';
import 'package:schuul/src/widgets/custom_popup_menu.dart';
import 'package:schuul/src/widgets/filterchip.dart';
import 'package:schuul/src/widgets/widget.dart';

class ClickerList extends StatefulWidget {
  ClickerList({Key key}) : super(key: key);
  @override
  _ClickerListState createState() => _ClickerListState();
}

class _ClickerListState extends State<ClickerList> {
  List<Clicker> list;
  void packSampleClickers() {
    list = List<Clicker>();
    for (int i = 1; i <= 20; i++) {
      String num = i.toString();
      list.add(new Clicker(
          "클리커클리커클리커클리커클리커클리커클리커클리커클리커클리커클리커클리커클리커" + num, "2020-06-04"));
    }
    // for (Clicker model in list) {
    //   print(model.toJson());
    // }
  }

  @override
  void initState() {
    packSampleClickers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarLeading(context, "클리커", Icon(Icons.close), [
        IconButton(
          iconSize: 20,
          icon: Icon(CustomIcon.pencil),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewClicker(),
                ));
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 15),
          child: CustomPopupMenuButton(
            list: [
              ActionType.bulkDelete
            ],
          ),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // CustomChip(),
              CategoryChips(),
              SizedBox(
                height: 10,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: list.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (_, index) {
                    return CheckboxListTile(
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Wrap(
                            runSpacing: 10,
                            spacing: 10,
                            children: [
                              Text(
                                list[index].clickerName,
                                overflow: TextOverflow.ellipsis,
                              ),
                              CustomChip(color: Colors.blueAccent, title: "다중선택",),
                              CustomChip(color: Colors.amberAccent, title: "익명",),
                            ],
                          ),
                        ),
                        subtitle: Text(list[index].timeStamp),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: list[index].checked,
                        onChanged: (bool value) {
                          setState(() {
                            list[index].checked = value;
                          });
                        },
                        checkColor: Colors.white,
                        secondary: IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClickerDetail(
                                    id: 1,
                                    title: "한국에서 튤립을 재배할 수 있을까?",
                                  ),
                                ));
                          },
                        ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class CustomChip extends StatelessWidget {

  final Color color;
  final String title;

  const CustomChip({
    Key key, this.color, this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
        // boxShadow: [customBoxShadow]
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }
}

class CategoryChips extends StatelessWidget {
  const CategoryChips({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TitleContainer(myTitle: "분류 필터"),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Wrap(
              spacing: 5.0,
              runSpacing: 3.0,
              children: <Widget>[
                FilterChipWidget(
                  chipName: ClickerType.complete.name,
                  isSelected: false,
                ),
                FilterChipWidget(
                  chipName: ClickerType.ing.name,
                  isSelected: false,
                ),
                FilterChipWidget(
                  chipName: ClickerType.canceled.name,
                  isSelected: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TitleContainer extends StatelessWidget {
  const TitleContainer({
    Key key,
    @required this.myTitle,
  }) : super(key: key);

  final String myTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          myTitle,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
