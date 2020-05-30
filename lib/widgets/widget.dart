import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(title: Text("Semble"), elevation: 0.0, actions: <Widget>[
    // action button
    IconButton(
      icon: Icon(Icons.notifications_none),
      onPressed: () {},
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
          child: ListView(
            children: [
              Text("tesxt1"),
              Row(
                children: [
                  IconButton(
//                    alignment: Alignment.centerLeft,
                    iconSize: 100,
                    icon: Icon(Icons.account_circle),
                    onPressed: () {
                      print("hoho");
                    },
                  ),
                 Column(
                   children: [
                     Text("hong"),
                     Text("1992.11.23")
                   ],
                 )
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Item 1'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Item 2'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(),
        ListTile(),
        ListTile(
          title: Text('Log out'),
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ],
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
