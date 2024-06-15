import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/widgets/Shapes/settings_strip_widget.dart';

class AppSettingsIcon extends StatelessWidget {
  final VoidCallback? callback;
  const AppSettingsIcon({
    Key? key,
    this.callback,
  }) : super(key: key);

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
// the Developer karem saad (KaremSD)