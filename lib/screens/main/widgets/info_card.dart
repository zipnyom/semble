
import 'package:flutter/material.dart';
import 'package:schuul/constants.dart';

class InfoCard extends StatelessWidget {
  final Color iconColor;
  final String title;
  final int count;
  final int total;
  final Function press;

  const InfoCard({
    Key key,
    this.iconColor,
    this.title,
    this.count,
    this.total,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: press,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal:10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 7),
                  blurRadius: 2,
                  color: Color(0xFF6DAED9).withOpacity(0.21),
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5,),
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
                            text: "$count",
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: iconColor,
                                    ),
                          ),
                          TextSpan(
                            text: "  /$total",
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
      ),
    );
  }
}