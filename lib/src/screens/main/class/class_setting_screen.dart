import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/data/enums/respond_type.dart';
import 'package:schuul/src/data/provider/class_provider.dart';
import 'package:schuul/src/widgets/widget.dart';

class ClassSettingScreen extends StatefulWidget {
  @override
  _ClassSettingScreenState createState() => _ClassSettingScreenState();
}

class _ClassSettingScreenState extends State<ClassSettingScreen> {
  @override
  Widget build(BuildContext context) {
    ClassProvider classProvider = Provider.of<ClassProvider>(context);

    return Scaffold(
      appBar: customAppBarLeading(context, "수업 설정", Icon(Icons.close), []),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Divider(),
              ListTile(
                  title: RaisedButton(
                color: Colors.redAccent[100],
                child: Text("수업 삭제"),
                onPressed: () async {
                  bool _autoValidate = false;
                  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
                  RespondType respond = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("수업 삭제"),
                          content: Container(
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("수업명 : ${classProvider.myClass.title}"),
                                Expanded(
                                  child: Form(
                                    key: _formKey,
                                    autovalidate: _autoValidate,
                                    child: TextFormField(
                                      maxLines: 2,
                                      validator: (value) {
                                        if (value !=
                                            classProvider.myClass.title) {
                                          return "삭제를 위해 수업명과 동일하게 입력해주세요.";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "수업명을 동일하게 입력해서 확인",
                                        // border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          actions: [
                            RaisedButton(
                              color: Colors.redAccent[100],
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  Navigator.of(context).pop(RespondType.delete);
                                }
                              },
                              child: Text(RespondType.delete.name),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop(RespondType.cancel);
                              },
                              child: Text(RespondType.cancel.name),
                            ),
                          ],
                        );
                      });
                  if (respond == null) return;
                  if (respond == RespondType.delete) {
                    classProvider.myClass.documentSnapshot.reference.delete();
                    okDialog(context, "수업 삭제 완료", "수업이 정상적으로 삭제되었습니다");
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                },
              )),
            ],
          )),
    );
  }
}
