import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';

import '../../screens/profile/edit_profile_screen.dart';
import '../dummy/profile_dummy_widget.dart';
import '../profile/text_outlined_button_widget.dart';
import 'back_button.dart';

class DefaultNav extends StatelessWidget {
  final String title;
  final UserModel userModel;
  final ProfileDummyType? type;

  const DefaultNav(
      {super.key, this.type, required this.title, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const AppBackButtonWidget(),
      Text(title,
          style: GoogleFonts.lato(
              fontSize: Utils.screenWidth * 0.1,
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
            content: 'تعديل',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditProfileScreen(
                            user: userModel,
                          )));
            },
          );
        } else {
          return Container();
        }
      }),
    ]);
  }
}
