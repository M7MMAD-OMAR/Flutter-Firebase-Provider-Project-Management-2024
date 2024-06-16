import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/app_constans.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';

import '../../Screens/Profile/edit_profile_screen.dart';
import '../Profile/text_outlined_button_widget.dart';
import '../dummy/profile_dummy_widget.dart';
import 'back_button.dart';
  
class DefaultNav extends StatelessWidget {
  final String title;
  final UserModel userModel;
  final ProfileDummyType? type;
  const DefaultNav(
      {Key? key, this.type, required this.title, required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const AppBackButton(),
      Text(title,
          style: GoogleFonts.lato(
              fontSize: Utils.screenWidth * 0.07,
              color: Colors.white,
              fontWeight: FontWeight.bold)),
      Builder(builder: (context) {
        if (type == ProfileDummyType.Icon) {
          return ProfileDummy(
              imageType: ImageType.Assets,
              color: HexColor.fromHex("93F0F0"),
              dummyType: ProfileDummyType.Image,
              image: "assets/man-head.png",
              scale: 1.2);
        } else if (type == ProfileDummyType.Image) {
          return ProfileDummy(
              imageType: ImageType.Assets,
              color: HexColor.fromHex("9F69F9"),
              dummyType: ProfileDummyType.Icon,
              scale: 1.0);
        } else if (type == ProfileDummyType.Button) {
          return OutlinedButtonWithText(
            width: 75,
            content: AppConstants.edit_key.tr,
            onPressed: () {
              Get.to(() => EditProfilePage(
                    user: userModel,
                  ));
            },
          );
        } else {
          return Container();
        }
      }),
    ]);
  }
}
