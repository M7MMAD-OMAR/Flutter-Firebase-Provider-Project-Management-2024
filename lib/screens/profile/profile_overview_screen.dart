import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/user_provider.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/providers/profile_overview_provider.dart';
import 'package:project_management_muhmad_omar/routes.dart';
import 'package:project_management_muhmad_omar/screens/profile/my_profile_screen.dart';
import 'package:project_management_muhmad_omar/services/notifications/notification_service.dart';
import 'package:project_management_muhmad_omar/widgets/buttons/progress_card_close_button_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dummy/profile_dummy_widget.dart';
import 'package:project_management_muhmad_omar/widgets/profile/box_widget.dart';
import 'package:project_management_muhmad_omar/widgets/profile/text_outlined_button_widget.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';
import 'package:provider/provider.dart';

class ProfileOverviewScreen extends StatefulWidget {
  ProfileOverviewScreen({super.key, required this.isSelected});

  late bool isSelected;

  @override
  State<ProfileOverviewScreen> createState() => _ProfileOverviewScreenState();
}

class _ProfileOverviewScreenState extends State<ProfileOverviewScreen> {
  late ProfileOverviewProvider profileOverviewController;

  @override
  void initState() {
    profileOverviewController =
        Provider.of<ProfileOverviewProvider>(context, listen: false);
    super.initState();
  }

  Future<void> setvalue() async {
    profileOverviewController.isSelected =
        await FcmNotificationsProvider.getNotificationStatus();
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
          left: Utils.screenWidth * 0.05,
          right: Utils.screenWidth * 0.04,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<DocumentSnapshot<UserModel>>(
                  stream: UserProvider().getUserByIdStream(
                    id: AuthProvider.firebaseAuth.currentUser!.uid,
                  ),
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
                            image: snapshot.data!.data()!.imageUrl,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${snapshot.data!.data()!.name} ",
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: Utils.screenWidth * 0.1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          AuthProvider.firebaseAuth.currentUser!.isAnonymous
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
                            width: 250,
                            content: 'الملف الشخصي',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MyProfileScreen(
                                    user: snapshot.data!.data()!,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Consumer<ProfileOverviewProvider>(
                  builder: (context, provider, child) {
                    return ListTile(
                      leading: Icon(
                        provider.isSelected
                            ? Icons.notifications_off
                            : Icons.notifications,
                        color: provider.isSelected
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        provider.isSelected
                            ? 'تم إيقاف استقبال الإشعارات'
                            : 'يتم استقبال الإشعارات',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Switch(
                        value: provider.isSelected,
                        onChanged: (newValue) {
                          provider.toggleSelection();
                        },
                      ),
                    );
                  },
                ),
                // Visibility(
                //   visible: AuthProvider.firebaseAuth.currentUser!.isAnonymous,
                //   child: const ContainerLabel(
                //     label: 'ترقية الحساب',
                //   ),
                // ),verticalSpace20
                AppSpaces.verticalSpace20,

                Visibility(
                  visible: AuthProvider.firebaseAuth.currentUser!.isAnonymous,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Box(
                          callback: () async {
                            try {
                              showDialogMethod(context);
                              await AuthProvider().convertAnonymousToGoogle();
                              Navigator.of(context).pop();

                              Navigator.pushNamed(
                                context,
                                Routes.timelineScreen,
                              );
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
                        ),
                      ),
                      AppSpaces.verticalSpace10,
                      // Expanded(
                      //   flex: 1,
                      //   child: Box(
                      //     callback: () {
                      //       showPasswordAndEmailDialog(context);
                      //     },
                      //     iconColor: null,
                      //     iconpath: "assets/icon/envelope.png",
                      //     label: ' البريد ',
                      //     value: "3",
                      //     badgeColor: "FFDE72",
                      //   ),
                      // ),
                    ],
                  ),
                ),
                AppSpaces.verticalSpace20,

                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.onboardingCarouselScreen,
                      (Route<dynamic> route) => false,
                    );
                    await AuthProvider().logOut();
                  },
                  child: Container(
                    width: double.infinity,
                    height: Utils.screenHeight * 0.08,
                    decoration: BoxDecoration(
                      color: HexColor.fromHex("FF968E"),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'تسجيل خروج',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: Utils.screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
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
                Navigator.pop(context);
              })))
    ]));
  }
}

