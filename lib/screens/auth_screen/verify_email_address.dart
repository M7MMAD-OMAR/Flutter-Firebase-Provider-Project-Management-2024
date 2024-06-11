import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/values.dart';
import '../../widgets/Navigation/back.dart';
import '../../widgets/Shapes/background_hexagon.dart';
import '../../widgets/dark_background/dark_radial_background.dart';

class VerifyEmailAddressScreen extends StatefulWidget {
  const VerifyEmailAddressScreen({super.key});

  @override
  VerifyEmailAddressScreenState createState() =>
      VerifyEmailAddressScreenState();
}

class VerifyEmailAddressScreenState extends State<VerifyEmailAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        DarkRadialBackground(
          color: HexColor.fromHex("#181a1f"),
          position: "topLeft",
        ),
        Positioned(
          top: Utils.getScreenHeight(context) / 2,
          left: Utils.getScreenWidth(context),
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
                          horizontal: Utils.getScreenWidth(context) / 3),
                      child: Icon(
                        size: Utils.getScreenWidth(context) * 0.29,
                        FontAwesomeIcons.envelopeOpen,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                        height: Utils.getScreenHeight(context) *
                            0.04), // Adjust the percentage as needed
                    Text(
                        "تحقق من رسائل البريد الإلكتروني التي أرسلناها أرسل الرابط إلى البريد الإلكتروني للتحقق من المفتاح",
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: Utils.getScreenWidth(context) * 0.11,
                            fontWeight: FontWeight.bold)),
                    AppSpaces.verticalSpace40,
                    SizedBox(
                      //width: 180,
                      height: Utils.getScreenHeight(context) * 0.15,
                      child: ElevatedButton(
                        onPressed: () async {
                          // var verifyEmail =
                          //     await AuthService().sendVerifiectionEmail();
                          // verifyEmail.fold((left) {
                          //   CustomSnackBar.showError(left.toString());
                          // },
                          //     (right) => {
                          //           if (right == true)
                          //             {
                          //               SnackBar(content: Text("تم التحقق من البريد"),),
                          //               Get.offAll(() => const Timeline()),
                          //             }
                          //         });
                        },
                        style: ButtonStyles.blueRounded,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.link, color: Colors.white),
                            Text("إرسالة رابط التحقق",
                                style: GoogleFonts.lato(
                                    fontSize:
                                        Utils.getScreenWidth(context) * 0.06,
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
                          "تحقق",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Utils.getScreenWidth(context) * 0.055),
                        ),
                        GestureDetector(
                          onTap: () {
                            // var verifed = AuthService().checkEmailVerifction();
                            // verifed.fold((left) {
                            //   CustomSnackBar.showError(left.toString());
                            // }, (right) {
                            //   if (right == true) {
                            //     CustomSnackBar.showSuccess(
                            //         Constants.sucess_baby_key.tr);
                            //     Get.offAll(() => const Timeline());
                            //   } else {
                            //     CustomSnackBar.showError(Constants
                            //         .plese_verify_your_email_before_continue_key
                            //         .tr);
                            //   }
                            // });
                          },
                          child: Text(
                            "تأكيد",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: Utils.getScreenWidth(context) * 0.055,
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
