
import 'package:flutter/material.dart';

import 'custom_box_shadow.dart';

class SubTabItem extends StatelessWidget {
  final Color iconColor;
  final String title;

  const SubTabItem({
    Key key,
    this.title,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [customBoxShadow],
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // wrapped within an expanded widget to allow for small density device
            Container(
              alignment: Alignment.center,
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.ac_unit,
                color: iconColor,
                size: 12,
              ),
            ),
            SizedBox(width: 5),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
