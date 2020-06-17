// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:schuul/experimental/src/full_page.dart';
import 'package:schuul/experimental/src/images.dart';
import 'package:schuul/widgets/widget.dart';
import 'package:zefyr/zefyr.dart';

enum _Options { darkTheme }

class FormEmbeddedScreen extends StatefulWidget {
  @override
  _FormEmbeddedScreenState createState() => _FormEmbeddedScreenState();
}

class _FormEmbeddedScreenState extends State<FormEmbeddedScreen> {
  final ZefyrController _controller = ZefyrController(NotusDocument());
  final FocusNode _focusNode = FocusNode();

  bool _darkTheme = false;

  @override
  Widget build(BuildContext context) {
    final form = ListView(
      children: <Widget>[
        buildEditor(),
      ],
    );

    final result = Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: customAppBar(
        "글쓰기",
        true,
        [
          FlatButton(
            child: Text("저장"),
            onPressed: () {},
          )
        ],
      ),
      body: ZefyrScaffold(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: form,
        ),
      ),
    );

    if (_darkTheme) {
      return Theme(data: ThemeData.dark(), child: result);
    }
    return Theme(data: ThemeData(primarySwatch: Colors.cyan), child: result);
  }

  Widget buildEditor() {
    return ZefyrField(
      height: 400.0,
      decoration: InputDecoration(labelText: '아래에 내용을 작성해주세요.'),
      controller: _controller,
      focusNode: _focusNode,
      autofocus: true,
      imageDelegate: CustomImageDelegate(),
      physics: ClampingScrollPhysics(),
    );
  }

  void handlePopupItemSelected(value) {
    if (!mounted) return;
    setState(() {
      if (value == _Options.darkTheme) {
        _darkTheme = !_darkTheme;
      }
    });
  }

  List<PopupMenuEntry<_Options>> buildPopupMenu(BuildContext context) {
    return [
      CheckedPopupMenuItem(
        value: _Options.darkTheme,
        child: Text("Dark theme"),
        checked: _darkTheme,
      ),
    ];
  }
}
