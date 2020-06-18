import 'package:flutter/material.dart';
import 'package:schuul/constants.dart';
import 'package:showcaseview/showcase.dart';

class CAppBarItem extends StatelessWidget {
  final IconData iconData;
  final VoidCallback press;
  final GlobalKey gKey;
  final String description;

  const CAppBarItem({
    Key key,
    this.iconData,
    this.press,
    this.gKey, this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Padding(
    //   padding: const EdgeInsets.only(right: 30),
    //   child: Material(
    //     child: InkWell(child: Icon(iconData), onTap: () => press),
    //   ),
    // );

    // return Showcase(
    //   key: gKey,
    //   title: 'Profile',
    //   description: 'Tap to see profile',
    //   showcaseBackgroundColor: Colors.blueAccent,
    //   textColor: Colors.white,
    //   shapeBorder: CircleBorder(),
    //   child: Material(
    //     child: InkWell(
    //       onTap: press,
    //       child: Padding(
    //         padding: EdgeInsets.all(10),
    //         child: Container(
    //           width: 30,
    //           height: 30,
    //           decoration: BoxDecoration(
    //             shape: BoxShape.circle,
    //           ),
    //           child: Icon(iconData),
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    return Showcase.withWidget(
      key: gKey,
      height: 50,
      width: 140,
      shapeBorder: CircleBorder(),
      container: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Container(
          //   width: 45,
          //   height: 45,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Colors.blue[200],
          //   ),
          //   child: Center(
          //     child: Text('S'),
          //   ),
          // ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: kPrimaryColor
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: description,
                    style: TextStyle(color: Colors.white),
                  ),
                ]),
              ),
            ),
          )
        ],
      ),
      child: Material(
        child: InkWell(
          onTap: press,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Icon(iconData),
            ),
          ),
        ),
      ),
    );
  }
}
