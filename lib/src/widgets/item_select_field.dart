import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/constants.dart';
import 'package:schuul/src/data/enums/vote_type.dart';
import 'package:schuul/src/data/provider/select_provider.dart';
import 'package:schuul/src/obj/vote_item.dart';

class ItemSelectField extends StatefulWidget {
  const ItemSelectField({
    Key key,
    this.item,
    this.controller,
    this.typeList,
  }) : super(key: key);

  final List<VoteType> typeList;
  final VoteItem item;
  final TextEditingController controller;

  @override
  _ItemSelectFieldState createState() => _ItemSelectFieldState();
}

class _ItemSelectFieldState extends State<ItemSelectField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<Select>(builder: (context, pSelect, child) {
      bool select = pSelect.containOrder(widget.item.order);
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Material(
          child: InkWell(
            onTap: () {
              if (pSelect.containOrder(widget.item.order)) {
                pSelect.removeOrder(widget.item.order);
                pSelect.removeItem(widget.item);
              } else {
                if (widget.typeList.contains(VoteType.multiple) == false) {
                  pSelect.clear();
                }
                pSelect.addOrder(widget.item.order);
                pSelect.addItem(widget.item);
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
