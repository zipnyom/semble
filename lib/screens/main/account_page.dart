import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schuul/screens/welcome/welcome_screen.dart';
import 'package:schuul/widgets/widget.dart';
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
                child: Text("로그아웃"),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                })
            // Form(
            //   key: _formKey,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
            //       TextFormField(
            //         controller: _emailController,
            //         decoration: InputDecoration(
            //             icon: Icon(Icons.account_circle), labelText: "Email"),
            //         validator: (String value) {
            //           if (value.isEmpty) {
            //             return "Please input correct Email.";
            //           }
            //           return null;
            //         },
            //       ),
            //       TextFormField(
            //         obscureText: true,
            //         controller: _passwordController,
            //         decoration: InputDecoration(
            //             icon: Icon(Icons.vpn_key), labelText: "Password"),
            //         validator: (String value) {
            //           if (value.isEmpty) {
            //             return "Please input correct password.";
            //           }
            //           return null;
            //         },
            //       ),
            //     ],
            //   ),
            // ),
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
