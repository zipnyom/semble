import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';
import 'package:schuul/src/widgets/already_have_an_account_acheck.dart';
import 'package:schuul/src/widgets/rounded_button.dart';
import 'package:schuul/src/widgets/input_field_normal.dart';
import 'package:schuul/src/widgets/input_field_obscure.dart';
import 'package:schuul/src/screens/login/login_screen.dart';
import 'package:schuul/src/screens/main/main_route.dart';
import 'package:schuul/src/screens/signup/components/background.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool _autoValidate = false;
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
          user.updateProfile(
              UserUpdateInfo()..displayName = _displayNameController.text);

          // Firestore.instance.collection('users').document().setData({
          //   "email": user.email, // 사용자 이메일
          //   "UUID": user.uid, // 사용자 기기 고유 아이디
          //   "Device": "tmp", // 사용자 기기 종류 (iOS, Android)
          //   "role": "tmp" // manager, visitor
          // });

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
                        "회원가입",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: size.height * 0.03),
                      SvgPicture.asset(
                        "assets/icons/undraw_current_location_rypt.svg",
                        height: size.height * 0.3,
                      ),
                      // SvgPicture.asset(
                      //   "assets/icons/signup.svg",
                      //   height: size.height * 0.35,
                      // ),
                      Form(
                        autovalidate: _autoValidate,
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            InputFieldNormal(
                                iconData: Icons.person,
                                hintText: "이메일",
                                emailController: _emailController,
                                validator: (String value) {
                                  if (value.isEmpty ||
                                      value.indexOf("@") == -1) {
                                    return "유효한 이메일 주소를 입력해주세요";
                                  }
                                  return null;
                                }),
                            InputFieldNormal(
                                hintText: "닉네임",
                                iconData: CustomIcon.tag,
                                emailController: _displayNameController,
                                validator: (String value) {
                                  if (value.length < 2 || value.length > 16) {
                                    return "2~15글자 이내의 닉네임을 입력해주세요";
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
                            InputFieldObscure(
                              hintText: "비밀번호 확인",
                              validator: (String value) {
                                if (value.isEmpty || value.length < 6) {
                                  return "최소 6자 이상의 비밀번호를 입력해주세요";
                                } else if (_passwordController.text !=
                                    _confirmPasswordController.text) {
                                  return "입력하신 비밀번호가 서로 일치하지 않습니다";
                                }
                                return null;
                              },
                              passwordController: _confirmPasswordController,
                            ),
                            RoundedButton(
                              text: "가입하기",
                              press: () {
                                if (_formKey.currentState.validate()) {
                                  _signup(context);
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
                      SizedBox(
                        height: 50,
                      )
                      // OrDivider(),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      //     SocialIcon(
                      //       iconSrc: "assets/icons/facebook.svg",
                      //       press: () {},
                      //     ),
                      //     SocialIcon(
                      //       iconSrc: "assets/icons/naver.svg",
                      //       press: () {},
                      //     ),
                      //     SocialIcon(
                      //       iconSrc: "assets/icons/google-plus.svg",
                      //       press: () {},
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ));
  }
}
