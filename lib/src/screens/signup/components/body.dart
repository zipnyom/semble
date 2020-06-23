import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:schuul/src/widgets/already_have_an_account_acheck.dart';
import 'package:schuul/src/widgets/rounded_button.dart';
import 'package:schuul/src/widgets/rounded_input_field.dart';
import 'package:schuul/src/widgets/rounded_password_field.dart';
import 'package:schuul/src/screens/login/login_screen.dart';
import 'package:schuul/src/screens/main/main_route.dart';
import 'package:schuul/src/screens/signup/components/background.dart';
import 'package:schuul/src/screens/signup/components/social_icon.dart';

import 'or_divider.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    void _signup(BuildContext context) async {
      setState(() {
        isLoading = true;
      });
      try {
        final AuthResult result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);

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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainRoute(email: user.email)));
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print(e);
        String message = "다시 시도해주세요";
        if (e is PlatformException) {
          switch (e.code) {
            case "ERROR_USER_NOT_FOUND":
              message = "등록되지 않은 유저입니다.";
              break;
            case "ERROR_INVALID_EMAIL":
              message = "유효한 이메일 형식을 입력해주세요.";
              break;
            default:
              message = e.message;
          }
        }
        final snackbar = SnackBar(
          content: Text(message),
        );
        Scaffold.of(context).showSnackBar(snackbar);
      }
    }

    return isLoading
        ? Container(
            color: Colors.white,
            child: Center(
              child: Image.asset('assets/loading.gif'),
            ),
          )
        : Background(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "회원가입",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.height * 0.03),
                  SvgPicture.asset(
                    "assets/icons/undraw_current_location_rypt.svg",
                    height: size.height * 0.35,
                  ),
                  // SvgPicture.asset(
                  //   "assets/icons/signup.svg",
                  //   height: size.height * 0.35,
                  // ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RoundedInputField(
                          hintText: "이메일",
                          emailController: _emailController,
                        ),
                        RoundedPasswordField(
                          passwordController: _passwordController,
                        ),
                        RoundedButton(
                          text: "가입하기",
                          press: () {
                            if (_formKey.currentState.validate()) {
                              _signup(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  AlreadyHaveAnAccountCheck(
                    login: false,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    },
                  ),
                  OrDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SocialIcon(
                        iconSrc: "assets/icons/facebook.svg",
                        press: () {},
                      ),
                      SocialIcon(
                        iconSrc: "assets/icons/naver.svg",
                        press: () {},
                      ),
                      SocialIcon(
                        iconSrc: "assets/icons/google-plus.svg",
                        press: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
