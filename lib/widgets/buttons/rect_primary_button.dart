import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/values/values.dart';

class RectPrimaryButtonWithIcon extends StatelessWidget {
  final String buttonText;
  final IconData? icon;
  final int itemIndex;
  final ValueNotifier<int> notifier;
  final VoidCallback? callback;

  const RectPrimaryButtonWithIcon(
      {super.key,
      this.callback,
      this.icon,
      required this.notifier,
      required this.buttonText,
      required this.itemIndex});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: notifier,
        builder: (BuildContext context, _, __) {
          return ElevatedButton(
              onPressed: () {
                notifier.value = itemIndex;
                if (callback != null) {
                  callback!();
                }
              },
              style: ButtonStyle(
                  backgroundColor: notifier.value == itemIndex
                      ? WidgetStateProperty.all<Color>(
                          HexColor.fromHex("246CFE"))
                      : WidgetStateProperty.all<Color>(
                          HexColor.fromHex("181A1F")),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: notifier.value == itemIndex
                              ? BorderSide(color: HexColor.fromHex("246CFE"))
                              : BorderSide(
                                  color: HexColor.fromHex("181A1F"))))),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) Icon(icon!, color: Colors.white),
                    Text("   $buttonText",
                        style: GoogleFonts.lato(
                            fontSize: 14, color: Colors.white)),
                  ],
                ),
              ));
        });
  }
}
