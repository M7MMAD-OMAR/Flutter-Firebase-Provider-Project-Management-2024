import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/onboarding_carousel_screen.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/widgets/background_image.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/widgets/bubble.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/widgets/loading_stickers.dart';
import 'package:project_management_muhmad_omar/widgets/Shapes/background_hexagon.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background.dart';

class OnboardingStartScreen extends StatelessWidget {
  const OnboardingStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        DarkRadialBackground(
          color: HexColor.fromHex("#181a1f"),
          position: "topLeft",
        ),
        Positioned(
            top: Utils.getScreenHeight(context),
            left: 0,
            child: Transform.rotate(
                angle: -math.pi / 2,
                child: CustomPaint(painter: BackgroundHexagon()))),
        Positioned(
            top: Utils.getScreenHeight(context) * 0.7,
            right: 100,
            child: BackgroundImage(
                scale: 1.0,
                image: "assets/man-head.png",
                gradient: [
                  HexColor.fromHex("92ECEC"),
                  HexColor.fromHex("92ECEC")
                ])),
        Positioned(
            top: Utils.getScreenHeight(context) * 0.50,
            left: Utils.getScreenWidth(context) * 0.12,
            child: BackgroundImage(
                scale: 0.5,
                image: "assets/head_cut.png",
                gradient: [
                  HexColor.fromHex("FD9871"),
                  HexColor.fromHex("F7D092")
                ])),
        Positioned(
            top: Utils.getScreenHeight(context) * 0.30,
            right: 70,
            child: BackgroundImage(
                scale: 0.4,
                image: "assets/girl_smile.png",
                gradient: [
                  HexColor.fromHex("#a7b2fd"),
                  HexColor.fromHex("#c1a0fd")
                ])),
        Positioned(
            top: 80, left: 50, child: Bubble(1.0, HexColor.fromHex("A06AF9"))),
        Positioned(
            top: 130,
            left: 130,
            child: Bubble(0.6, HexColor.fromHex("FDA5FF"))),
        Positioned(
            top: Utils.getScreenHeight(context) * 0.12,
            left: Utils.getScreenWidth(context) * 0.45,
            child: LoadingSticker(gradients: [
              HexColor.fromHex("#F3EEAE"),
              HexColor.fromHex("F3EFAB"),
              HexColor.fromHex("#4A88FE")
            ])),
        Positioned(
            top: Utils.getScreenHeight(context) * 0.50,
            left: Utils.getScreenWidth(context) * 0.22,
            child: LoadingSticker(gradients: [
              HexColor.fromHex("#a7b2fd"),
              HexColor.fromHex("#c1a0fd")
            ])),
        Positioned(
            top: Utils.getScreenHeight(context) * 0.7,
            left: Utils.getScreenWidth(context) * 0.6,
            child: LoadingSticker(gradients: [
              HexColor.fromHex("#a7b2fd"),
              HexColor.fromHex("#c1a0fd")
            ])),
        Positioned(
            top: Utils.getScreenHeight(context) * 1.3,
            left: Utils.getScreenWidth(context) * 0.83,
            child: Transform.rotate(
              angle: -math.pi / 4,
              child: InkWell(
                onTap: () {
                  Get.to(() => const OnboardingCarouselScreen());
                },
                child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: HexColor.fromHex("B6FFE5")),
                    child: Transform.rotate(
                      angle: math.pi / 4,
                      child: Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(top: 80, left: 30),
                          child: const Icon(Icons.arrow_forward, size: 40)),
                    )),
              ),
            )),
        Positioned(
            bottom: 150,
            left: 40,
            child: Container(
              width: 300,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Task Management ',
                        style: GoogleFonts.lato(
                            fontSize: 18, color: HexColor.fromHex("FDA5FF")),
                        children: const <TextSpan>[
                          TextSpan(
                            text: '🙌',
                          ),
                        ],
                      ),
                    ),
                    Text('Lets create\na space\nfor your workflows.',
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold)),
                    AppSpaces.verticalSpace20,
                    SizedBox(
                      width: 180,
                      height: 60,
                      child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => const OnboardingCarouselScreen());
                          },
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  HexColor.fromHex("246CFE")),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: BorderSide(
                                          color: HexColor.fromHex("246CFE"))))),
                          child: Center(
                              child: Text('Get Started',
                                  style: GoogleFonts.lato(
                                      fontSize: 20, color: Colors.white)))),
                    )
                  ]),
            ))
      ]),
    );
  }
}
