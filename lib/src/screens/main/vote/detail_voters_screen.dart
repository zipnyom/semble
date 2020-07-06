import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schuul/src/widgets/right_top_text_button.dart';
import 'package:schuul/src/widgets/widget.dart';

class DetailVoterScreen extends StatefulWidget {
  DetailVoterScreen({Key key, this.doc}) : super(key: key);
  final DocumentSnapshot doc;
  @override
  _DetailVoterScreenState createState() => _DetailVoterScreenState();
}

class _DetailVoterScreenState extends State<DetailVoterScreen> {
  DocumentSnapshot _doc;
  @override
  void initState() {
    _doc = widget.doc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBarLeading(context, "투표자 목록", Icon(Icons.close),
            [RightTopTextButton(title: "닫기", press: () {})]),
        body: Container(
          child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: _doc.data["voters"].length,
              itemBuilder: (context, index) => ListTile(
                    title: Text(_doc.data["voters"][index]),
                  )),
        ));
  }
}
