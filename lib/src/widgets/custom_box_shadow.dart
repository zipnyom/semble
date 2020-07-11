import 'package:flutter/material.dart';

var customBoxShadow = BoxShadow(
  offset: Offset(0, 7),
  blurRadius: 2,
  color: Color(0xFF6DAED9).withOpacity(0.21),
);

var customBoxShadowReverse = BoxShadow(
  offset: Offset(0, -7),
  blurRadius: 2,
  color: Color(0xFF6DAED9).withOpacity(0.21),
);

// var customBoxShadow = CustomBoxShadow();

class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) result.maskFilter = null;
      return true;
    }());
    return result;
  }
}
