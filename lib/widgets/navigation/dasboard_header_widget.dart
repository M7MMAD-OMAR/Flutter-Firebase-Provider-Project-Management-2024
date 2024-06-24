import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/user_provider.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/screens/profile/profile_overview_screen.dart';
import 'package:project_management_muhmad_omar/services/notifications/notification_service.dart';

import '../../providers/auth_provider.dart';
import '../dummy/profile_dummy_widget.dart';

class DashboardNav extends StatelessWidget {
  final String title;
  final String image;

  final StatelessWidget? page;
  final VoidCallback? onImageTapped;
  final String notificationCount;

  const DashboardNav({super.key,
      required this.title,
      required this.image,
      required this.notificationCount,
      this.page,
      this.onImageTapped});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
        child: Text(
          title,
          style: AppTextStyles.header2,
          overflow: TextOverflow.ellipsis, // Add this line to handle overflow
        ),
      ),
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
              bool fcmStutas =
                  await FcmNotificationsProvider.getNotificationStatus();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileOverviewScreen(
                            isSelected: fcmStutas,
                          )));
            },
            child: StreamBuilder<DocumentSnapshot<UserModel>>(
                stream: UserProvider().getUserByIdStream(
                    id: AuthProvider.firebaseAuth.currentUser?.uid ?? ""),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return ProfileDummy(
                    imageType: ImageType.Network,
                    color: Colors.white.withOpacity(0),
                    dummyType: snapshot.data?.data()?.imageUrl == null
                        ? ProfileDummyType.Icon
                        : ProfileDummyType.Image,
                    image: snapshot.data?.data()?.imageUrl ?? "",
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
