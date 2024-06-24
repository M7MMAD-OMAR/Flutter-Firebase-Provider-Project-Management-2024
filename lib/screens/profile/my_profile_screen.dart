import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/providers/manger_provider.dart';
import 'package:project_management_muhmad_omar/providers/user_provider.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/projects_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/select_my_teams_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/select_team_screen.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dummy/profile_dummy_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/default_back_widget.dart';
import 'package:project_management_muhmad_omar/widgets/profile/profile_text_option_widget.dart';
import 'package:project_management_muhmad_omar/widgets/profile/text_outlined_button_widget.dart';

import 'edit_profile_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key, required this.user});

  final UserModel? user;

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final ValueNotifier<bool> totalTaskNotifier = ValueNotifier(true);
  final String tabSpace = "\t\t";

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
            left: Utils.screenWidth * 0.04, // Adjust the percentage as needed
            right: Utils.screenWidth * 0.04,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DefaultNav(
                      userModel: widget.user!,
                      title: "$tabSpace الملف الشخصي",
                      type: ProfileDummyType.Button),
                  const SizedBox(height: 30),
                  StreamBuilder<DocumentSnapshot<UserModel>>(
                      stream: UserProvider().getUserByIdStream(
                          id: AuthProvider.firebaseAuth.currentUser!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return Column(
                          children: [
                            ProfileDummy(
                                imageType: ImageType.Network,
                                color: HexColor.fromHex("0000"),
                                dummyType: ProfileDummyType.Image,
                                scale: 4.0,
                                image: snapshot.data!.data()!.imageUrl),
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
                              AuthProvider.firebaseAuth.currentUser!.isAnonymous
                                  ? 'تسجيل الدخول بشكل مجهول'
                                  : snapshot.data!.data()!.email!,
                              style: GoogleFonts.lato(
                                color: HexColor.fromHex("B0FFE1"),
                                fontSize: Utils.screenWidth * 0.05,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: OutlinedButtonWithText(
                                  width: 75,
                                  content: 'تعديل',
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => EditProfileScreen(
                                                  user: snapshot.data?.data(),
                                                )));
                                  }),
                            ),
                          ],
                        );
                      }),
                  AppSpaces.verticalSpace20,
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF262A34),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // child: Column(
                        //   children: [
                        //     ToggleLabelOption(
                        //       label: '$tabSpace Show me as away',
                        //       notifierValue: totalTaskNotifier,
                        //       icon: Icons.directions_run_rounded,
                        //       margin: 7.0,
                        //     ),
                        //   ],
                        // ),
                      ),
                      AppSpaces.verticalSpace10,
                      ProfileTextOption(
                        inTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                backgroundColor: HexColor.fromHex("#181a1f"),
                                floatingActionButtonLocation:
                                    FloatingActionButtonLocation.centerFloat,
                                body: const ProjectScreen(),
                              ),
                            ),
                          );
                        },
                        label: '$tabSpace  مشاريعي ',
                        icon: Icons.cast,
                        margin: 5.0,
                      ),
                      AppSpaces.verticalSpace10,
                      ProfileTextOption(
                        inTap: () async {
                          showDialogMethod(context);
                          ManagerModel? userAsManger = await ManagerProvider()
                              .getMangerWhereUserIs(
                                  userId: AuthProvider
                                      .firebaseAuth.currentUser!.uid);
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SelectTeamScreen(
                                      title: 'فرقي',
                                      managerModel: userAsManger)));
                        },
                        label: '$tabSpace فرقي',
                        icon: Icons.group,
                        margin: 5.0,
                      ),
                      AppSpaces.verticalSpace10,
                      ProfileTextOption(
                        inTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SelectMyTeamsScreen(
                                      title: 'إدارة الفرق')));
                        },
                        label: '$tabSpace إدارة الفرق',
                        icon: FeatherIcons.share2,
                        margin: 5.0,
                      ),
                      //AppSpaces.verticalSpace10,
                      // ProfileTextOption(
                      //   inTap: () {
                      //     CustomDialog.userInfoDialog(
                      //       name: widget.user.name!,
                      //       userName: widget.user.userName!,
                      //       imageUrl: widget.user.imageUrl,
                      //       bio: widget.user.bio,
                      //     );
                      //
                      //   },
                      //   label: '$tabSpace ${AppConstants.all_task_key.tr}',
                      //   icon: Icons.check_circle_outline,
                      //   margin: 6.0,
                      // ),
                      AppSpaces.verticalSpace20,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
