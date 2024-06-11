import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/widgets/Buttons/primary_progress_button.dart';
import 'package:project_management_muhmad_omar/widgets/Navigation/app_header.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background.dart';
import 'package:project_management_muhmad_omar/widgets/dummy/profile_dummy.dart';

import '../../widgets/forms/labelled_form_input_widget.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String tabSpace = "\t\t\t";
    final nameController = TextEditingController();
    final passController = TextEditingController();
    final emailController = TextEditingController();
    final roleController = TextEditingController();
    final aboutController = TextEditingController();
    return Scaffold(
        body: Stack(children: [
      DarkRadialBackground(
        color: HexColor.fromHex("#181a1f"),
        position: "topLeft",
      ),
      Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SafeArea(
              child: SingleChildScrollView(
                  child: Column(children: [
            TaskezAppHeader(
              title: "$tabSpace Edit Profile",
              widget: PrimaryProgressButton(
                width: 80,
                height: 40,
                label: "Done",
                textStyle: GoogleFonts.lato(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
            Stack(
              children: [
                ProfileDummy(
                  color: HexColor.fromHex("94F0F1"),
                  dummyType: ProfileDummyType.Image,
                  scale: 3.0,
                  image: "assets/man-head.png",
                  imageType: ImageType.Assets,
                ),
                Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        color: AppColors.primaryAccentColor.withOpacity(0.75),
                        shape: BoxShape.circle),
                    child: const Icon(FeatherIcons.camera,
                        color: Colors.white, size: 20))
              ],
            ),
            AppSpaces.verticalSpace20,
            LabelledFormInputWidget(
              placeholder: "Blake Gordon",
              keyboardType: "text",
              controller: nameController,
              obscureText: false,
              label: "Your Name",
              autovalidateMode: null,
              readOnly: false,
            ),
            AppSpaces.verticalSpace20,
            LabelledFormInputWidget(
              placeholder: "blake@gmail.com",
              keyboardType: "text",
              controller: emailController,
              obscureText: true,
              label: "Your Email",
              autovalidateMode: null,
              readOnly: false,
            ),
            AppSpaces.verticalSpace20,
            LabelledFormInputWidget(
              placeholder: "HikLHjD@&1?>",
              keyboardType: "text",
              controller: passController,
              obscureText: true,
              label: "Your Password",
              autovalidateMode: null,
              readOnly: false,
            ),
            AppSpaces.verticalSpace20,
            LabelledFormInputWidget(
              placeholder: "Visual Designer",
              keyboardType: "text",
              controller: roleController,
              obscureText: true,
              label: "Role",
              autovalidateMode: null,
              readOnly: false,
            ),
            AppSpaces.verticalSpace20,
            LabelledFormInputWidget(
              placeholder: "Design & Cat Person",
              keyboardType: "text",
              controller: aboutController,
              obscureText: true,
              label: "About Me",
              autovalidateMode: null,
              readOnly: false,
            ),
          ]))))
    ]));
  }
}
