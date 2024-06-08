import 'package:flutter/material.dart';

import '../../constants/values/values.dart';

class GreenDoneIcon extends StatelessWidget {
  const GreenDoneIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: HexColor.fromHex("78B462")),
          child: const Icon(Icons.done, color: Colors.white)),
    );
  }
}
