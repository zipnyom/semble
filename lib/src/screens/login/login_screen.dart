import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:schuul/src/screens/login/components/background.dart';
import 'package:schuul/src/widgets/already_have_an_account_acheck.dart';
import 'package:schuul/src/widgets/auth_stream.dart';
import 'package:schuul/src/widgets/rounded_button.dart';
import 'package:schuul/src/widgets/input_field_normal.dart';
import 'package:schuul/src/widgets/input_field_obscure.dart';
import 'package:schuul/src/screens/signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool _autoValidate = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      final AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      if (result.user != null) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                // builder: (context) => MainRoute(email: result.user.email)));
                builder: (context) => AuthStream()));
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: isLoading
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
                        "로그인",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: size.height * 0.03),
                      SvgPicture.asset(
                        "assets/icons/undraw_cloud_sync_2aph.svg",
                        height: size.height * 0.3,
                      ),
                      // SvgPicture.asset(
                      //   "assets/icons/login.svg",
                      //   height: size.height * 0.35,
                      // ),

                      SizedBox(height: size.height * 0.03),

                      Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            InputFieldNormal(
                                hintText: "이메일",
                                emailController: _emailController,
                                validator: (String value) {
                                  if (value.isEmpty ||
                                      value.indexOf("@") == -1) {
                                    return "유효한 이메일 주소를 입력해주세요";
                                  }
                                  return null;
                                }),
                            InputFieldObscure(
                              hintText: "비밀번호",
                              validator: (String value) {
                                if (value.isEmpty || value.length < 6) {
                                  return "최소 6자 이상의 비밀번호를 입력해주세요";
                                }
                                return null;
                              },
                              passwordController: _passwordController,
                            ),
                            RoundedButton(
                              text: "로그인",
                              press: () {
                                if (_formKey.currentState.validate()) {
                                  _login(context);
                                } else {
                                  setState(() {
                                    _autoValidate = true;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: size.height * 0.03),
                      AlreadyHaveAnAccountCheck(
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SignUpScreen();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ));
  }
}
