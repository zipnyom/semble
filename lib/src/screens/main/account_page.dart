import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/data/provider/mode_provider.dart';
import 'package:schuul/src/screens/welcome/welcome_screen.dart';
import 'package:schuul/src/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    final TextEditingController _emailController = TextEditingController();

    final TextEditingController _passwordController = TextEditingController();
    void _signOut(BuildContext context) async {
      await FirebaseAuth.instance.signOut();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) {
      //       return WelcomeScreen();
      //     },
      //   ),
      // );
      // Navigator.pop(context);
    }

    Mode pMode = Provider.of<Mode>(context, listen: false);
    return Scaffold(
      appBar: customAppBar("설정", false, []),
      body: Container(
        child: ListView(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: IconButton(
//                    alignment: Alignment.centerLeft,
                  iconSize: 90,
                  icon: Icon(Icons.account_circle),
                  onPressed: () {
                    print("hoho");
                  },
                ),
              ),
            ),
            FlatButton(
              onPressed: () {},
              child: Text(
                "프로필 사진 바꾸기",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            FlatButton(
              child: Text("도움말 다시보기"),
              onPressed: () => enableShowcase,
            ),
            FlatButton(
              child:
                  Text(pMode.mode == Modes.teacher ? "학생모드로 변경" : "선생님모드로 변경"),
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
                child: Text("로그아웃"),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                })
          ],
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
