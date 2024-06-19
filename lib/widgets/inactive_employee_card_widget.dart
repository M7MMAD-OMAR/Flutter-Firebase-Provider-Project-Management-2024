import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/providers/projects/add_user_to_team_provider.dart';
// ignore: unused_import
import 'package:project_management_muhmad_omar/widgets/Dashboard/dashboard_meeting_details_widget.dart';
import 'package:provider/provider.dart';

import 'dummy/profile_dummy_widget.dart';

class InactiveEmployeeCardWidget extends StatefulWidget {
  final String userName;
  final String userImage;
  final ValueNotifier<bool>? notifier;
  final String bio;
  final Color? color;
  final UserModel? user;
  final VoidCallback? onTap;

  const InactiveEmployeeCardWidget(
      {super.key,
      this.user,
      required this.onTap,
      required this.userName,
      required this.color,
      required this.userImage,
      required this.bio,
      this.notifier});

  @override
  State<InactiveEmployeeCardWidget> createState() =>
      _InactiveEmployeeCardWidgetState();
}

class _InactiveEmployeeCardWidgetState
    extends State<InactiveEmployeeCardWidget> {
  late DashboardMeetingDetailsProvider addWatingMemberController;

  @override
  void initState() {
    super.initState();
    // تأكد من أن هذه الوظيفة تستدعى بعد بناء الـ Widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        addWatingMemberController =
            Provider.of<DashboardMeetingDetailsProvider>(context,
                listen: false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: AppColors.primaryBackgroundColor,
            // border: Border.all(color: AppColors.primaryBackgroundColor, width: 4),
            borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          ProfileDummy(
            imageType: ImageType.Network,
            dummyType: ProfileDummyType.Image,
            scale: 1.2,
            color: widget.color,
            image: widget.userImage,
          ),
          AppSpaces.horizontalSpace20,
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.userName,
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.4)),
                Text(widget.bio,
                    style: GoogleFonts.lato(color: HexColor.fromHex("5A5E6D")))
              ])
        ]),
      ),
    );
  }
}
