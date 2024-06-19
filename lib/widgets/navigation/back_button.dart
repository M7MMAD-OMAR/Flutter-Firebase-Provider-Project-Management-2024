import 'package:flutter/material.dart';

import '../../routes.dart';
import '../Shapes/roundedborder_with_icon_widget.dart';

class AppBackButtonWidget extends StatelessWidget {
  const AppBackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, Routes.timelineScreen,
                (Route<dynamic> route) => false);
          }
        },
        child: const RoundedBorderWithIcon(icon: Icons.arrow_back),
      ),
    );
  }
}
