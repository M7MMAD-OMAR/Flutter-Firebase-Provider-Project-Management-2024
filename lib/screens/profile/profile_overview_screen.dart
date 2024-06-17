import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/app_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/languageController.dart';
import 'package:project_management_muhmad_omar/controllers/userController.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/timeline_screen.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/onboarding_carousel_screen.dart';
import 'package:project_management_muhmad_omar/screens/profile/my_profile_screen.dart';
import 'package:project_management_muhmad_omar/services/auth_service.dart';
import 'package:project_management_muhmad_omar/services/notifications/notification_service.dart';
import 'package:project_management_muhmad_omar/widgets/buttons/primary_buttons_widget.dart';
import 'package:project_management_muhmad_omar/widgets/buttons/progress_card_close_button_widget.dart';
import 'package:project_management_muhmad_omar/widgets/container_label_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dummy/profile_dummy_widget.dart';
import 'package:project_management_muhmad_omar/widgets/forms/form_input_with_label_widget.dart';
import 'package:project_management_muhmad_omar/widgets/profile/box_widget.dart';
import 'package:project_management_muhmad_omar/widgets/profile/text_outlined_button_widget.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';

class ProfileOverview extends StatefulWidget {
  ProfileOverview({super.key, required this.isSelected});
  late bool isSelected;

  @override
  State<ProfileOverview> createState() => _ProfileOverviewState();
}

class _ProfileOverviewState extends State<ProfileOverview> {
  ProfileOverviewController profileOverviewController =
      Get.put(ProfileOverviewController(), permanent: true);

