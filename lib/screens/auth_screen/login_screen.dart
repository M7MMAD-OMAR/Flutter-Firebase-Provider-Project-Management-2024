import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/routes.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/forms/form_input_with_label_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/back_widget.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
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
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const NavigationBack(),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              'تسجيل الدخول',
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            AppSpaces.verticalSpace20,
                            Text(
                              'سعيد برؤيتك! ',
                              style: GoogleFonts.pacifico(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
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
                      obscureText: false,
                      label: 'بريدك الإلكتروني',
                    ),
                    LabelledFormInput(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'لا يمكن ترك حقل كلمة المرور فارغًا';
                        }
                        return null;
                      },
                      onClear: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      autovalidateMode: AutovalidateMode.disabled,
                      readOnly: false,
                      placeholder: 'كلمة المرور',
                      keyboardType: "text",
                      controller: _passController,
                      obscureText: obscureText,
                      label: 'كلمة المرور الخاصة بك',
                    ),
                    AppSpaces.verticalSpace20,
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.resetPassword);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              'هل نسيت كلمة السر ؟',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    AppSpaces.verticalSpace20,
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  });

                              UserCredential userCredential =
                                  await AuthProvider()
                                      .sigInWithEmailAndPassword(
                                          email: email, password: password);
                              Navigator.of(context).pop();

                              if (userCredential.user!.emailVerified) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  Routes.timelineScreen,
                                  (Route<dynamic> route) => false,
                                );
                              } else {
                                Navigator.pushNamed(
                                    context, Routes.verifyEmailAddressScreen);
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                CustomSnackBar.showError(
                                    'لم يتم العثور على مستخدم بهذا البريد الإلكتروني');
                              }
                              if (e.code == 'wrong-password') {
                                CustomSnackBar.showError('كلمة المرور خاطئة');
                              } else {
                                CustomSnackBar.showError(
                                    e.code.replaceAll(RegExp(r'-'), " "));
                              }
                              Navigator.of(context).pop();

                              return;
                            } catch (e) {
                              Navigator.of(context).pop();

                              CustomSnackBar.showError(e.toString());
                            }
                          }
                        },
                        style: ButtonStyles.blueRounded,
                        child: Text(
                          'تسجيل الدخول',
                          style: GoogleFonts.lato(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    AppSpaces.verticalSpace20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'ليس لديك حساب؟',
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, Routes.emailAddressScreen);
                          },
                          child: Text(
                            'قم بإنشاء حساب جديد',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryAccentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
