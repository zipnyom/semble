import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/action_type.dart';
import 'package:schuul/src/data/enums/vote_type.dart';
import 'package:schuul/src/data/provider/mode_provider.dart';
import 'package:schuul/src/obj/action_model.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/obj/vote.dart';
import 'package:schuul/src/screens/main/vote/edit_vote_screen.dart';
import 'package:schuul/src/screens/main/vote/new_vote_screen.dart';
import 'package:schuul/src/screens/main/vote/view_vote_screen.dart';
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
  List<String> filterList = [
    "preventEmptyString",
    VoteType.yet.code,
    VoteType.running.code,
    VoteType.done.code
  ];

  Future<bool> didRespond(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList("clicker") ?? [];
    if (list.contains(id)) return true;
    // await prefs.setStringList("clicker", list..add(id));
    return false;
  }

  bulkDeletePress() async {
    List<Vote> deleteList = List<Vote>();
    for (Vote vote in voteList) {
      deleteList.add(vote);
    }
    for (Vote vote in deleteList) {
      if (vote.checked) {
        QuerySnapshot snapshot = await vote.documentSnapshot.reference
            .collection(db_col_items)
            .getDocuments();
        snapshot.documents.forEach((element) async {
          await element.reference.delete();
        });
        await vote.documentSnapshot.reference.delete();
      }
    }
  }

  packVoteList() async {
    print("packVoteList .. $filterList");
    List<Vote> bufferList = List<Vote>();
    QuerySnapshot snapshot = await Firestore.instance
        .collection(db_col_vote)
        .where("status", whereIn: filterList)
        .getDocuments();
    snapshot.documents.forEach((element) {
      bufferList.add(Vote.fromJson(element.data)..documentSnapshot = element);
    });
    if (this.mounted) {
      setState(() {
        voteList = bufferList;
      });
    }
  }

  onFilterClicked(VoteType v) {
    setState(() {
      if (filterList.contains(v.code)) {
        filterList.remove(v.code);
      } else {
        filterList.add(v.code);
      }
    });
    packVoteList();
  }

  @override
  void initState() {
    packVoteList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Mode pMode = Provider.of<Mode>(context);
    return Scaffold(
      appBar: customAppBarLeading(context, "투표", Icon(Icons.close), [
        pMode.mode == Modes.teacher
            ? IconButton(
                iconSize: 20,
                icon: Icon(CustomIcon.pencil),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewVoteScreen(),
                      ));
                  packVoteList();
                },
              )
            : SizedBox.shrink(),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // TitleContainer(myTitle: "분류 필터"),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Wrap(
                        spacing: 20.0,
                        runSpacing: 3.0,
                        children: <Widget>[
                          FilterChipWidget(
                              voteType: VoteType.yet,
                              filterList: filterList,
                              press: onFilterClicked),
                          FilterChipWidget(
                            voteType: VoteType.running,
                            filterList: filterList,
                            press: onFilterClicked,
                          ),
                          FilterChipWidget(
                            voteType: VoteType.done,
                            filterList: filterList,
                            press: onFilterClicked,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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

                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Consumer<Mode>(
                                            builder: (context, pMode, child) {
                                          if (voteList[index].status ==
                                              VoteType.running)
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
                            packVoteList();
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
