import 'package:flutter/material.dart';

class TitleTextField extends StatelessWidget {
  const TitleTextField({
    Key key,
    @required TextEditingController controller,
    this.hintText,
    this.validateMessage,
  })  : _controller = controller,
        super(key: key);

  final hintText;
  final validateMessage;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      validator: (String value) {
        if (value.isEmpty) {
          return validateMessage;
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
