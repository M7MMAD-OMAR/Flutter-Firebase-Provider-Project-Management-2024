import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/widgets/buttons/primary_buttons_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dummy/profile_dummy_widget.dart';

import '../forms/form_input_with_label_widget.dart';

class CustomSnackBar {
  static void showSuccess(String message) {
    Get.snackbar(
      boxShadows: [
        BoxShadow(
          blurStyle: BlurStyle.outer,
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 4),
        ),
      ],
      " تم بنجاح ",
      message,
      backgroundColor: Colors.greenAccent.withOpacity(.65),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  static void showError(String message) {
    Get.snackbar(
      boxShadows: [
        BoxShadow(
          blurStyle: BlurStyle.outer,
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 4),
        ),
      ],
      "خطأ",
      " $message ......يرجى المحاولة مرة أخرى ",
      // "خطأ",
      // //'Error',
      // "${AppConstants.SomeThing_Wrong_happened_key.tr} \n  $message ${AppConstants.please_Try_Again_key.tr} ",
      duration: const Duration(seconds: 20),
      backgroundColor: Colors.red.withOpacity(.65),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}

class CustomDialog {
  static void showPasswordDialog(BuildContext context) {
    final Rx<TextEditingController> passController =
        TextEditingController().obs;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String password = "";
    RegExp regExletters = RegExp(r"(?=.*[a-z])\w+");
    RegExp regExnumbers = RegExp(r"(?=.*[0-9])\w+");
    RegExp regExbigletters = RegExp(r"(?=.*[A-Z])\w+");
    final RxBool obscureText = false.obs;
    Get.defaultDialog(
        backgroundColor: AppColors.primaryBackgroundColor,
        title: 'أدخل كلمة المرور الجديدة',
        titleStyle: const TextStyle(color: Colors.white),
        content: Form(
          key: formKey,
          child: Column(
            children: [
              LabelledFormInput(
                  validator: (value) {
                    if (value!.isEmpty || value.length < 8) {
                      return 'يجب أن تحتوي كلمة المرور على أكثر من 7 أحرف';
                    }
                    if (regExletters.hasMatch(value) == false) {
                      return 'يرجى إدخال حرف صغير واحد على الأقل';
                    }
                    if (regExnumbers.hasMatch(value) == false) {
                      return 'الرجاء إدخال رقم واحد على الأقل';
                    }
                    if (regExbigletters.hasMatch(value) == false) {
                      return 'الرجاء إدخال حرف كبير واحد على الأقل';
                    }
                    return null;
                  },
                  onClear: (() {
                    obscureText.value = !obscureText.value;
                  }),
                  onChanged: (value) {
                    password = value;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  readOnly: false,
                  placeholder: 'كلمة المرور',
                  keyboardType: "text",
                  controller: passController.value,
                  obscureText: obscureText.value,
                  label: 'كلمة المرور الخاصة بك'),
              const SizedBox(height: 15),
            ],
          ),
        ),
        cancel: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: AppPrimaryButton(
              callback: () async {
                try {
                  if (formKey.currentState!.validate()) {
                    showDialogMethod(context);
                    var updatePassword =
                        AuthProvider().updatePassword(newPassword: password);
                    updatePassword.fold((left) {
                      Navigator.of(context).pop();

                      CustomSnackBar.showError(left.toString());
                    }, (right) {
                      Navigator.of(context).pop();
                      CustomSnackBar.showSuccess('تم تحديث كلمة المرور بنجاح');
                      Navigator.pop(context);
                    });
                  }
                } on Exception catch (e) {
                  Navigator.of(context).pop();

                  CustomSnackBar.showError(e.toString());
                }
              },
              buttonText: 'تغيير كلمة المرور',
              buttonHeight: 50,
              buttonWidth: 110),
        ));
  }

  static void userInfoDialog(
      {required String imageUrl,
      required String name,
      required String userName,
      String? title,
      String? bio}) {
    Get.defaultDialog(
      radius: 50,
      backgroundColor: AppColors.primaryBackgroundColor.withOpacity(.8),
      contentPadding: const EdgeInsets.all(0),
      titleStyle: const TextStyle(color: Colors.grey),
      titlePadding: title == null
          ? const EdgeInsets.all(0)
          : const EdgeInsets.symmetric(vertical: 5),
      title: title ?? "",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileDummy(
              color: Colors.white,
              scale: 2.5,
              dummyType: ProfileDummyType.Image,
              imageType: ImageType.Network,
              image: imageUrl
              //'assets/dummy-profile.png',
              ),
          Text(name, style: AppTextStyles.header2),
          AppSpaces.verticalSpace20,
          Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpaces.horizontalSpace20,
              Expanded(
                child: Text(
                  overflow: TextOverflow.clip,
                  bio ?? 'سيرة ذاتية فارغة',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              AppSpaces.horizontalSpace20,
            ],
          ),
          AppSpaces.verticalSpace10,

          const Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpaces.horizontalSpace20,
              Text(
                'السيرة الذاتية',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              )
            ],
          ),
          AppSpaces.verticalSpace10,

          Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpaces.horizontalSpace20,
              Text(
                "# $userName",
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
          AppSpaces.verticalSpace10,

          const Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpaces.horizontalSpace20,
              Text(
                " اسم المستخدم",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              )
            ],
          )

          // Add your custom content widgets here
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Handle button action
            Navigator.pop(context); // Close the dialog
          },
          child: Text('إغلاق'),
        ),
      ],
    );
  }

  static void showConfirmDeleteDialog(
      {required Text content, required VoidCallback onDelete}) {
    Get.defaultDialog(
        backgroundColor: Colors.white,
        title: "هل أنت متأكد من رغبتك في حذف هذه المهمة؟",
        titleStyle: const TextStyle(color: Colors.redAccent),
        content: content,
        textConfirm: "حذف",
        textCancel: "إلغاء",
        confirmTextColor: Colors.white.withOpacity(.5),
        confirm: ClipOval(
          child: MaterialButton(
            color: Colors.white.withOpacity(.5),
            onPressed: onDelete,
            child: const Text(
              "إلغاء",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
        radius: 10,
        cancel: ClipOval(
          child: MaterialButton(
            color: Colors.white.withOpacity(.5),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "إلغاء",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ));
  }
}
