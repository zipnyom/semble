import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/provider/mode_provider.dart';
import 'package:schuul/src/data/provider/user_provider.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/widgets/custom_box_shadow.dart';
import 'package:schuul/src/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File imageFile;
  final picker = ImagePicker();
  PickedFile pickedFile;
  @override
  Widget build(BuildContext context) {
    Mode pMode = Provider.of<Mode>(context, listen: false);

    Widget _radiusButton(BuildContext context, bool isCamera) {
      return Material(
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop(isCamera ? true : false);
          },
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Icon(
              isCamera ? CustomIcon.camera : CustomIcon.photo,
              size: 50,
            ),
          ),
        ),
      );
    }

    showPickModal() async {
      bool isCamera = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              content: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _radiusButton(context, true),
                    _radiusButton(context, false)
                  ],
                ),
              ),
            );
          });

      if (isCamera) // camera
        pickedFile = await picker.getImage(source: ImageSource.camera);
      else // gallary
        pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      setState(() {
        imageFile = File(pickedFile.path);
      });

      UserProvider pUser = Provider.of<UserProvider>(context);
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child("profile/${pUser.user.uid}");
      StorageTaskSnapshot storageTaskSnapshot =
          await storageReference.putFile(imageFile).onComplete;
      if (storageTaskSnapshot.error == null) {
        final String downloadUrl =
            await storageTaskSnapshot.ref.getDownloadURL();
        await pUser.user
            .updateProfile(UserUpdateInfo()..photoUrl = downloadUrl);
        WriteBatch batch = Firestore.instance.batch();
        QuerySnapshot snapshot = await Firestore.instance
            .collection(db_col_class)
            .where("creator", isEqualTo: pUser.user.uid)
            .getDocuments();

        snapshot.documents.forEach((document) {
          batch
              .updateData(document.reference, {"creatorImageUrl": downloadUrl});
        });
        batch.commit();
      }
    }

    Widget _localImage() {
      return imageFile == null
          ? ExtendedImage.asset("assets/images/login_bottom.png",
              width: 90,
              height: 90,
              fit: BoxFit.fill,
              shape: BoxShape.circle,
              loadStateChanged: myloadStateChanged)
          : ExtendedImage.file(imageFile,
              width: 90,
              height: 90,
              fit: BoxFit.fill,
              shape: BoxShape.circle,
              loadStateChanged: myloadStateChanged);
    }

    return Scaffold(
      appBar: customAppBar("설정", false, []),
      body: Container(
        child: Consumer<UserProvider>(
          builder: (context, pUser, child) => Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Stack(
                    children: [
                      pUser.user.photoUrl == null
                          ? _localImage()
                          : ExtendedImage.network(pUser.user.photoUrl,
                              width: 70,
                              height: 70,
                              fit: BoxFit.fill,
                              cache: true,
                              shape: BoxShape.circle,
                              loadStateChanged: myloadStateChanged),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    customBoxShadow,
                                    customBoxShadowReverse
                                  ]),
                              child: Material(
                                  child: InkWell(
                                      onTap: showPickModal,
                                      child: Icon(Icons.edit)))))
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pUser.user.displayName,
                          style: kListTitleStyle,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          pUser.user.email,
                          style: kListSubTitleStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  FlatButton(
                    child: Text("도움말 다시보기"),
                    onPressed: () => enableShowcase,
                  ),
                  FlatButton(
                    child: Text(
                        pMode.mode == Modes.teacher ? "학생모드로 변경" : "선생님모드로 변경"),
                    onPressed: () {
                      changeMode(context);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        duration: Duration(milliseconds: 1000),
                        content: Text(pMode.mode == Modes.student
                            ? "학생모드로 변경되었습니다"
                            : "선생님모드로 변경되었습니다"),
                      ));
                    },
                  ),
                  FlatButton(
                      child: Text("���그아웃"),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void enableShowcase() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('showcase', false);
}

void changeMode(BuildContext context) {
  Mode pMode = Provider.of<Mode>(context, listen: false);
  pMode.toggle();
}
