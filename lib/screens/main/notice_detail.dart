import 'package:flutter/material.dart';
import 'package:schuul/constants.dart';
import 'package:schuul/widgets/widget.dart';

class NoticeDetailPage extends StatelessWidget {
  final int id;
  const NoticeDetailPage({Key key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("공지사항", true, [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Material(
            child: InkWell(
              onTap: () => print("글쓰기"),
              child: Text("글쓰기",
                  style: TextStyle(color: kTextColor, fontSize: 16)),
            ),
          ),
        )
      ]),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            EntryItem(data[index]),
        itemCount: data.length,
      ),
    );
  }
}

class Entry {
  Entry([this.title, this.children = const <Entry>[]]);
  final String title;
  final List<Entry> children;
}

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
    return _buildTiles(entry);
  }
}
