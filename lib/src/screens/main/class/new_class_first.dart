import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/data/enums/image_type.dart';
import 'package:schuul/src/data/enums/respond_type.dart';
import 'package:schuul/src/data/provider/class_option_provider.dart';
import 'package:schuul/src/obj/class.dart';
import 'package:schuul/src/screens/main/class/new_class_second.dart';
import 'package:schuul/src/widgets/right_top_text_button.dart';
import 'package:schuul/src/widgets/widget.dart';

class NewClassScreen1 extends StatefulWidget {
  const NewClassScreen1({
    Key key,
  }) : super(key: key);
  @override
  _NewClassScreen1State createState() => _NewClassScreen1State();
}

class _NewClassScreen1State extends State<NewClassScreen1>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ClassType selectedRadio = ClassType.regular;
  Class _class;
  ImageType imageType = ImageType.basic;

  @override
  void initState() {
    _class = Class();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onExit(BuildContext context) async {
      RespondType res =
          await customShowDialog(context, "닫기", "저장히지 않고 나가시겠습니까?");
      if (res == RespondType.yes) Navigator.of(context).pop();
    }

    return Scaffold(
        appBar: customAppBarLeadingWithDialog(
            context, "기본 정보 입력", Icon(Icons.close), onExit, [
          RightTopTextButton(
              title: "완료",
              press: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                        value: ClassDateInfo(), child: NewClassScreen2()),
                  )))
        ]),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        controller: _class.titleController,
                        minLines: 2,
                        maxLines: 2,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "수업명을 입력해주세요";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "수업명",
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _class.descriptionController,
                        minLines: 3,
                        maxLines: 10,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "수업 소개를 입력해주세요";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "간단한 수업 소개",
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text("대표 이미지 (썸네일)"),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _radioButton(ImageType.basic),
                          SizedBox(
                            width: 5,
                          ),
                          _radioButton(ImageType.profile),
                          SizedBox(
                            width: 5,
                          ),
                          _radioButton(ImageType.upload),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Material(
                        child: InkWell(
                          onTap: () {
                            print("test");
                          },
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage:
                                AssetImage("assets/images/login_bottom.png"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            )));
  }

  Widget _radioButton(ImageType type) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        setState(() {
          imageType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: size.width * .25,
        decoration: BoxDecoration(
          color: imageType == type ? Colors.purple[100] : Colors.transparent,
          border: Border.all(width: 1),
        ),
        child: Center(child: Text(type.name)),
      ),
    );
  }
}
