import 'package:flutter/material.dart';

import '../constants/values/values.dart';

class AddSubIcon extends StatelessWidget {
  final VoidCallback? callback;
  final Color? color;
  final double? scale;
  final Icon icon;

  const AddSubIcon({
    super.key,
    required this.icon,
    this.callback,
    this.scale,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: callback,
        child: Container(
            width: 50 * (scale == null ? 1.0 : scale!),
            height: 50 * (scale == null ? 1.0 : scale!),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color ?? Colors.transparent,
                border: Border.all(
                    width: 2, color: color ?? HexColor.fromHex("616575"))),
            child: icon));
  }
}
