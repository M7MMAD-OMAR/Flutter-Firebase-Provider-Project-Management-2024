import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/app_constans.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/controllers/topController.dart';
import 'package:project_management_muhmad_omar/controllers/userController.dart';
import 'package:project_management_muhmad_omar/services/collectionsrefrences.dart';

import '../../Values/values.dart';
import '../../components/sqaure_Button.dart';
import '../../services/auth_service.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';
import '../../widgets/Forms/form_input_with_label.dart';
import '../../widgets/Navigation/back.dart';
import '../../widgets/Shapes/background_hexagon.dart';
import '../../widgets/Snackbar/custom_snackber.dart';
import '../Dashboard/timeline.dart';
import 'signup.dart';

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
                      Text(AppConstants.whats_your_email_address_key.tr,
                          //"What's your\nemail\naddress?",
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: Utils.screenWidth * 0.12,
                              fontWeight: FontWeight.bold)),
                      AppSpaces.verticalSpace20,
                      LabelledFormInput(
                          autovalidateMode: AutovalidateMode.disabled,
                          validator: (value) {
                            if (!EmailValidator.validate(value!)) {
                              return AppConstants.enter_valid_email_key.tr;
                              //"Enter Valid Email";
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
                          placeholder: AppConstants.email_key.tr,
                          keyboardType: "text",
                          controller: _emailController,
                          obscureText: obscureText,
                          label: AppConstants.your_email_key.tr),
                      AppSpaces.verticalSpace40,
                      SizedBox(
                        //width: 180,
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
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const CircularProgressIndicator(),
                                          const SizedBox(height: 16),
                                          Text(
                                            AppConstants
                                                .Checking_Email_if_exsit_before_key
                                                .tr,
                                            //  'Checking Email if exsit before',
                                            style: const TextStyle(
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
                                  AppConstants
                                      .Sorry_But_Email_Already_In_Use_key.tr,
                                  //  "Sorry But Email Already In Use"
                                );
                              } else {
                                Navigator.of(context).pop();
                                Get.to(
                                  () => SignUp(email: email),
                                );
                              }
                            }
                          },
                          style: ButtonStyles.blueRounded,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.email, color: Colors.white),
                              Text(
                                AppConstants.continue_with_email_key.tr,
                                // '   Continue with Email',
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
                                await AuthService().signInWithGoogle();
                                authG.fold((left) {
                                  Navigator.of(context).pop();
                                  CustomSnackBar.showError(left.toString());
                                }, (right) {
                                  Navigator.of(context).pop();
                                  CustomSnackBar.showSuccess("Done byby");
                                });
//   dev.log("message");
                                Get.to(Get.to(() => const Timeline()));
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
                                await AuthService().anonymosSignInMethod();
                                Navigator.of(context).pop();

                                //    dev.log("message");
                                Get.to(() => const Timeline());
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
