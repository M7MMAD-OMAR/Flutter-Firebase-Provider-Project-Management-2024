import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';

class AppAddIcon extends StatelessWidget {
  final StatelessWidget? page;
  final Color? color;
  final double? scale;

  const AppAddIcon({
    super.key,
    this.page,
    this.scale,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page!,
            ),
          );
        }
      },
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
