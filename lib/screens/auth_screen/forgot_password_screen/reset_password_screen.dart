import 'dart:math' as math;

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/routes.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';

import '../../../widgets/Shapes/background_hexagon_widget.dart';
import '../../../widgets/forms/form_input_with_label_widget.dart';
import '../../../widgets/navigation/back_widget.dart';
import '../../../widgets/snackbar/custom_snackber_widget.dart';
import '../../../widgets/sqaure_button_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
  });

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
                      const SizedBox(height: 40),
                      Text(
                        'ما هو عنوان بريدك الإلكتروني؟ لإرسال رابط إعادة تعيين كلمة المرور',
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
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
                        //width: 180,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                showDialogMethod(context);
                                await AuthProvider()
                                    .resetPassword(email: email);
                                Navigator.of(context).pop();
                                CustomSnackBar.showSuccess(
                                    'لقد أرسلنا رابط إعادة تعيين كلمة المرور');
                              } on Exception catch (e) {
                                Navigator.of(context).pop();
                                CustomSnackBar.showError(
                                    "حدث خطأ ما , حاول لاحقا");
                              }
                            }
                          },
                          style: ButtonStyles.blueRounded,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.email, color: Colors.white),
                              Text(
                                'إرسال رابط إعادة تعيين كلمة المرور',
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
