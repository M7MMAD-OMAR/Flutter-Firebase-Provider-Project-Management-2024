import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/Screens/Auth/ui%20forgot%20password/size_config_widget.dart';

class HorizontalSpace extends StatelessWidget {
  const HorizontalSpace(this.value, {super.key});
  final double? value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth! * value!,
    );
  }
}

class VerticalSpace extends StatelessWidget {
  const VerticalSpace(this.value, {super.key});
  final double? value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenHeight! * value!,
    );
  }
}
