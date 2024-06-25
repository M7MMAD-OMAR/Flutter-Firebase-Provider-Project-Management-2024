import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Shapes/background_hexagon_widget.dart';

class SliderCaptionedImage extends StatelessWidget {
  final int index;
  final String caption;
  final String imageUrl;
  const SliderCaptionedImage({super.key,
      required this.index,
      required this.caption,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
          top: 0,
          child: Image(
              image: AssetImage(imageUrl),
              fit: BoxFit.contain,
              height: 450)),
      Positioned(
          bottom: 20,
          right: 20,
          child: Text(caption,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Colors.white))),
      index == 0
          ? Positioned(
              bottom: 70,
              right: 50,
              child: Transform.scale(
                scale: 0.3,
                child: Transform.rotate(
                    angle: -math.pi / 2,
                    child: CustomPaint(painter: BackgroundHexagon())),
              ))
          : const SizedBox()
    ]);
  }
}
