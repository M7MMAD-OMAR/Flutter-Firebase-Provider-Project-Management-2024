import 'package:flutter/material.dart';

import 'package:project_management_muhmad_omar/constants/values.dart';

class LoadingStickerBar extends StatelessWidget {
  final width;
  const LoadingStickerBar({Key? key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: 5,
        decoration: BoxDecoration(
            color: HexColor.fromHex("5E6373"),
            borderRadius: BorderRadius.circular(20)));
  }
}
