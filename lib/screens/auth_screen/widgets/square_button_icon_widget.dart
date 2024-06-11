import 'package:flutter/material.dart';

import '../../../constants/values.dart';

class SquareButtonIconWidget extends StatelessWidget {
  SquareButtonIconWidget(
      {super.key, required this.imagePath, required this.onTap});

  String imagePath;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Utils.getScreenWidth(context) * 0.16,
            vertical: Utils.getScreenHeight(context) * 0.025),
        decoration: BoxDecoration(
            color: null,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white,
            )),
        child: Image.asset(
          imagePath,
          height: Utils.getScreenHeight(context) * 0.08,
        ),
      ),
    );
  }
}
