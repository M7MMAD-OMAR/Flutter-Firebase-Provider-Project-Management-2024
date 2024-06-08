import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/widgets/shapes/settings_strip.dart';

class AppSettingsIcon extends StatelessWidget {
  final VoidCallback? callback;

  const AppSettingsIcon({
    super.key,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: const Column(children: [
        SettingsStrip(),
        SizedBox(height: 2),
        RotatedBox(quarterTurns: 2, child: SettingsStrip())
      ]),
    );
  }
}
