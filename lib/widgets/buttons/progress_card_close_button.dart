import 'package:flutter/material.dart';

import '../../constants/values/values.dart';

class ProgressCardCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ProgressCardCloseButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              color: AppColors.primaryAccentColor, shape: BoxShape.circle),
          child: const Center(
              child: Icon(Icons.close, size: 20, color: Colors.white))),
    );
  }
}
