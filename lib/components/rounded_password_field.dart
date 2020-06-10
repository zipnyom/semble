import 'package:flutter/material.dart';
import 'package:schuul/components/text_field_container.dart';

import '../constants.dart';

class RoundedPasswordField extends StatefulWidget {
  final TextEditingController passwordController;
  RoundedPasswordField({Key key, this.passwordController}) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: isObscure,
        controller: widget.passwordController,
        validator: (String value) {
          if (value.isEmpty || value.length < 6) {
            return "최소 6자 이상의 비밀번호를 입력해주세요";
          }
          return null;
        },
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "비밀번호",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });
            },
            icon: Icon(
              Icons.visibility,
              color: kPrimaryColor,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
