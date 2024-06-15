import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/controllers/languageController.dart';
import 'package:project_management_muhmad_omar/controllers/userController.dart';
import 'package:project_management_muhmad_omar/models/User/User_model.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/timeline_screen.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/onboarding_carousel_screen.dart';
import 'package:project_management_muhmad_omar/services/auth_service.dart';
import 'package:project_management_muhmad_omar/services/notification_service.dart';
import 'package:project_management_muhmad_omar/widgets/Buttons/primary_buttons_widget.dart';

import 'package:project_management_muhmad_omar/constants/values.dart';
// import 'package:flutter_glow/flutter_glow.dart';
import '../../constants/app_constans.dart';
import '../../widgets/Buttons/progress_card_close_button_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import '../../widgets/Forms/form_input_with _label_widget.dart';
import '../../widgets/Profile/box_widget.dart';
import '../../widgets/Profile/text_outlined_button_widget.dart';
import '../../widgets/Snackbar/custom_snackber_widget.dart';
import '../../widgets/container_label_widget.dart';
import '../../widgets/dummy/profile_dummy_widget.dart';
import 'my_profile_screen.dart';

class ProfileOverview extends StatefulWidget {
  ProfileOverview({Key? key, required this.isSelected}) : super(key: key);
  late bool isSelected;

  @override
  State<ProfileOverview> createState() => _ProfileOverviewState();
}

class _ProfileOverviewState extends State<ProfileOverview> {
  @override
  void initState() {
    setvalue();
    // TODO: implement initState
    super.initState();
  }

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
                        id: AuthService.instance.firebaseAuth.currentUser!.uid),
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
                            AuthService.instance.firebaseAuth.currentUser!
                                    .isAnonymous
                                ? AppConstants.sign_in_anonmouslly_key.tr
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
                              content: AppConstants.view_profile_key.tr,
                              onPressed: () {
                                Get.to(() =>
                                    ProfilePage(user: snapshot.data!.data()!));
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
                        AppConstants.receive_notification_key.tr,
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
                ContainerLabel(label: AppConstants.select_language_key.tr),
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
                          label: AppConstants.arabic_key.tr,
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
                    visible: AuthService
                        .instance.firebaseAuth.currentUser!.isAnonymous,
                    child: ContainerLabel(
                      label: AppConstants.make_an_account_by_key.tr,
                    )),
                AppSpaces.verticalSpace10,
                Visibility(
                  visible: AuthService
                      .instance.firebaseAuth.currentUser!.isAnonymous,
                  child: Row(children: [
                    Expanded(
                        flex: 1,
                        child: Box(
                          callback: () async {
                            try {
                              showDialogMethod(context);
                              await AuthService.instance
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
                          label: AppConstants.google_key.tr,
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
                          label: AppConstants.email_key.tr,
                          value: "3",
                          badgeColor: "FFDE72",
                        ))
                  ]),
                ),
                AppSpaces.verticalSpace20,
                GestureDetector(
                  onTap: () async {
                    Get.offAll(() => const OnboardingCarousel());
                    await AuthService.instance.logOut();
                  },
                  child: Container(
                    width: double.infinity,
                    height: Utils.screenHeight *
                        0.15, // Adjust the percentage as needed

                    decoration: BoxDecoration(
                            color: HexColor.fromHex("FF968E"),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(AppConstants.log_out_key.tr,
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
      title: AppConstants.enter_email_password_key.tr,
      titleStyle: const TextStyle(color: Colors.white),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            LabelledFormInput(
                autovalidateMode: AutovalidateMode.disabled,
                validator: (value) {
                  if (!EmailValidator.validate(value!)) {
                    return AppConstants.enter_valid_email_key.tr;
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
                placeholder: AppConstants.email_key.tr,
                keyboardType: "text",
                controller: emailController.value,
                obscureText: obscureText.value,
                label: AppConstants.your_email_key.tr),
            AppSpaces.verticalSpace20,
            LabelledFormInput(
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppConstants
                        .the_password_should_be_more_then_7_character_key.tr;
                  }
                  if (regExletters.hasMatch(value) == false) {
                    return AppConstants
                        .please_enter_at_least_one_small_character_key.tr;
                  }
                  if (regExnumbers.hasMatch(value) == false) {
                    return AppConstants.please_enter_at_least_one_number_key.tr;
                  }
                  if (regExbigletters.hasMatch(value) == false) {
                    return AppConstants
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
                placeholder: AppConstants.password_key.tr,
                keyboardType: "text",
                controller: passController.value,
                obscureText: obscureText.value,
                label: AppConstants.your_password_key.tr),
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
                  await AuthService.instance.convertAnonymousToEmailandPassword(
                      email: email, password: password);
                  Navigator.of(context).pop();
                  Get.back();
                  Get.offAll(() => const OnboardingCarousel());
                  //اخر شي عدلتو وماجربتو
                  await AuthService.instance.logOut();
                }
              } on Exception catch (e) {
                Navigator.of(context).pop();
                CustomSnackBar.showError(e.toString());
              }
            },
            buttonText: AppConstants.upgrade_account_key.tr,
            buttonHeight:
                Utils.screenHeight * 0.1, // Adjust the percentage as needed
            buttonWidth: Utils.screenWidth * 0.33),
      ));
}
