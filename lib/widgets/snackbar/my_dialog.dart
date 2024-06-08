import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/constants.dart';
import '../../constants/values/values.dart';
import '../../services/auth_service.dart';
import '../Forms/form_input_with _label.dart';
import '../buttons/my_primary_buttons.dart';
import '../dummy/profile_dummy.dart';
import 'my_snackber.dart';

class MyDialog {
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
        title: Constants.enter_new_password_key.tr,
        titleStyle: const TextStyle(color: Colors.white),
        content: Form(
          key: formKey,
          child: Column(
            children: [
              LabelledFormInput(
                  validator: (value) {
                    if (value!.isEmpty || value.length < 8) {
                      return Constants
                          .the_password_should_be_more_then_7_character_key.tr;
                    }
                    if (regExletters.hasMatch(value) == false) {
                      return Constants
                          .please_enter_at_least_one_small_character_key.tr;
                    }
                    if (regExnumbers.hasMatch(value) == false) {
                      return Constants.please_enter_at_least_one_number_key.tr;
                    }
                    if (regExbigletters.hasMatch(value) == false) {
                      return Constants
                          .please_enter_at_least_one_big_character_key.tr;
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
                  placeholder: Constants.password_key.tr,
                  keyboardType: "text",
                  controller: passController.value,
                  obscureText: obscureText.value,
                  label: Constants.your_password_key.tr),
              const SizedBox(height: 15),
            ],
          ),
        ),
        cancel: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: MyAppPrimaryButton(
              callback: () async {
                try {
                  if (formKey.currentState!.validate()) {
                    showDialogMethod(context);
                    var updatePassword = AuthService.instance
                        .updatePassword(newPassword: password);
                    updatePassword.fold((left) {
                      Navigator.of(context).pop();

                      MySnackBar.showError(left.toString());
                    }, (right) {
                      Navigator.of(context).pop();
                      //dev.log("Password Updated ");
                      MySnackBar.showSuccess(
                          Constants.password_updated_successfully_key.tr);
                      Get.back();
                    });
                  }
                } on Exception catch (e) {
                  Navigator.of(context).pop();

                  MySnackBar.showError(e.toString());
                }
              },
              buttonText: Constants.change_password_key.tr,
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
                  bio ?? Constants.empty_bio_key.tr,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              AppSpaces.horizontalSpace20,
            ],
          ),
          AppSpaces.verticalSpace10,

          Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpaces.horizontalSpace20,
              Text(
                Constants.bio_key.tr,
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold),
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

          Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpaces.horizontalSpace20,
              Text(
                " ${Constants.user_name_key.tr}",
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold),
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
            Get.back(); // Close the dialog
          },
          child: Text(Constants.close_key.tr),
        ),
      ],
    );
  }

  static void showConfirmDeleteDialog(
      {required Text content, required VoidCallback onDelete}) {
    Get.defaultDialog(
        backgroundColor: Colors.white,
        title: Constants.confirm_delete_key.tr,
        titleStyle: const TextStyle(color: Colors.redAccent),
        content: content,
        textConfirm: Constants.delete_key.tr,
        textCancel: Constants.cancel_key.tr,
        confirmTextColor: Colors.white.withOpacity(.5),
        confirm: ClipOval(
          child: MaterialButton(
            color: Colors.white.withOpacity(.5),
            onPressed: onDelete,
            child: Text(
              Constants.cancel_key.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        radius: 10,
        cancel: ClipOval(
          child: MaterialButton(
            color: Colors.white.withOpacity(.5),
            onPressed: () {
              // Perform delete operation
              // ...

              Get.back();
            },
            child: Text(
              Constants.cancel_key.tr,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ));
  }
}
