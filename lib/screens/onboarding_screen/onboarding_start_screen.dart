import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/app_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';

import '../../widgets/Onboarding/background_image_widget.dart';
import '../../widgets/Onboarding/bubble_widget.dart';
import '../../widgets/Onboarding/loading_stickers_widget.dart';
import '../../widgets/Shapes/background_hexagon_widget.dart';
import 'onboarding_carousel_screen.dart';

class OnboardingStart extends StatelessWidget {
  const OnboardingStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DarkRadialBackground(
            color: HexColor.fromHex("#181a1f"),
            position: "Lefttop",
          ),
          Positioned(
            top: Utils.screenHeight,
            left: Utils.screenWidth * AppConstants.dir['ar']["square_shape_L"],
            child: Transform.rotate(
              angle: -math.pi / 2,
              child: CustomPaint(painter: BackgroundHexagon()),
            ),
          ),
          Positioned(
            top: Utils.screenHeight * 0.7,
            left: AppConstants.dir['ar']["big_picture_L"],
            child: BackgroundImage(
              scale: 1.0,
              image: 'ar' == 'ar' ? "assets/karem2R.png" : "assets/karem2.png",
              gradient: [
                HexColor.fromHex("92ECEC"),
                HexColor.fromHex("92ECEC"),
              ],
            ),
          ),
          Positioned(
            top: Utils.screenHeight * 0.50,
            left:
                Utils.screenWidth * AppConstants.dir['ar']["medium_picture_L"],
            child: BackgroundImage(
              scale: 0.5,
              image: 'ar' == 'ar'
                  ? "assets/head_cut-R.png"
                  : "assets/head_cut.png",
              gradient: [
                HexColor.fromHex("FD9871"),
                HexColor.fromHex("F7D092"),
              ],
            ),
          ),
          Positioned(
            top: Utils.screenHeight * 0.30,
            left: AppConstants.dir['ar']["small_picture_L"],
            child: BackgroundImage(
              scale: 0.4,
              image: 'ar' == 'ar'
                  ? "assets/girl_smile-R.png"
                  : "assets/girl_smile.png",
              gradient: [
                HexColor.fromHex("#a7b2fd"),
                HexColor.fromHex("#c1a0fd"),
              ],
            ),
          ),
          Positioned(
            top: 80,
            left: AppConstants.dir['ar']["big_bubble_L"],
            child: Bubble(1.0, HexColor.fromHex("A06AF9")),
          ),
          Positioned(
            top: 130,
            left: AppConstants.dir['ar']["small_bubble_L"],
            child: Bubble(0.6, HexColor.fromHex("FDA5FF")),
          ),
          Positioned(
            top: Utils.screenHeight * 0.12,
            left: Utils.screenWidth * AppConstants.dir['ar']["one_sticker_L"],
            child: LoadingSticker(
              gradients: [
                HexColor.fromHex("#F3EEAE"),
                HexColor.fromHex("F3EFAB"),
                HexColor.fromHex("#4A88FE"),
              ],
            ),
          ),
          Positioned(
            top: Utils.screenHeight * 0.50,
            left: Utils.screenWidth * AppConstants.dir['ar']["two_sticker_L"],
            child: LoadingSticker(
              gradients: [
                HexColor.fromHex("#a7b2fd"),
                HexColor.fromHex("#c1a0fd"),
              ],
            ),
          ),
          Positioned(
            top: Utils.screenHeight * 0.7,
            left: Utils.screenWidth * AppConstants.dir['ar']["three_sticker_L"],
            right:
                Utils.screenWidth * AppConstants.dir['ar']["three_sticker_R"],
            child: LoadingSticker(
              gradients: [
                HexColor.fromHex("#a7b2fd"),
                HexColor.fromHex("#c1a0fd"),
              ],
            ),
          ),
          Positioned(
            top: Utils.screenHeight * 1.3,
            right:
                Utils.screenWidth * AppConstants.dir['ar']["triangle_shape_R"],
            left:
                Utils.screenWidth * AppConstants.dir['ar']["triangle_shape_L"],
            child: Transform.rotate(
              angle: -math.pi / 4,
              child: InkWell(
                onTap: () {
                  Get.to(() => const OnboardingCarousel());
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: HexColor.fromHex("B6FFE5"),
                  ),
                  child: Transform.rotate(
                    angle: math.pi / 4,
                    child: Container(
                      alignment:
                          'ar' == 'ar' ? Alignment.topRight : Alignment.topLeft,
                      padding: const EdgeInsets.only(
                        top: 85,
                      ),
                      child: const Icon(
                        'ar' == 'ar' ? Icons.arrow_back : Icons.arrow_forward,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: AppConstants.dir['ar']["get_started_B"],
            left: AppConstants.dir['ar']["get_started_L"],
            child: SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'إدارة المهام',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: HexColor.fromHex("FDA5FF"),
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: '🙌',
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'دعونا نخلق\nمساحة\nلسير العمل\nالخاص بك',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpaces.verticalSpace20,
                  SizedBox(
                    width: 180,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const OnboardingCarousel());
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          HexColor.fromHex("246CFE"),
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: BorderSide(
                              color: HexColor.fromHex("246CFE"),
                            ),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'ابدأ الإن',
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
