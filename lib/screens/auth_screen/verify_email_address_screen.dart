import 'dart:math' as math;

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/timeline_screen.dart';
import 'package:project_management_muhmad_omar/services/auth_service.dart';
import 'package:project_management_muhmad_omar/widgets/Shapes/background_hexagon_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/back_widget.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';

import '../../routes.dart';

class VerifyEmailAddressScreen extends StatefulWidget {
  const VerifyEmailAddressScreen({super.key});

  @override
  _VerifyEmailAddressScreenState createState() =>
      _VerifyEmailAddressScreenState();
}

class _VerifyEmailAddressScreenState extends State<VerifyEmailAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        DarkRadialBackground(
          color: HexColor.fromHex("#181a1f"),
          position: "topLeft",
        ),
        Positioned(
          top: Utils.screenHeight / 2,
          left: Utils.screenWidth,
          child: Transform.rotate(
            angle: -math.pi / 2,
            child: CustomPaint(
              painter: BackgroundHexagon(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const NavigationBack(),
                    AppSpaces.verticalSpace20,
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Utils.screenWidth / 3),
                      child: Icon(
                        size: Utils.screenWidth * 0.29,
                        FontAwesomeIcons.envelopeOpen,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                        height: Utils.screenHeight *
                            0.04), // Adjust the percentage as needed
                    Text(
                        'تحقق من رسائل البريد الإلكتروني الخاص بك. لقد أرسلنا رابط التحقق إلى بريدك الإلكتروني',
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: Utils.screenWidth * 0.09,
                            fontWeight: FontWeight.bold)),
                    AppSpaces.verticalSpace40,
                    SizedBox(
                      //width: 180,
                      height: Utils.screenHeight * 0.15,
                      child: ElevatedButton(
                        onPressed: () async {
                          var verifyEmail =
                              await AuthProvider().sendVerifiectionEmail();
                          verifyEmail.fold((left) {
                            CustomSnackBar.showError(left.toString());
                          },
                              (right) => {
                                    if (right == true)
                                      {
                                        CustomSnackBar.showSuccess(
                                            'تم التحقق من البريد الإلكتروني'),
                                        Get.offAll(
                                            () => const TimelineScreen()),
                                      }
                                  });
                        },
                        style: ButtonStyles.blueRounded,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Iconsax.link, color: Colors.white),
                            Text('إرسال رابط التحقق',
                                style: GoogleFonts.lato(
                                    fontSize: Utils.screenWidth * 0.06,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    AppSpaces.verticalSpace20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'محقق ؟',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Utils.screenWidth * 0.055),
                        ),
                        GestureDetector(
                          onTap: () {
                            var verifed = AuthProvider().checkEmailVerifction();
                            verifed.fold((left) {
                              CustomSnackBar.showError(left.toString());
                            }, (right) {
                              if (right == true) {
                                CustomSnackBar.showSuccess('نجاح');
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    Routes.timelineScreen,
                                    (Route<dynamic> route) => false);
                              } else {
                                CustomSnackBar.showError(
                                    'يرجى التحقق من بريدك الإلكتروني قبل المتابعة');
                              }
                            });
                          },
                          child: Text(
                            'استمرار',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: Utils.screenWidth * 0.055,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ]),
            ),
          ),
        )
      ]),
    );
  }
}
