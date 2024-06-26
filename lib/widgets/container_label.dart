import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/values/values.dart';

class ContainerLabel extends StatelessWidget {
  final String label;

  const ContainerLabel({
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Text(label,
            style: GoogleFonts.lato(
                fontSize: 12,
                color: HexColor.fromHex("666A7A"),
                fontWeight: FontWeight.bold)));
  }
}
