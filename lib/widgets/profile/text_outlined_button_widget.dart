import 'package:flutter/material.dart';

import 'package:project_management_muhmad_omar/constants/values.dart';

class OutlinedButtonWithText extends StatelessWidget {
  final String content;
  final double width;
  final VoidCallback? onPressed;
  const OutlinedButtonWithText(
      {Key? key, required this.content, required this.width, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(HexColor.fromHex("181A1F")),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: BorderSide(color: HexColor.fromHex("246EFE"), width: 2),
            ),
          ),
        ),
        child: Center(
          child: Text(
            content,
            style: TextStyle(
                fontSize: Utils.screenWidth * 0.05, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
