import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/widgets/background_image.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/widgets/bubble.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/widgets/loading_stickers.dart';
import 'package:project_management_muhmad_omar/widgets/Shapes/background_hexagon.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background.dart';

import '../../routes.dart';

/// This: صفحة البداية التي يظهر بها صورى الأشخاص الثلاث وزر أبدا الىن
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

        // Man Image
        Positioned(
            top: Utils.getScreenHeight(context) * 0.35,
            right: 100,
            child: BackgroundImage(
                scale: 1.0,
                image: "assets/man-head.png",
                gradient: [
                  HexColor.fromHex("92ECEC"),
                  HexColor.fromHex("92ECEC")
                ])),

        // Girl Image
        Positioned(
            top: Utils.getScreenHeight(context) * 0.25,
            left: Utils.getScreenWidth(context) * 0.12,
            child: BackgroundImage(
                scale: 0.5,
                image: "assets/head_cut.png",
                gradient: [
                  HexColor.fromHex("FD9871"),
                  HexColor.fromHex("F7D092")
                ])),

        // Girl Image
        Positioned(
            top: Utils.getScreenHeight(context) * 0.20,
            right: 70,
            child: BackgroundImage(
                scale: 0.4,
                image: "assets/girl_smile.png",
                gradient: [
                  HexColor.fromHex("#a7b2fd"),
                  HexColor.fromHex("#c1a0fd")
                ])),
        // Circle
        Positioned(
            top: 80, left: 50, child: Bubble(1.0, HexColor.fromHex("A06AF9"))),
        // Circle
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
            top: Utils.getScreenHeight(context) * 0.45,
            left: Utils.getScreenWidth(context) * 0.22,
            child: LoadingSticker(gradients: [
              HexColor.fromHex("#a7b2fd"),
              HexColor.fromHex("#c1a0fd")
            ])),
        Positioned(
            top: Utils.getScreenHeight(context) * 0.9,
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
                  Navigator.pushNamed(context, Routes.onboardingCarouselScreen);
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
            bottom: 100,
            right: 40,
            child: SizedBox(
              width: 300,
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        text: 'تطبيق إدارة المهام ',
                        style: GoogleFonts.lato(
                            fontSize: 20, color: HexColor.fromHex("FDA5FF")),
                        children: const <TextSpan>[
                          TextSpan(
                            text: '🙌',
                          ),
                        ],
                      ),
                    ),
                    Text(
                        textAlign: TextAlign.right,
                        'يتيح إنشاء \n مساحة عمل \n للمشاريع الخاص بك',
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold)),
                    AppSpaces.verticalSpace20,

                    // Get Started button
                    SizedBox(
                      width: 180,
                      height: 60,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Routes.onboardingCarouselScreen);
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
                              child: Text(
                                  textAlign: TextAlign.right,
                                  'ابدأ الآن',
                                  style: GoogleFonts.lato(
                                      fontSize: 20, color: Colors.white)))),
                    )
                  ]),
            ))
      ]),
    );
  }
}
