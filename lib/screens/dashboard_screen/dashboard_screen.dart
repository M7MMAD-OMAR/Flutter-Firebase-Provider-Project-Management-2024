import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/userController.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/dashboard_tab_screens/overview_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/dashboard_tab_screens/productivity_screen.dart';
import 'package:project_management_muhmad_omar/services/auth_service.dart';
import 'package:project_management_muhmad_omar/services/notifications/notification_service.dart';
import 'package:project_management_muhmad_omar/widgets/buttons/primary_tab_buttons_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/dasboard_header_widget.dart';

import '../profile/profile_overview_screen.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  // final ValueNotifier<bool> _totalTaskTrigger = ValueNotifier(true);
  // final ValueNotifier<bool> _totalDueTrigger = ValueNotifier(false);
  // final ValueNotifier<bool> _totalCompletedTrigger = ValueNotifier(true);
  // final ValueNotifier<bool> _workingOnTrigger = ValueNotifier(false);
  final ValueNotifier<int> _buttonTrigger = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardNav(
                image: "assets/man-head.png",
                notificationCount: "2",
                page: Container(),
                title: 'لوحة التحكم',
                onImageTapped: () async {
                  bool fcmStutas =
                      await FcmNotifications.getNotificationStatus();
                  Get.to(() => ProfileOverview(
                        isSelected: fcmStutas,
                      ));
                },
              ),
              AppSpaces.verticalSpace20,
              StreamBuilder<DocumentSnapshot<UserModel>>(
                  stream: UserController().getUserByIdStream(
                      id: AuthProvider.instance.firebaseAuth.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    return Text(
                      "مرحبا   ,\n ${snapshot.data!.data()!.name} 👋",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: Utils.screenWidth * 0.09,
                          fontWeight: FontWeight.bold),
                    );
                  }),
              AppSpaces.verticalSpace20,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //tab indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PrimaryTabButton(
                          buttonText: 'نظرة عامة',
                          itemIndex: 0,
                          notifier: _buttonTrigger),
                      PrimaryTabButton(
                          buttonText: 'الإنتاجية',
                          itemIndex: 1,
                          notifier: _buttonTrigger)
                    ],
                  ),
                ],
              ),
              AppSpaces.verticalSpace20,
              ValueListenableBuilder(
                valueListenable: _buttonTrigger,
                builder: (BuildContext context, _, __) {
                  return _buttonTrigger.value == 0
                      ? const DashboardOverview()
                      : const DashboardProductivity();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
