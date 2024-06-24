import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/routes.dart';
import 'package:project_management_muhmad_omar/widgets/Buttons/primary_buttons_widget.dart';
import 'package:project_management_muhmad_omar/widgets/forms/form_input_with_label_widget.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';

class PasswordEmailDialogProvider extends ChangeNotifier {
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String password = "";
  String email = "";
  RegExp regExletters = RegExp(r"(?=.*[a-z])\w+");
  RegExp regExnumbers = RegExp(r"(?=.*[0-9])\w+");
  RegExp regExbigletters = RegExp(r"(?=.*[A-Z])\w+");
  bool obscureText = false;

  void toggleObscureText() {
    obscureText = !obscureText;
    notifyListeners();
  }

  Future<void> showPasswordAndEmailDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryBackgroundColor,
          title: const Text('ادخل كلمة السر & البريد الإلكتروني',
              style: TextStyle(color: Colors.white)),
          content: Form(
            key: formKey,
            child: Column(
              children: [
                LabelledFormInput(
                  autovalidateMode: AutovalidateMode.disabled,
                  validator: (value) {
                    if (!EmailValidator.validate(value!)) {
                      return 'يرجى إدخال بريد إلكتروني صالح';
                    } else {
                      return null;
                    }
                  },
                  onClear: () {
                    email = "";
                    emailController.text = "";
                  },
                  onChanged: (value) {
                    email = value;
                  },
                  readOnly: false,
                  placeholder: ' البريد ',
                  keyboardType: 'text',
                  controller: emailController,
                  obscureText: obscureText,
                  label: 'بريدك الإلكتروني',
                ),
                const SizedBox(height: 20),
                LabelledFormInput(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'يجب أن تحتوي كلمة المرور على أكثر من 7 أحرف';
                    }
                    // if (regExletters.hasMatch(value) == false) {
                    //   return 'يرجى إدخال حرف صغير واحد على الأقل';
                    // }
                    // if (regExnumbers.hasMatch(value) == false) {
                    //   return 'الرجاء إدخال رقم واحد على الأقل';
                    // }
                    // if (regExbigletters.hasMatch(value) == false) {
                    //   return 'الرجاء إدخال حرف كبير واحد على الأقل';
                    // }
                    return null;
                  },
                  onClear: () {
                    toggleObscureText();
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  readOnly: false,
                  placeholder: 'كلمة المرور',
                  keyboardType: 'text',
                  controller: passController,
                  obscureText: obscureText,
                  label: 'كلمة المرور الخاصة بك',
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: AppPrimaryButton(
                callback: () async {
                  try {
                    if (formKey.currentState!.validate()) {
                      showDialogMethod(context);
                      await AuthProvider().convertAnonymousToEmailandPassword(
                        email: email,
                        password: password,
                      );
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.onboardingCarouselScreen,
                        (Route<dynamic> route) => false,
                      );
                      await AuthProvider().logOut();
                    }
                  } on Exception catch (e) {
                    Navigator.of(context).pop();
                    CustomSnackBar.showError(e.toString());
                  }
                },
                buttonText: 'ترقية الحساب',
                buttonHeight: Utils.screenHeight * 0.08,
                buttonWidth: Utils.screenWidth * 0.33,
              ),
            ),
          ],
        );
      },
    );
  }
}
