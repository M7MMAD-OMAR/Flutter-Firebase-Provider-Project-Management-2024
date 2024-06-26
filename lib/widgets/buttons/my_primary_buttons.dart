import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/values/values.dart';

enum MyPrimaryButtonSizes { small, medium, large }

class MyAppPrimaryButton extends StatelessWidget {
  final double buttonHeight;
  final double buttonWidth;

  final String buttonText;
  final VoidCallback? callback;

  const MyAppPrimaryButton(
      {super.key,
      this.callback,
      required this.buttonText,
      required this.buttonHeight,
      required this.buttonWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //padding: EdgeInsets.all(20),
      // width: 180,
      // height: 50,
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: callback,
        style: ButtonStyles.blueRounded,
        child: Text(
          buttonText,
          style: GoogleFonts.lato(
              fontSize: Utils.screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }
}
