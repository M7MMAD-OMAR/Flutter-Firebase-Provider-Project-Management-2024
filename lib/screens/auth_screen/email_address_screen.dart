import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/widgets/Forms/form_input_with%20_label.dart';
import 'package:project_management_muhmad_omar/widgets/Navigation/back.dart';
import 'package:project_management_muhmad_omar/widgets/Shapes/background_hexagon.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background.dart';

import 'signup_screen.dart';

class EmailAddressScreen extends StatefulWidget {
  const EmailAddressScreen({super.key});

  @override
  EmailAddressScreenState createState() => EmailAddressScreenState();
}

class EmailAddressScreenState extends State<EmailAddressScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool obscureText = false;

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
              child: CustomPaint(painter: BackgroundHexagon()))),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const NavigationBack(),
          const SizedBox(height: 40),
          Text("What's your\nemail\naddress?",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold)),
          AppSpaces.verticalSpace20,
          LabelledFormInput(
              placeholder: "Email",
              keyboardType: "text",
              controller: _emailController,
              obscureText: obscureText,
              label: "Your Email"),
          const SizedBox(height: 40),
          SizedBox(
            height: 60,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SignUpScreen(email: _emailController.text),
                    ),
                  );
                },
                style: ButtonStyles.blueRounded,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.email, color: Colors.white),
                    Text('   Continue with Email',
                        style: GoogleFonts.lato(
                            fontSize: 20, color: Colors.white)),
                  ],
                )),
          )
        ])),
      )
    ]));
  }
}
