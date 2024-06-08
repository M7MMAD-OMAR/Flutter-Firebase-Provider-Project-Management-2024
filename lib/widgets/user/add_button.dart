import 'package:flutter/material.dart';

import '../../constants/values/values.dart';

class AddIcon extends StatelessWidget {
  final StatelessWidget? page;
  final Color? color;
  final double? scale;
  final VoidCallback onClick;

  const AddIcon(
      {super.key, this.page, this.scale, this.color, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
          width: 50 * (scale == null ? 1.0 : scale!),
          height: 50 * (scale == null ? 1.0 : scale!),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color ?? Colors.transparent,
              border: Border.all(
                  width: 2, color: color ?? HexColor.fromHex("616575"))),
          child: const Icon(Icons.add, color: Colors.white)),
    );
  }
}
