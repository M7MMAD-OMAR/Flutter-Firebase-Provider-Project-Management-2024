import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/routes.dart';
import 'package:project_management_muhmad_omar/widgets/Forms/form_input_with%20_label.dart';
import 'package:project_management_muhmad_omar/widgets/Navigation/back.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background.dart';

class LoginScreen extends StatefulWidget {
  final String email;

  const LoginScreen({super.key, required this.email});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passController = TextEditingController();
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      DarkRadialBackground(
        color: HexColor.fromHex("#181a1f"),
        position: "topLeft",
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NavigationBack(),
            const SizedBox(height: 40),
            Text('Login',
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
            AppSpaces.verticalSpace20,
            RichText(
              text: TextSpan(
                text: 'Using  ',
                style: GoogleFonts.lato(color: HexColor.fromHex("676979")),
                children: <TextSpan>[
                  TextSpan(
                      text: widget.email,
                      style: const TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: "  to login.",
                      style:
                          GoogleFonts.lato(color: HexColor.fromHex("676979"))),
                ],
              ),
            ),
            const SizedBox(height: 30),
            LabelledFormInput(
                placeholder: "Password",
                keyboardType: "text",
                controller: _passController,
                obscureText: obscureText,
                label: "Your Password"),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.newWorkspaceScreen);
                  },
                  style: ButtonStyles.blueRounded,
                  child: Text('Sign In',
                      style:
                          GoogleFonts.lato(fontSize: 20, color: Colors.white))),
            )
          ],
        )),
      )
    ]));
  }
}
