import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/action_type.dart';
import 'package:schuul/src/data/enums/clicker_type.dart';
import 'package:schuul/src/data/provider/mode_provider.dart';
import 'package:schuul/src/obj/action_model.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/obj/vote.dart';
import 'package:schuul/src/screens/main/edit_vote_screen.dart';
import 'package:schuul/src/screens/main/new_vote_screen.dart';
import 'package:schuul/src/screens/main/view_vote_screen.dart';
import 'package:schuul/src/widgets/custom_popup_menu.dart';
import 'package:schuul/src/widgets/filterchip.dart';
import 'package:schuul/src/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoteListScreen extends StatefulWidget {
  VoteListScreen({Key key}) : super(key: key);
  @override
  _VoteListScreenState createState() => _VoteListScreenState();
}

class _VoteListScreenState extends State<VoteListScreen> {
  List<Vote> voteList = [];

  Future<bool> didRespond(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList("clicker") ?? [];
    if (list.contains(id)) return true;
    // await prefs.setStringList("clicker", list..add(id));
    return false;
  }

  bulkDeletePress() {
    for (Vote clicker in voteList) {
      if (clicker.checked) {
        clicker.documentSnapshot.reference.delete();
      }
    }
  }

  packVoteList() {
    List<Vote> bufferList = List<Vote>();
    Firestore.instance
        .collection(db_col_vote)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      bufferList.clear();
      snapshot.documents.forEach((element) {
        bufferList.add(Vote.fromJson(element.data)..documentSnapshot = element);
      });
      if (this.mounted) {
        setState(() {
          voteList = bufferList;
        });
      }
    });
  }

  @override
  void initState() {
    packVoteList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarLeading(context, "투표", Icon(Icons.close), [
        IconButton(
          iconSize: 20,
          icon: Icon(CustomIcon.pencil),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewVoteScreen(),
                ));
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 15),
          child: CustomPopupMenuButton(
            list: [ActionModel(ActionType.bulkDelete, bulkDeletePress)],
          ),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // CustomChip(),
              // CategoryChips(),
              SizedBox(
                height: 10,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: voteList.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (_, index) {
                    return CheckboxListTile(
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                voteList[index].title,
                                style: TextStyle(fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Wrap(
                                runSpacing: 10,
                                spacing: 10,
                                children: List<CustomChip>.generate(
                                    voteList[index].options.length,
                                    (index2) => CustomChip(
                                          color: Colors.blueAccent,
                                          title: voteList[index]
                                              .options[index2]
                                              .name,
                                        )),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Text(DateFormat("yyyy-MM-dd")
                            .format(voteList[index].created)),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: voteList[index].checked,
                        onChanged: (bool value) {
                          setState(() {
                            voteList[index].checked = value;
                          });
                        },
                        checkColor: Colors.white,
                        secondary: IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () async {
                            bool respond = await didRespond(
                                voteList[index].documentSnapshot.documentID);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Consumer<Mode>(
                                            builder: (context, pMode, child) {
                                          if (voteList[index].isRunning)
                                            return ViewVoteScreen(
                                              vote: voteList[index],
                                              respond: respond,
                                            );
                                          if (pMode.mode == Modes.teacher)
                                            return EditVoteScreen(
                                              vote: voteList[index],
                                              respond: respond,
                                            );
                                          else
                                            return ViewVoteScreen(
                                              vote: voteList[index],
                                              respond: respond,
                                            );
                                        })));
                          },
                        ));
                  }),
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
    Key key,
    this.color,
    this.title,
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
