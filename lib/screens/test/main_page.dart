import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:schuul/data/join_or_login.dart';
import 'package:schuul/widgets/widget.dart';

class MainPage extends StatelessWidget {
  MainPage({this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: appBarMain(context),
//        drawer: myDrawer(context),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 200),
              child: AnimationLimiter(
                child: ListView.builder(
                  itemCount: 100,
                  itemBuilder: (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 675),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Card(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                  Colors.accents[index % Colors.accents.length]),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Positioned(
              left: 10,
              right: 10,
              top: 20,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 6,
                child: Padding(
                  padding:
                      EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        email,
                        style: TextStyle(color: Colors.black),
                      ),
                      Container(
                        height: 20,
                      ),
                      Text(
                        email,
                        style: TextStyle(color: Colors.black),
                      ),
                      Container(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
