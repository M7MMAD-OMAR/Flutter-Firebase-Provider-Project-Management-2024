import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/constants.dart';
import '../../constants/values/values.dart';
import '../../controllers/user_controller.dart';
import '../../models/User/User_model.dart';
import '../../services/auth_service.dart';
import '../../widgets/Buttons/primary_tab_buttons.dart';

// ignore: must_be_immutable
class Dashboard extends StatelessWidget {
  Dashboard({super.key});

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
              // TODO
              // DashboardNav(
              //   image: "assets/man-head.png",
              //   notificationCount: "2",
              //   page: Container(),
              //   title: Constants.dashboard_key.tr,
              //   onImageTapped: () async {
              //     bool fcmStutas =
              //         await FcmNotifications.getNotificationStatus();
              //     Get.to(() => ProfileOverview(
              //           isSelected: fcmStutas,
              //         ));
              //     print(AuthService.instance.firebaseAuth.currentUser!.email);
              //   },
              // ),
              AppSpaces.verticalSpace20,
              StreamBuilder<DocumentSnapshot<UserModel>>(
                  stream: UserController().getUserByIdStream(
                      id: AuthService.instance.firebaseAuth.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    return Text(
                      "${Constants.hello_n_key.tr}  ,\n ${snapshot.data!.data()!.name} 👋",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: Utils.screenWidth * 0.12,
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
                          buttonText: Constants.overview_key.tr,
                          itemIndex: 0,
                          notifier: _buttonTrigger),
                      PrimaryTabButton(
                          buttonText: Constants.productivity_key.tr,
                          itemIndex: 1,
                          notifier: _buttonTrigger)
                    ],
                  ),
                ],
              ),
              AppSpaces.verticalSpace20,
              // TODO
              // ValueListenableBuilder(
              //   valueListenable: _buttonTrigger,
              //   builder: (BuildContext context, _, __) {
              //     return _buttonTrigger.value == 0
              //         ? DashboardOverview()
              //         : const DashboardProductivity();
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}
