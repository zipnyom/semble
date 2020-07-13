import 'package:flutter/material.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/widgets/text_field_container.dart';

class InputFieldNormal extends StatefulWidget {
  final String hintText;
  final IconData iconData;
  final TextEditingController emailController;
  final Function(String) validator;
  final GlobalKey<FormState> formKey;
  InputFieldNormal({
    Key key,
    this.hintText,
    this.iconData = Icons.person,
    this.emailController,
    this.validator,
    this.formKey,
  }) : super(key: key);

  @override
  _InputFieldNormalState createState() => _InputFieldNormalState();
}

class _InputFieldNormalState extends State<InputFieldNormal> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: widget.emailController,
        validator: widget.validator,
        decoration: InputDecoration(
          icon: Icon(
            widget.iconData,
            color: kPrimaryColor,
          ),
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
