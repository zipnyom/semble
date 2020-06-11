import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schuul/screens/welcome/welcome_screen.dart';

Widget appBarMain(BuildContext context, GlobalKey<ScaffoldState> key) {
  return AppBar(
      title: Text("Semble"),
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {
          print("leading...");
          // FirebaseAuth.instance.signOut();
          key.currentState.openDrawer();
        },
      ),
      elevation: 0.0,
      actions: <Widget>[
        // action button
        Material(
          child: InkWell(
            child: Image.asset("assets/images/user.png"),
            onTap: () {
              print(" user...");
            },
          ),
        ),
      ]
//    centerTitle: false,
      );
}

Widget myDrawer(BuildContext context) {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(
//                    alignment: Alignment.centerLeft,
                  iconSize: 90,
                  icon: Icon(Icons.account_circle),
                  onPressed: () {
                    print("hoho");
                  },
                ),
              ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("hong"), Text("1992.11.23")],
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('기능 문의'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('로그아웃'),
          onTap: () {
            _signOut(context);
          },
        ),
      ],
    ),
  );
}

void _signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return WelcomeScreen();
      },
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}

class YelllowBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration:
          BoxDecoration(color: Colors.yellowAccent, border: Border.all()),
    );
  }
}
