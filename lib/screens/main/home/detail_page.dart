import 'package:flutter/material.dart';
import 'package:schuul/widgets/widget.dart';

import 'model/class_model.dart';

class DetailPage extends StatelessWidget {
  final ClassModel classModel;

  const DetailPage(this.classModel, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBarMain(context),
      body: Container(
          child: Center(child:Text("I am Detail Page"),)
      ),
    );
  }
}
