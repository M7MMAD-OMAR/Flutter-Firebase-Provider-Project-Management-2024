import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/widgets/dummy/profile_dummy_widget.dart';

class CustomSnackBar {
  static void showSuccess(String message) {
    final BuildContext context = navigatorKey.currentContext!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.greenAccent.withOpacity(.65),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showError(String message) {
    final BuildContext context = navigatorKey.currentContext!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("خطأ: $message ... يرجى المحاولة مرة أخرى"),
        backgroundColor: Colors.red.withOpacity(.65),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class CustomDialog {
  static void showPasswordDialog(BuildContext context) {
    final TextEditingController passController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String password = "";
    RegExp regExletters = RegExp(r"(?=.*[a-z])\w+");
    RegExp regExnumbers = RegExp(r"(?=.*[0-9])\w+");
    RegExp regExbigletters = RegExp(r"(?=.*[A-Z])\w+");
    bool obscureText = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryBackgroundColor,
          title: const Text(
            'أدخل كلمة المرور الجديدة',
            style: TextStyle(color: Colors.white),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value.length < 8) {
                      return 'يجب أن تحتوي كلمة المرور على أكثر من 7 أحرف';
                    }
                    if (!regExletters.hasMatch(value)) {
                      return 'يرجى إدخال حرف صغير واحد على الأقل';
                    }
                    if (!regExnumbers.hasMatch(value)) {
                      return 'الرجاء إدخال رقم واحد على الأقل';
                    }
                    if (!regExbigletters.hasMatch(value)) {
                      return 'الرجاء إدخال حرف كبير واحد على الأقل';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: obscureText,
                  controller: passController,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الخاصة بك',
                    labelStyle: const TextStyle(color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        obscureText = !obscureText;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  if (formKey.currentState!.validate()) {
                    showDialogMethod(context);
                    var updatePassword =
                        AuthProvider().updatePassword(newPassword: password);
                    updatePassword.fold(
                      (left) {
                        Navigator.of(context).pop();
                        CustomSnackBar.showError(left.toString());
                      },
                      (right) {
                        Navigator.of(context).pop();
                        CustomSnackBar.showSuccess(
                            'تم تحديث كلمة المرور بنجاح');
                      },
                    );
                  }
                } on Exception catch (e) {
                  Navigator.of(context).pop();
                  CustomSnackBar.showError(e.toString());
                }
              },
              child: const Text('تغيير كلمة المرور'),
            ),
          ],
        );
      },
    );
  }

  static void userInfoDialog({
    required String imageUrl,
    required String name,
    required String userName,
    String? title,
    String? bio,
  }) {
    final BuildContext context = navigatorKey.currentContext!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          backgroundColor: AppColors.primaryBackgroundColor.withOpacity(.8),
          title: title != null
              ? Text(title, style: const TextStyle(color: Colors.grey))
              : null,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileDummy(
                color: Colors.white,
                scale: 2.5,
                dummyType: ProfileDummyType.Image,
                imageType: ImageType.Network,
                image: imageUrl,
                //'assets/dummy-profile.png',
              ),
              Text(name, style: AppTextStyles.header2),
              AppSpaces.verticalSpace20,
              Row(
                children: [
                  AppSpaces.horizontalSpace20,
                  Expanded(
                    child: Text(
                      bio ?? 'سيرة ذاتية فارغة',
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  AppSpaces.horizontalSpace20,
                ],
              ),
              AppSpaces.verticalSpace10,
              Row(
                children: [
                  AppSpaces.horizontalSpace20,
                  Text(
                    "# $userName",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              AppSpaces.verticalSpace10,
              const Row(
                children: [
                  AppSpaces.horizontalSpace20,
                  Text(
                    " اسم المستخدم",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }

  static void showConfirmDeleteDialog({
    required Widget content,
    required VoidCallback onDelete,
  }) {
    final BuildContext context = navigatorKey.currentContext!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "هل أنت متأكد من رغبتك في حذف هذه المهمة؟",
            style: TextStyle(color: Colors.redAccent),
          ),
          content: content,
          actions: [
            ClipOval(
              child: MaterialButton(
                color: Colors.white.withOpacity(.5),
                onPressed: onDelete,
                child: const Text(
                  "حذف",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            ClipOval(
              child: MaterialButton(
                color: Colors.white.withOpacity(.5),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text(
                  "إلغاء",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
