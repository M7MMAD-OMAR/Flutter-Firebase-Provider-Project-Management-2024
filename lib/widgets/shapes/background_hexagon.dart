import 'package:flutter/material.dart';
import 'package:flutter_shapes/flutter_shapes.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';

class BackgroundHexagon extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = HexColor.fromHex("262A34");
    Shapes shapes = Shapes(
        canvas: canvas,
        radius: 50,
        paint: paint,
        center: Offset.zero,
        angle: 0);

    shapes.drawType(ShapeType.Hexagon);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
