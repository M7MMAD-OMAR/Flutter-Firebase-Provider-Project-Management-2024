import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/values/values.dart';
import '../widgets/app_logo/app_logo.dart';
import '../widgets/dark_background/darkRadialBackground.dart';
import 'onboarding_screen/onboarding_start.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String id = "SplashScreen";

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.to(() => const OnboardingStart());
    });
  }

  final Shader linearGradient = LinearGradient(
    begin: FractionalOffset.topCenter,
    colors: <Color>[HexColor.fromHex("#a7b2fd"), HexColor.fromHex("#c1a0fd")],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 30.0, 40.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        DarkRadialBackground(
          color: HexColor.fromHex("#181a1f"),
          position: "topLeft",
        ),
        const Positioned(left: 140, child: AppLogo()),
        Center(
            child: RichText(
          text: TextSpan(
            text: 'Task',
            style: GoogleFonts.lato(fontSize: 40),
            children: <TextSpan>[
              TextSpan(
                  text: 'ez',
                  style: TextStyle(
                      foreground: Paint()..shader = linearGradient,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ))
        // DarkRadialBackground(
        //   color: Colors.transparent,
        //   position: "bottomRight",
        // ),
      ]),
    );
  }
}
