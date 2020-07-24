import 'package:flutter/material.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/screens/main/new_notice.dart';
import 'package:schuul/src/screens/main/notice_detail.dart';
import 'package:schuul/src/widgets/widget.dart';

class NoticeListScreen extends StatelessWidget {
  const NoticeListScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar("공지사항", true, [
          FlatButton(
              child: Text("글쓰기"),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FormEmbeddedScreen())))
        ]),
        // body: ListView.builder(
        //   itemBuilder: (BuildContext context, int index) =>
        //       EntryItem(data[index]),
        //   itemCount: data.length,
        // ),
        body: ListView.builder(
          itemBuilder: (_, index) => NoticeListItem(title: noticeList[index]),
          itemCount: noticeList.length,
        ));
  }
}

class NoticeListItem extends StatelessWidget {
  final String title;
  const NoticeListItem({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NoticeDetailPage()));
        },
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 30, bottom: 16),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "2020-06-04",
                        style: TextStyle(color: kTextLightColor),
                      ),
                      Text(
                        title,
                        style: TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                Column(
                  children: [
                    Text(
                      "N",
                      style: TextStyle(color: Colors.redAccent),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Entry {
  Entry([this.title, this.children = const <Entry>[]]);
  final String title;
  final List<Entry> children;
}

final List<String> noticeList = <String>[
  sampleTitle1,
  sampleTitle2,
  sampleTitle3
];

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  Entry(
    sampleTitle1,
    <Entry>[
      Entry(
        '주저리주저리',
      ),
    ],
  ),
  Entry(
    sampleTitle2,
    <Entry>[
      Entry(
        '주저리주저리',
      ),
    ],
  ),
  Entry(
    sampleTitle3,
    <Entry>[
      Entry(
        '주저리주저리',
      ),
    ],
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [_buildTiles(entry)]);
  }
}
