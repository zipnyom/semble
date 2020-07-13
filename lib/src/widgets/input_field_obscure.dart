import 'package:flutter/material.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/widgets/text_field_container.dart';

class InputFieldObscure extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final String hintText;
  final Function(String) validator;
  InputFieldObscure(
      {Key key,
      this.passwordController,
      this.hintText,
      this.validator,
      this.formKey})
      : super(key: key);

  @override
  _InputFieldObscureState createState() => _InputFieldObscureState();
}

class _InputFieldObscureState extends State<InputFieldObscure> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: isObscure,
        controller: widget.passwordController,
        validator: widget.validator,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: widget.hintText,
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
