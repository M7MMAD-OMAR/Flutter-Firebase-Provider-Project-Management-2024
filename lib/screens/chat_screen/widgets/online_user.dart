import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/screens/chat_screen/messaging_screen.dart';

import 'online_user_profile.dart';

class OnlineUser extends StatelessWidget {
  final String userName;
  final String image;
  final String imageBackground;

  const OnlineUser(
      {super.key,
      required this.userName,
      required this.image,
      required this.imageBackground});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: () {
          Get.to(() => MessagingScreen(
              userName: userName, image: image, color: imageBackground));
        },
        child: Row(children: [
          OnlineUserProfile(
            image: image,
            imageBackground: imageBackground,
          ),
          AppSpaces.horizontalSpace20,
          Text(userName,
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18))
        ]),
      ),
    );
  }
}
