import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';

import '../../Screens/Profile/profile_overview_screen.dart';
import '../../controllers/userController.dart';
import '../../models/user/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../dummy/profile_dummy_widget.dart';

class DashboardNav extends StatelessWidget {
  final String title;
  final String image;

  final StatelessWidget? page;
  final VoidCallback? onImageTapped;
  final String notificationCount;

  const DashboardNav(
      {Key? key,
      required this.title,
      required this.image,
      required this.notificationCount,
      this.page,
      this.onImageTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: AppTextStyles.header2),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        // InkWell(
        //   onTap: () {
        //     if (page != null) Get.to(() => page!);
        //   },
        //   child: Stack(children: <Widget>[
        //     Icon(icon, color: Colors.white, size: 30),
        //     Positioned(
        //       // draw a red marble
        //       top: 0.0,
        //       right: 0.0,
        //       child: Container(
        //         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        //         decoration: BoxDecoration(
        //             shape: BoxShape.circle, color: HexColor.fromHex("FF9B76")),
        //         alignment: Alignment.center,
        //         child: Text(notificationCount,
        //             style: GoogleFonts.lato(fontSize: 11, color: Colors.white)),
        //       ),
        //     )
        //   ]),
        // ),

        // SizedBox(
        //     width: Utils.screenWidth * 0.08), // Adjust the percentage as needed
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: Utils.screenWidth * 0.05),
        //   child: CircleGradientIcon(
        //     onTap: () {
        //       Get.to(const TodaysTaskScreen());
        //     },
        //     icon: Icons.calendar_month,
        //     color: Colors.purple,
        //     iconSize: 24,
        //     size: 50,
        //   ),
        // ),

        InkWell(
          onTap: onImageTapped,
          child: GestureDetector(
            onTap: () async {
              bool fcmStutas = await FcmNotifications.getNotificationStatus();
              Get.to(() => ProfileOverview(
                    isSelected: fcmStutas,
                  ));
            },
            child: StreamBuilder<DocumentSnapshot<UserModel>>(
                stream: UserController().getUserByIdStream(
                    id: AuthService.instance.firebaseAuth.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return ProfileDummy(
                    imageType: ImageType.Network,
                    color: Colors.white.withOpacity(0),
                    dummyType: ProfileDummyType.Image,
                    image: snapshot.data!.data()!.imageUrl,
                    scale: Utils.screenWidth * 0.004,
                    //scale: 1.2,
                  );
                }),
          ),
        ),
      ])
    ]);
  }
}
