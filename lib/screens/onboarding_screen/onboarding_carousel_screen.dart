import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/app_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/screens/auth_screen/login_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/timeline_screen.dart';
import 'package:project_management_muhmad_omar/services/auth_service.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';
import 'package:project_management_muhmad_omar/widgets/sqaure_button_widget.dart';

import '../../widgets/Onboarding/slider_captioned_image_widget.dart';

class OnboardingCarousel extends StatefulWidget {
  const OnboardingCarousel({super.key});

  @override
  _OnboardingCarouselState createState() => _OnboardingCarouselState();
}

class _OnboardingCarouselState extends State<OnboardingCarousel> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isActive ? HexColor.fromHex("266FFE") : HexColor.fromHex("666A7A"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            DarkRadialBackground(
              color: HexColor.fromHex("#181a1f"),
              position: "bottomRight",
            ),
            Column(
              children: [
                Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: PageView(
                      physics: const ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: const <Widget>[
                        SliderCaptionedImage(
                          index: 0,
                          imageUrl: "assets/slider-background-1.png",
                          caption: "المهمة،\nالتقويم،\n",
                        ),
                        SliderCaptionedImage(
                          index: 1,
                          imageUrl: "assets/slider-background-3.png",
                          caption: "اعمل\nمن أي مكان\nبسهولة",
                        ),
                        SliderCaptionedImage(
                          index: 2,
                          imageUrl: "assets/slider-background-2.png",
                          caption: "ادارة\nكل شيء\nعلى الهاتف",
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Utils.screenWidth * 0.05, vertical: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _buildPageIndicator(),
                        ),
                        const SizedBox(height: 50),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => const Login());
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  HexColor.fromHex("246CFE")),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: BorderSide(
                                    color: HexColor.fromHex("246CFE"),
                                  ),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.email, color: Colors.white),
                                Text(
                                  'استمر بواسطة البريد الإلكتروني',
                                  style: GoogleFonts.lato(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SquareButtonIcon(
                                imagePath: "lib/images/google2.png",
                                onTap: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      });
                                  var authG =
                                      await AuthProvider().signInWithGoogle();
                                  Navigator.of(context).pop();
                                  authG.fold((left) {
                                    CustomSnackBar.showError(left.toString());
                                  }, (right) {
                                    CustomSnackBar.showSuccess("Done byby");
                                    dev.log("message");
                                    Get.offAll(() => const Timeline());
                                  });
                                }),
                            SquareButtonIcon(
                                imagePath: "lib/images/anonymos.png",
                                onTap: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      });

                                  var anonymousSignIN = await AuthProvider()
                                      .anonymosSignInMethod();

                                  Navigator.of(context).pop();
                                  anonymousSignIN.fold((left) {
                                    CustomSnackBar.showError(left.toString());
                                    return;
                                  }, (right) {
                                    Get.offAll(() => const Timeline());
                                  });
                                  dev.log("message");
                                }),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'من خلال الاستمرار، فإنك توافق على شروط الخدمة وسياسة الخصوصية',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                fontSize: 15,
                                color: HexColor.fromHex("666A7A")),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
