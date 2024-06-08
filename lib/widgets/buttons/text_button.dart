import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/values/values.dart';

class AppTextButton extends StatelessWidget {
  final String buttonText;
  final double buttonSize;
  final VoidCallback? callback;

  const AppTextButton(
      {super.key,
      required this.buttonSize,
      required this.buttonText,
      this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Text(buttonText,
          style: GoogleFonts.lato(
              color: HexColor.fromHex("616575"),
              fontSize: buttonSize,
              fontWeight: FontWeight.bold)),
    );
  }
}
