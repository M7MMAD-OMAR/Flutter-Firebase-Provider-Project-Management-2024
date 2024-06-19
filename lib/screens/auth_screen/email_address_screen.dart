import 'dart:math' as math;

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/topController.dart';
import 'package:project_management_muhmad_omar/routes.dart';
import 'package:project_management_muhmad_omar/services/collections_refrences.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/forms/form_input_with_label_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/back_widget.dart';
import 'package:project_management_muhmad_omar/widgets/shapes/background_hexagon_widget.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';
import 'package:project_management_muhmad_omar/widgets/sqaure_button_widget.dart';

import 'signup_screen.dart';

class EmailAddressScreen extends StatefulWidget {
  const EmailAddressScreen({
    super.key,
  });

  @override
  _EmailAddressScreenState createState() => _EmailAddressScreenState();
}

class _EmailAddressScreenState extends State<EmailAddressScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  String email = "";
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
            top: Utils.screenHeight / 2,
            left: Utils.screenWidth,
            child: Transform.rotate(
                angle: -math.pi / 2,
                child: CustomPaint(painter: BackgroundHexagon()))),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const NavigationBack(),
                      SizedBox(height: Utils.screenHeight * 0.12),
                      Text('ما هو عنوان بريدك الإلكتروني؟',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: Utils.screenWidth * 0.12,
                              fontWeight: FontWeight.bold)),
                      AppSpaces.verticalSpace20,
                      LabelledFormInput(
                          autovalidateMode: AutovalidateMode.disabled,
                          validator: (value) {
                            if (!EmailValidator.validate(value!)) {
                              return 'أدخل بريد إلكتروني صالح';
                            } else {
                              return null;
                            }
                          },
                          onClear: () {
                            setState(() {
                              email = "";
                              _emailController.text = "";
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          readOnly: false,
                          placeholder: ' البريد ',
                          keyboardType: "text",
                          controller: _emailController,
                          obscureText: obscureText,
                          label: 'بريدك الإلكتروني'),
                      AppSpaces.verticalSpace40,
                      SizedBox(
                        height: Utils.screenWidth * 0.14,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(height: 16),
                                          Text(
                                            'التحقق من وجود الإيميل مسبقاً',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                              if (await TopController().existByOne(
                                  collectionReference: usersRef,
                                  field: emailK,
                                  value: email)) {
                                Navigator.of(context).pop();
                                CustomSnackBar.showError(
                                  'عذراً ولكن الإيميل موجود مسبقاً',
                                );
                              } else {
                                Navigator.of(context).pop();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            SignUpScreen(email: email)));
                              }
                            }
                          },
                          style: ButtonStyles.blueRounded,
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
                      AppSpaces.verticalSpace20,
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
                                authG.fold((left) {
                                  Navigator.of(context).pop();
                                  CustomSnackBar.showError(left.toString());
                                }, (right) {
                                  Navigator.of(context).pop();
                                  CustomSnackBar.showSuccess("Done byby");
                                });

                                Navigator.pushNamed(
                                    context, Routes.timelineScreen);
                              }),
                          SquareButtonIcon(
                              imagePath: "lib/images/anonymos.png",
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      elevation: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(height: 16),
                                            Text(
                                              'Waiting',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                                await AuthProvider().anonymosSignInMethod();
                                Navigator.of(context).pop();

                                Navigator.pushNamed(
                                    context, Routes.timelineScreen);
                              }),
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
