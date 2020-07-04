import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/provider/select_provider.dart';

class ItemSelectField extends StatefulWidget {
  const ItemSelectField({
    Key key,
    @required TextEditingController controller,
    this.order,
    this.press,
  })  : controller = controller,
        super(key: key);

  final Function(int) press;
  final int order;
  final TextEditingController controller;

  @override
  _ItemSelectFieldState createState() => _ItemSelectFieldState();
}

class _ItemSelectFieldState extends State<ItemSelectField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<Select>(builder: (context, pSelect, child) {
      bool select = pSelect.select == widget.order;
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Material(
          child: InkWell(
            onTap: () {
              if (pSelect.select == widget.order) {
                pSelect.select = -1;
              } else {
                pSelect.select = widget.order;
              }
            },
            child: Container(
              width: size.width * .9,
              decoration: BoxDecoration(
                color: select
                    ? Colors.blueAccent.withOpacity(.5)
                    : Colors.transparent,
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
                          enabled: false,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  select
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.check,
                          ),
                        )
                      : SizedBox.shrink()
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
