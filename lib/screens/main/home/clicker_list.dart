import 'package:flutter/material.dart';
import 'package:schuul/data/enums/action_type.dart';
import 'package:schuul/data/enums/clicker_type.dart';
import 'package:schuul/presentation/custom_icon_icons.dart';
import 'package:schuul/screens/main/home/clicker_detail.dart';
import 'package:schuul/screens/main/home/model/clicker.dart';
import 'package:schuul/screens/main/home/new_clicker.dart';
import 'package:schuul/screens/main/widgets/custom_popup_menu.dart';
import 'package:schuul/screens/main/widgets/filterchip.dart';
import 'package:schuul/widgets/widget.dart';

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
      list.add(new Clicker("클리커" + num, "2020-06-04"));
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
              ActionType.bulkAttend,
              ActionType.bulkTardy,
              ActionType.bulkCut
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
              ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    return CheckboxListTile(
                        title: Text(list[index].clickerName),
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
