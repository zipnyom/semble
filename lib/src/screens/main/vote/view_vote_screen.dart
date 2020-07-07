import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/vote_type.dart';
import 'package:schuul/src/data/provider/select_provider.dart';
import 'package:schuul/src/obj/vote.dart';
import 'package:schuul/src/obj/vote_item.dart';
import 'package:schuul/src/services/database.dart';
import 'package:schuul/src/widgets/item_result_field.dart';
import 'package:schuul/src/widgets/item_select_field.dart';
import 'package:schuul/src/widgets/right_top_text_button.dart';
import 'package:schuul/src/widgets/widget.dart';

class ViewVoteScreen extends StatefulWidget {
  final Vote vote;
  final bool respond;
  const ViewVoteScreen({Key key, this.vote, this.respond}) : super(key: key);
  @override
  _ViewVoteScreenState createState() => _ViewVoteScreenState();
}

class _ViewVoteScreenState extends State<ViewVoteScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  VoteType selectedRadio = VoteType.text;
  Vote _vote;
  StreamProvider streamProvider;
  @override
  void initState() {
    _vote = widget.vote;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build...");
    void pick(List<VoteItem> items) {
      items.forEach((item) {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot freshSnap =
              await transaction.get(item.doc.reference);
          await transaction.update(freshSnap.reference, {
            'count': FieldValue.increment(1),
            'voters': FieldValue.arrayUnion([gEmail])
          });
        });
      });
    }

    void close() async {
      Navigator.pop(context);
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Select(),
        ),
        StreamProvider<QuerySnapshot>.value(
            value: _vote.documentSnapshot.reference
                .collection(db_col_choice)
                .orderBy("order")
                .snapshots()),
      ],
      child: Scaffold(
          appBar: customAppBarLeading(context, "투표", Icon(Icons.close),
              [RightTopTextButton(title: "닫기", press: close)]),
          body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SingleChildScrollView(
                child: Column(children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "질문 :  ${_vote.title}",
                          maxLines: null,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("나의 선택"),
                        SizedBox(
                          height: 10,
                        ),
                        Consumer2<QuerySnapshot, Select>(
                            builder: (context, snapshot, select, child) {
                          _vote.items.clear();
                          if (snapshot == null) return Text("loading");
                          int total = 0;
                          snapshot.documents.forEach((element) {
                            VoteItem item = VoteItem.fromJson(element.data);
                            item.doc = element;
                            item.controller.text = item.title;
                            _vote.items.add(item);
                            total += item.count;
                            if (item.voters.contains(gEmail)) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                select.addOrder(item.order);
                                select.already = true;
                              });
                            }
                          });
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: _vote.items.length,
                                  itemBuilder: (_, index) => ItemSelectField(
                                      typeList: _vote.options,
                                      controller: _vote.items[index].controller,
                                      item: _vote.items[index])),
                              Row(
                                children: [
                                  Expanded(
                                      child: RaisedButton(
                                          onPressed: select.already
                                              ? null
                                              : () {
                                                  pick(select.getItemList());
                                                },
                                          child: Text("결정"))),
                                ],
                              ),
                              Divider(),
                              SizedBox(
                                height: 20,
                              ),
                              select.already
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("투표 결과"),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [Text("총 투표 수 : $total")],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            physics: ClampingScrollPhysics(),
                                            itemCount: _vote.items.length,
                                            itemBuilder: (_, index) =>
                                                ItemResultField(
                                                  vote: _vote,
                                                  order: index,
                                                )),
                                        SizedBox(
                                          height: 30,
                                        )
                                      ],
                                    )
                                  : SizedBox.shrink()
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ]),
              ))),
    );
  }
}
