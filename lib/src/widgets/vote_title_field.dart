import 'package:flutter/material.dart';

class VoteTitleField extends StatelessWidget {
  const VoteTitleField({
    Key key,
    @required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      validator: (String value) {
        if (value.isEmpty) {
          return "투표 제목을 입력해주세요.";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "투표 제목",
      ),
    );
  }
}
