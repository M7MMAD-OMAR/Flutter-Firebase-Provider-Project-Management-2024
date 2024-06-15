import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/widgets/AppLogo/triplets_container.dart';

class TripletsLogo extends StatelessWidget {
  const TripletsLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(children: [
      const TripletsContainer(),
      const SizedBox(width: 2),
      Transform.rotate(
          angle: -math.pi,
          child: Transform.translate(
              offset: const Offset(0, 7), child: const TripletsContainer()))
    ]));
  }
}
