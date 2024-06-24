import 'dart:async';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vector;
class MyCustomClipper extends CustomClipper<Path> {
  final String type;

  MyCustomClipper(this.type);

  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    Path path = Path();

    if (type == "LEFT") {
      path.lineTo(w, 0);
      path.quadraticBezierTo(w / 7, h / 2, w, h);
      path.lineTo(0, h);
      path.close();
    } else if (type == "RIGHT") {
      path.quadraticBezierTo(w - w / 7, h / 2, 0, h);
      path.lineTo(w, h);
      path.lineTo(w, 0);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

