import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/constants.dart';
import '../../constants/values/values.dart';
import '../../widgets/dark_background/darkRadialBackground.dart';
import '../../widgets/onboarding/slider_captioned_image.dart';
import '../Auth/login.dart';

class OnboardingCarousel extends StatefulWidget {
  const OnboardingCarousel({super.key});

  @override
  OnboardingCarouselState createState() => OnboardingCarouselState();
}

class OnboardingCarouselState extends State<OnboardingCarousel> {
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
                      children: <Widget>[
                        SliderCaptionedImage(
                          index: 0,
                          imageUrl: "assets/slider-background-1.png",
                          caption: Constants.task_calendar_chat_key.tr,
                        ),
                        SliderCaptionedImage(
                          index: 1,
                          imageUrl: "assets/slider-background-3.png",
                          caption: Constants.work_anywhere_easily_key.tr,
                        ),
                        SliderCaptionedImage(
                          index: 2,
                          imageUrl: "assets/slider-background-2.png",
                          caption: Constants.manage_everything_on_Phone_key.tr,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0.05, vertical: 20.0),
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
                                  Constants.continue_with_email_key.tr,
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
                            // TODO
                            // SquareButtonIcon(
                            //     imagePath: "lib/images/google2.png",
                            //     onTap: () async {
                            //       showDialog(
                            //           context: context,
                            //           builder: (context) {
                            //             return const Center(
                            //                 child: CircularProgressIndicator());
                            //           });
                            //       var authG =
                            //           await AuthService().signInWithGoogle();
                            //       Navigator.of(context).pop();
                            //       authG.fold((left) {
                            //         MySnackBar.showError(left.toString());
                            //       }, (right) {
                            //         MySnackBar.showSuccess("Done byby");
                            //         dev.log("message");
                            //         Get.offAll(() => const TimelineScreen());
                            //       });
                            //     }),
                            // SquareButtonIcon(
                            //     imagePath: "lib/images/anonymos.png",
                            //     onTap: () async {
                            //       showDialog(
                            //           context: context,
                            //           builder: (context) {
                            //             return const Center(
                            //                 child: CircularProgressIndicator());
                            //           });
                            //
                            //       var anonymousSignIN = await AuthService()
                            //           .anonymosSignInMethod();
                            //
                            //       Navigator.of(context).pop();
                            //       anonymousSignIN.fold((left) {
                            //         MySnackBar.showError(left.toString());
                            //         return;
                            //       }, (right) {
                            //         Get.offAll(() => const TimelineScreen());
                            //       });
                            //       dev.log("message");
                            //     }),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            Constants
                                .by_continuing_you_agree_plans_to_dos_terms_of_services_privacy_policy_key
                                .tr,
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
