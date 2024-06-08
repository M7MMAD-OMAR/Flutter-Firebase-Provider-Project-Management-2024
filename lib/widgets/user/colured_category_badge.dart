import 'package:flutter/material.dart';

import '../../constants/values/values.dart';

class ColouredCategoryBadge extends StatelessWidget {
  const ColouredCategoryBadge({
    super.key,
    required this.color,
    required this.icon,
  });

  final Icon icon;
  final String color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        // color: HexColor.fromHex(color),
        gradient: RadialGradient(
          radius: 0.7,
          colors: [
            HexColor.fromHex(color).withOpacity(0.7),
            Colors.white,
            HexColor.fromHex(color).withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 255, 254, 254).withOpacity(0.6),
            blurRadius: 5,
            offset: const Offset(4, 3),
          ),
        ],
      ),
      child: icon,
    );
  }
}
