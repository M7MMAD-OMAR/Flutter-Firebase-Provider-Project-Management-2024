import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/widgets/dummy/profile_dummy.dart';

class DashboardNav extends StatelessWidget {
  final String title;
  final String image;
  final IconData icon;
  final StatelessWidget? page;
  final VoidCallback? onImageTapped;
  final String notificationCount;

  const DashboardNav(
      {super.key,
      required this.title,
      required this.icon,
      required this.image,
      required this.notificationCount,
      this.page,
      this.onImageTapped});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: AppTextStyles.header2),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        InkWell(
          onTap: () {
            if (page != null) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
            }
          },
          child: Stack(children: <Widget>[
            Icon(icon, color: Colors.white, size: 30),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: HexColor.fromHex("FF9B76")),
                alignment: Alignment.center,
                child: Text(notificationCount,
                    style: GoogleFonts.lato(fontSize: 11, color: Colors.white)),
              ),
            )
          ]),
        ),
        const SizedBox(width: 40),
        InkWell(
          onTap: onImageTapped,
          child: ProfileDummy(
            color: HexColor.fromHex("93F0F0"),
            dummyType: ProfileDummyType.Image,
            image: image,
            scale: 1.2,
            imageType: ImageType.Assets,
          ),
        )
      ])
    ]);
  }
}
