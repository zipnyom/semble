import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schuul/constants.dart';

class AttendanceCard extends StatelessWidget {
  final String title;
  final Icon icon;
  final int effectedNum;
  final int totalNum;
  final Color iconColor;
  final Function press;
  const AttendanceCard({
    Key key,
    this.title,
    this.effectedNum,
    this.icon,
    this.iconColor,
    this.press,
    this.totalNum,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: press,
          child: Container(
            width: constraints.maxWidth / 2 - 10,
            // Here constraints.maxWidth provide us the available width for the widget
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 2,
                    color: Color(0xFF6DAED9).withOpacity(0.11),
                  ),
                ]),
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
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
                      Expanded(
                        child: Container(),
                      ),
                      Icon(
                        Icons.menu,
                        size: 12,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: kTextColor),
                          children: [
                            TextSpan(
                              text: "$effectedNum",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: iconColor,
                                  ),
                            ),
                            TextSpan(
                              text: "  /$totalNum",
                              style: TextStyle(
                                fontSize: 12,
                                height: 2,
                              ),
                            ),
                            TextSpan(
                              text: " 명",
                              style: TextStyle(
                                  fontSize: 13,
                                  height: 2,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
