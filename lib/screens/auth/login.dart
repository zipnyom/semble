import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schuul/helper/login_background.dart';
import 'package:provider/provider.dart';
import 'package:schuul/data/join_or_login.dart';
import 'package:schuul/screens/auth/forget_password.dart';
import 'package:schuul/screens/auth/join_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../test/main_page.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CustomPaint(
                  size: size,
                  painter: LoginBackground(
                      isJoin: Provider.of<JoinOrLogin>(context).isJoin),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    _logoImage,
//              Image.asset("assets/loading.gif"),
                    Stack(
                      children: <Widget>[_inputForm(size), _authButton(size)],
                    ),
                    Container(
                      height: size.height * 0.06,
                    ),
                    _joinOrLoginButton,
                    Container(
                      height: size.height * 0.05,
                    )
                  ],
                ),
              ],
            ),
    );
  }

  Widget get _joinOrLoginButton => Consumer<JoinOrLogin>(
        builder: (context, joinOrLogin, child) => GestureDetector(
            onTap: () {
//              joinOrLogin.toggle();   mj 200517.1919
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => JoinPageSplit()));
            },
            child: Text(
              joinOrLogin.isJoin
                  ? "Already Have an Account? Sign in."
                  : "Don't Have an Account? Create One.",
              style: TextStyle(
                  color: joinOrLogin.isJoin ? Colors.red : Colors.blue),
            )),
      );

  void _login(BuildContext context) async {
    try {
      final AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      if (result.user != null)
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainPage(email: result.user.email)));
    } catch (e) {
      print(e);
      final snackbar = SnackBar(
        content: Text("Please try again later."),
      );
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }

  Future _register(BuildContext context) async {
    try {
      final AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      if (result.user != null) {
        final FirebaseUser user = result.user;
        Firestore.instance.collection('users').document().setData({
          "email": user.email, // 사용자 이메일
          "UUID": user.uid, // 사용자 기기 고유 아이디
          "Device": "tmp", // 사용자 기기 종류 (iOS, Android)
          "role": "tmp" // manager, visitor
        });

        setState(() {
          isLoading = false;
        });
        final snackBar = SnackBar(
          content: Text("Successfully Registered"),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        //      Navigator.push(context,
//          MaterialPageRoute(builder: (context) => MainPage(email: user.email)));
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      if (e is PlatformException) {
        final snackBar = SnackBar(
          content: Text(e.message),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
  }

  Widget get _logoImage => Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 40, left: 24, right: 24),
          child: FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
//                backgroundImage: NetworkImage("https://picsum.photos/200")),
                backgroundImage: AssetImage("assets/login.gif")),
          ),
        ),
      );

  Widget _authButton(Size size) => Positioned(
      left: size.width * 0.15,
      right: size.width * 0.15,
      bottom: 0,
      child: SizedBox(
        height: 50,
        child: Consumer<JoinOrLogin>(
          builder: (context, joinOrLogin, child) => RaisedButton(
            color: joinOrLogin.isJoin ? Colors.red : Colors.blue,
            child: Text(
              joinOrLogin.isJoin ? "Join" : "Login",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                setState(() {
                  isLoading = true;
                });
//                joinOrLogin.isJoin ? _register(context) : _login(context);
                _register(context);
              }
            },
          ),
        ),
      ));

  Widget _inputForm(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * .0505),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 32),
          child: Consumer<JoinOrLogin>(
            builder: (context, joinOrLogin, child) => Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_circle), labelText: "Email"),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Please input correct Email.";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key), labelText: "Password"),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Please input correct password.";
                      }
                      return null;
                    },
                  ),
                  Container(
                    height: joinOrLogin.isJoin ? 5 : 20,
                  ),
                  Consumer<JoinOrLogin>(
                      builder: (context, joinOrLogin, child) => Opacity(
                          opacity: joinOrLogin.isJoin ? 0 : 1,
                          child: GestureDetector(
                              onTap: joinOrLogin.isJoin
                                  ? null
                                  : () => goToForgetPW(context),
                              child: Text("Forgot Password")))),
                  Container(
                    height: joinOrLogin.isJoin ? 5 : 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  goToForgetPW(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgetPw()));
  }
}
