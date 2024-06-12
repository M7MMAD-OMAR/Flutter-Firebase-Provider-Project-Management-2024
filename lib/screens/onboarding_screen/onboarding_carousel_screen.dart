import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/widgets/image_outlined_button.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/widgets/slider_captioned_image.dart';

import '../../constants/values.dart';
import '../../routes.dart';
import '../../widgets/dark_background/dark_radial_background.dart';

class OnboardingCarouselScreen extends StatefulWidget {
  const OnboardingCarouselScreen({super.key});

  @override
  OnboardingCarouselScreenState createState() =>
      OnboardingCarouselScreenState();
}

class OnboardingCarouselScreenState extends State<OnboardingCarouselScreen> {
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
                          index: 1,
                          imageUrl: "assets/slider-background-3.png",
                          caption: "العمل\nفي أي مكان\nبسهولة",
                        ),
                        SliderCaptionedImage(
                            index: 2,
                            imageUrl: "assets/slider-background-2.png",
                            caption: "إدارة\nكل شيء\nعلى الهاتف"),
                        SliderCaptionedImage(
                          index: 0,
                          imageUrl: "assets/slider-background-1.png",
                          caption: "مهام, تقويم\nمحادثة",
                        ),
                      ],
                    ),
                  ),
                ),
                // Buttons
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 20.0),
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
                              Navigator.pushNamed(
                                  context, Routes.emailAddressScreen);
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
                                  '   المتابعة بواسطة البريد الإلكتورني',
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
                              const Expanded(
                                  child: OutlinedButtonWithImage(
                                      imageUrl: "assets/google_icon.png")),
                              const SizedBox(width: 20),
                              Expanded(
                                  child: OutlinedButtonWithImage(
                                      callback: () {
                                        Navigator.pushNamed(
                                            context, Routes.dashboardScreen);
                                      },
                                      imageUrl: "assets/anonymos.png"))
                            ]),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'من خلال الاستمرار فإنك توافق على شروط الخدمات وسياسة الخصوصية الخاصة بنا.',
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