  Future<void> setvalue() async {
    profileOverviewController.isSelected.value =
        await FcmNotifications.getNotificationStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      DarkRadialBackground(
        color: HexColor.fromHex("#181a1f"),
        position: "topLeft",
      ),
      Padding(
        padding: EdgeInsets.only(
          left: Utils.screenWidth * 0.05, // Adjust the percentage as needed
          right: Utils.screenWidth * 0.04,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<DocumentSnapshot<UserModel>>(
                    stream: UserController().getUserByIdStream(
                        id: AuthProvider
                            .instance.firebaseAuth.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: ProfileDummy(
                                imageType: ImageType.Network,
                                color: HexColor.fromHex("0000"),
                                dummyType: ProfileDummyType.Image,
                                scale: 3.0,
                                image: snapshot.data!.data()!.imageUrl),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${snapshot.data!.data()!.name} ",
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: Utils.screenWidth * 0.1,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            AuthProvider.instance.firebaseAuth.currentUser!
                                    .isAnonymous
                                ? 'تسجيل الدخول بشكل مجهول'
                                : snapshot.data!.data()!.email!,
                            style: GoogleFonts.lato(
                              color: HexColor.fromHex("B0FFE1"),
                              fontSize: Utils.screenWidth * 0.045,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: OutlinedButtonWithText(
                              width: 150,
                              content: 'الملف الشخصي',
                              onPressed: () {
                                Get.to(() => MyProfileScreen(
                                    user: snapshot.data!.data()!));
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                GetBuilder<ProfileOverviewController>(
                  init: ProfileOverviewController(),
                  builder: (controller) {
                    return ListTile(
                      leading: Icon(
                        controller.isSelected.value
                            ? FontAwesomeIcons.bellSlash
                            : FontAwesomeIcons.bell,
                        color: Colors.yellowAccent.shade200,
                        size: Utils.screenWidth * 0.1,
                      ),
                      title: Text(
                        'استقبال الإشعارات',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Utils.screenWidth * 0.06),
                      ),
                      style: ListTileStyle.drawer,
                      // trailing: GlowSwitch(
                      //   onChanged: (value) async {
                      //     controller.isSelected.value =
                      //         await FcmNotifications.getNotificationStatus();
                      //
                      //     await FcmNotifications.setNotificationStatus(
                      //         !controller.isSelected.value);
                      //     controller.update();
                      //
                      //
                      //
                      //   },
                      //   value: !controller.isSelected.value,
                      //   activeColor: Colors.blueAccent.withOpacity(0.6),
                      //   blurRadius: 4,
                      // ),
                    );
                  },
                ),
                AppSpaces.verticalSpace20,
                ContainerLabel(label: 'اختار اللغة'),
                AppSpaces.verticalSpace10,
                GetBuilder<LocalizationController>(
                    builder: (localizationController) {
                  return Row(children: [
                    Expanded(
                        flex: 1,
                        child: Box(
                          callback: () {
                            localizationController.setLanguage(
                                locale: Locale(
                              AppConstants.languages[0].languageCode,
                              AppConstants.languages[0].countryCode,
                            ));
                            localizationController.setSelectIndex(index: 0);
                          },
                          iconColor: Colors.white,
                          iconpath: "assets/icon/arabic.png",
                          label: 'العربية',
                          value: "3",
                          badgeColor: "FFDE72",
                        )),
                    AppSpaces.horizontalSpace10,
                    Expanded(
                        flex: 1,
                        child: Box(
                          callback: () {
                            localizationController.setLanguage(
                                locale: Locale(
                              AppConstants.languages[1].languageCode,
                              AppConstants.languages[1].countryCode,
                            ));
                            localizationController.setSelectIndex(index: 1);
                          },
                          iconColor: null,
                          iconpath: "assets/icon/english.png",
                          label: "English",
                          value: "3",
                          badgeColor: "FFDE72",
                        ))
                  ]);
                }),
                AppSpaces.verticalSpace20,
                Visibility(
                    visible: AuthProvider
                        .instance.firebaseAuth.currentUser!.isAnonymous,
                    child: ContainerLabel(
                      label: 'ترقية الحساب',
                    )),
                AppSpaces.verticalSpace10,
                Visibility(
                  visible: AuthProvider
                      .instance.firebaseAuth.currentUser!.isAnonymous,
                  child: Row(children: [
                    Expanded(
                        flex: 1,
                        child: Box(
                          callback: () async {
                            try {
                              showDialogMethod(context);
                              await AuthProvider.instance
                                  .convertAnonymousToGoogle();
                              Navigator.of(context).pop();
                              //  CustomSnackBar.showSuccess("its going good");
                              Get.to(() => const Timeline());
                            } on Exception catch (e) {
                              Navigator.of(context).pop();
                              CustomSnackBar.showError(e.toString());
                            }
                          },
                          iconColor: null,
                          iconpath: "lib/images/google2.png",
                          label: 'جوجل',
                          value: "3",
                          badgeColor: "FFDE72",
                        )),
                    AppSpaces.horizontalSpace10,
                    Expanded(
                        flex: 1,
                        child: Box(
                          callback: () {
                            showPasswordAndEmailDialog(context);
                          },
                          iconColor: null,
                          iconpath: "assets/icon/envelope.png",
                          label: ' البريد ',
                          value: "3",
                          badgeColor: "FFDE72",
                        ))
                  ]),
                ),
                AppSpaces.verticalSpace20,
                GestureDetector(
                  onTap: () async {
                    Get.offAll(() => const OnboardingCarousel());
                    await AuthProvider.instance.logOut();
                  },
                  child: Container(
                    width: double.infinity,
                    height: Utils.screenHeight *
                        0.15, // Adjust the percentage as needed

                    decoration: BoxDecoration(
                        color: HexColor.fromHex("FF968E"),
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text('تسجيل خروج',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: Utils.screenWidth * 0.07,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      Positioned(
          top: 50,
          left: 20,
          child: Transform.scale(
              scale: 1.2,
              child: ProgressCardCloseButton(onPressed: () {
                Get.back();
              })))
    ]));
  }
}

class ProfileOverviewController extends GetxController {
  var isSelected = true.obs; // Use RxBool to make it observable
}

void showPasswordAndEmailDialog(BuildContext context) {
  final Rx<TextEditingController> passController = TextEditingController().obs;
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String password = "";
  String email = "";
  RegExp regExletters = RegExp(r"(?=.*[a-z])\w+");
  RegExp regExnumbers = RegExp(r"(?=.*[0-9])\w+");
  RegExp regExbigletters = RegExp(r"(?=.*[A-Z])\w+");
  final RxBool obscureText = false.obs;
  Get.defaultDialog(
      backgroundColor: AppColors.primaryBackgroundColor,
      title: 'ادخل كلمة السر & البريد الإلكتروني',
      titleStyle: const TextStyle(color: Colors.white),
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
                  emailController.value.text = "";
                },
                onChanged: (value) {
                  email = value;
                },
                readOnly: false,
                placeholder: ' البريد ',
                keyboardType: "text",
                controller: emailController.value,
                obscureText: obscureText.value,
                label: 'بريدك الإلكتروني'),
            AppSpaces.verticalSpace20,
            LabelledFormInput(
                validator: (value) {
                  if (value!.isEmpty) {
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
                  await AuthProvider.instance
                      .convertAnonymousToEmailandPassword(
                          email: email, password: password);
                  Navigator.of(context).pop();
                  Get.back();
                  Get.offAll(() => const OnboardingCarousel());
                  //اخر شي عدلتو وماجربتو
                  await AuthProvider.instance.logOut();
                }
              } on Exception catch (e) {
                Navigator.of(context).pop();
                CustomSnackBar.showError(e.toString());
              }
            },
            buttonText: 'ترقية الحساب',
            buttonHeight:
                Utils.screenHeight * 0.1, // Adjust the percentage as needed
            buttonWidth: Utils.screenWidth * 0.33),
      ));
}
