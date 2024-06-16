import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';

import '../dummy/profile_dummy_widget.dart';

class InactiveEmployeeCardSubTask extends StatelessWidget {
  final String userName;
  final String userImage;
  final ValueNotifier<bool>? notifier;
  final String bio;
  final Color? color;
  final UserModel? user;
  final VoidCallback? onTap;
  bool showicon;
  InactiveEmployeeCardSubTask(
      {Key? key,
      this.user,
      required this.onTap,
      required this.userName,
      required this.color,
      required this.userImage,
      required this.bio,
      this.showicon = false,
      this.notifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: AppColors.primaryBackgroundColor,
            // border: Border.all(color: AppColors.primaryBackgroundColor, width: 4),
            borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            showicon
                ? ProfileDummy(
                    imageType: ImageType.Assets,
                    dummyType: ProfileDummyType.Icon,
                    scale: 1.2,
                    color: color,
                    image: userImage,
                  )
                : ProfileDummy(
                    imageType: ImageType.Network,
                    dummyType: ProfileDummyType.Image,
                    scale: 1.2,
                    color: color,
                    image: userImage,
                  ),
            AppSpaces.horizontalSpace20,
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName,
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.4)),
                  Text(bio,
                      style:
                          GoogleFonts.lato(color: HexColor.fromHex("5A5E6D")))
                ])
          ]),
        ),
      ),
    );
  }
}
