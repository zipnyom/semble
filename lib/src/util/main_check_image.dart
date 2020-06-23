import 'package:flutter/material.dart';

class MainCheckButtonPaint extends CustomPainter {
  double _dy;
  MainCheckButtonPaint(this._dy);
  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.height * 0.2;

    Paint paint = Paint()..color = Colors.blue;

//    print("dy : ${size.height + radius - (radius * _dy)}");
    canvas.drawCircle(
        Offset(size.width * 0.5, size.height + radius - (radius * _dy)),
        radius,
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    MainCheckButtonPaint old = oldDelegate as MainCheckButtonPaint;
    return old._dy != _dy;
  }
}
