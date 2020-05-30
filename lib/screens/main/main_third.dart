import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MainThird extends StatefulWidget {
  @override
  _MainThirdState createState() => _MainThirdState();
}

class _MainThirdState extends State<MainThird> {
  static var _streamRanging;

  List<Beacon> beacons = List<Beacon>();

  @override
  void initState() {
    super.initState();
    initBeacon();
  }

  void initBeacon() async {
//    if (_streamRanging != null) return null;
    try {
      // if you want to manage manual checking about the required permissions
      await flutterBeacon.initializeScanning;
      // or if you want to include automatic checking permission
      await flutterBeacon.initializeAndCheckScanning;
    } on PlatformException catch (e) {
      // library failed to initialize, check code and message
      print(e);
      return;
    }
    final regions = <Region>[];

    if (Platform.isIOS) {
      // iOS platform, at least set identifier and proximityUUID for region scanning
      regions.add(Region(
          identifier: 'Apple Airlocate',
          proximityUUID: 'FFFFFFFF-1234-AAAA-1A2B-A1B2C3D4E5F6'));
    } else {
      // android platform, it can ranging out of beacon that filter all of Proximity UUID
      regions.add(Region(
          identifier: 'com.beacon',
          proximityUUID: 'FFFFFFFF-1234-AAAA-1A2B-A1B2C3D4E5F6'));
    }

// to start ranging beacons
    _streamRanging =
        flutterBeacon.ranging(regions).listen((RangingResult result) {
      print(result);
      // result contains a region and list of beacons found
      // list can be empty if no matching beacons were found in range
      setState(() {
        beacons = result.beacons;
      });
    });

// to stop ranging beacons
//    _streamRanging.cancel();
  }

  @override
  void dispose() {
    print("dispose");
    _streamRanging.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (Container(
      child: Padding(
        padding: EdgeInsets.only(top: 200),
        child: AnimationLimiter(
          child: ListView.builder(
            itemCount: beacons.length,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 675),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Card(
                      child: Container(
                        child: Text(beacons[index].macAddress),
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
    ));
  }
}
