import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/widgets/Shapes/roundedborder_with_icon.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: const RoundedBorderWithIcon(icon: Icons.arrow_back),
    );
  }
}
