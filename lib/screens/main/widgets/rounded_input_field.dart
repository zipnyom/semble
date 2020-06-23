import 'package:flutter/material.dart';
import 'package:schuul/constants.dart';
import 'package:schuul/screens/main/widgets/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController emailController;
  RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.emailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: emailController,
        validator: (String value) {
          if (value.isEmpty) {
            return "유효한 이메일 주소를 입력해주세요.";
          }
          return null;
        },
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
