import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/respond_type.dart';
import 'package:schuul/src/obj/class.dart';
import 'package:schuul/src/services/database.dart';
import 'package:schuul/src/widgets/right_top_text_button.dart';
import 'package:schuul/src/widgets/title_text_field.dart';
import 'package:schuul/src/widgets/widget.dart';

class NewClassScreen extends StatefulWidget {
  const NewClassScreen({
    Key key,
  }) : super(key: key);
  @override
  _NewClassScreenState createState() => _NewClassScreenState();
}

class _NewClassScreenState extends State<NewClassScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ClassType selectedRadio = ClassType.regular;
  Class _class;

  setSelectedRadio(ClassType val) {
    setState(() {
      selectedRadio = val;
    });
    _class.type = val;
    print("setSelectedRadio => ${_class.type}");
  }

  @override
  void initState() {
    _class = Class();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onSubmit() async {
      if (_formKey.currentState.validate()) {
        RespondType res =
            await customShowDialog(context, "바로 실행", "클리커를 바로 실행하시겠습니까?");
        if (res == RespondType.yes) {}

        _class.title = _class.titleController.text.trim();
        _class.created = DateTime.now();

        DocumentReference ref =
            await databaseService.addItem(db_col_class, _class.toJson());
        Navigator.pop(context);
      }
    }

    void onExit(BuildContext context) async {
      RespondType res =
          await customShowDialog(context, "닫기", "저장히지 않고 나가시겠습니까?");
      if (res == RespondType.yes) Navigator.of(context).pop();
    }

    return Scaffold(
        appBar: customAppBarLeadingWithDialog(
            context,
            "새로운 수업",
            Icon(Icons.close),
            onExit,
            [RightTopTextButton(title: "완료", press: onSubmit)]),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TitleTextField(
                          validateMessage: "수업명을 입력해주세요",
                          hintText: "수업명",
                          controller: _class.titleController),
                      ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: ClassType.regular,
                            groupValue: selectedRadio,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              setSelectedRadio(val);
                            },
                          ),
                          Text("정기 수업"),
                          SizedBox(
                            width: 10,
                          ),
                          Radio(
                            value: ClassType.irregular,
                            groupValue: selectedRadio,
                            activeColor: Colors.blue,
                            onChanged: (val) {
                              setSelectedRadio(val);
                            },
                          ),
                          Text("비정기 수업"),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            )));
  }
}
