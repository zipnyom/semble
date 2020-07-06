import 'package:flutter/material.dart';
import 'package:schuul/src/constants.dart';

class ItemAddButton extends StatelessWidget {
  final VoidCallback press;

  final String title;
  const ItemAddButton({Key key, this.press, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: press,
        child: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: kTextLightColor,
              ),
            ),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      title,
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
