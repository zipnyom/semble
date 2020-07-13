import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/data/enums/image_type.dart';
import 'package:schuul/src/data/enums/respond_type.dart';
import 'package:schuul/src/data/provider/class_option_provider.dart';
import 'package:schuul/src/obj/class.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/screens/main/class/new_class_second.dart';
import 'package:schuul/src/widgets/right_top_text_button.dart';
import 'package:schuul/src/widgets/widget.dart';
import 'package:schuul/src/constants.dart';

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
  // MyClass _class;
  ImageType imageType = ImageType.basic;
  FileImage fileImage;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    ClassProvider classProvider = Provider.of<ClassProvider>(context);
    pickImage(int source) async {
      PickedFile pickedFile;
      if (source == 1) // camera
        pickedFile = await picker.getImage(source: ImageSource.camera);
      else // gallary
        pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      setState(() {
        fileImage = FileImage(File(pickedFile.path));
      });

      classProvider.myClass.imageLocalPath = pickedFile.path;
    }

    void onExit(BuildContext context) async {
      RespondType res =
          await customShowDialog(context, "닫기", "저장히지 않고 나가시겠습니까?");
      if (res == RespondType.yes) Navigator.of(context).pop();
    }

    return Scaffold(
        appBar: customAppBarLeadingWithDialog(
            context, "기본 정보 입력", Icon(Icons.close), onExit, [
          RightTopTextButton(
              title: "다음",
              press: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewClassScreen2(),
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
                        controller: classProvider.myClass.titleController,
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
                        controller: classProvider.myClass.descriptionController,
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
                        height: 25,
                      ),
                      Row(
                        children: [
                          Text("대표 이미지 (썸네일)"),
                        ],
                      ),
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
                      imageType == ImageType.upload
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      CustomIcon.camera,
                                      size: 35,
                                    ),
                                    onPressed: () {
                                      pickImage(1);
                                    },
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      CustomIcon.photo,
                                      size: 35,
                                    ),
                                    onPressed: () {
                                      pickImage(2);
                                    },
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      Text("이미지 미리보기"),
                      SizedBox(
                        height: 10,
                      ),
                      imageType == ImageType.basic
                          ? CircleAvatar(
                              radius: 100,
                              backgroundImage: AssetImage(defaultImagePath),
                            )
                          : imageType == ImageType.profile
                              ? CircleAvatar(
                                  radius: 100,
                                  child: Text("등록된 프로필 사진이 없습니다."),
                                )
                              : CircleAvatar(
                                  radius: 100,
                                  backgroundImage: fileImage,
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
