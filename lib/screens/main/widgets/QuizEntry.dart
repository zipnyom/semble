import 'package:flutter/material.dart';
import 'package:schuul/screens/main/notice_list.dart';
import 'package:schuul/screens/main/widgets/quiz_item.dart';

class QuizEntry extends StatelessWidget {
  final Entry entry;
  const QuizEntry(this.entry);

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return QuizItem();
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
