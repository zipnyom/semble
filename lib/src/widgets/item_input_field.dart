import 'package:flutter/material.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/presentation/custom_icon_icons.dart';

class ItemInputField extends StatefulWidget {
  const ItemInputField({
    Key key,
    @required TextEditingController controller,
  })  : controller = controller,
        super(key: key);

  final TextEditingController controller;

  @override
  _ItemInputFieldState createState() => _ItemInputFieldState();
}

class _ItemInputFieldState extends State<ItemInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: kTextLightColor,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "항목 입력",
                    // border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Material(
              child: InkWell(
                onTap: () {
                  setState(() {
                    widget.controller.clear();
                  });
                },
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      CustomIcon.cancel_circle,
                      color: kTextLightColor,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
