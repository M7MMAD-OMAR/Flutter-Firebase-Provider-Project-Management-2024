import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/timeline_screen.dart';

import '../Shapes/roundedborder_with_icon_widget.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({Key? key}) : super(key: key);

// dvd()async{
//      final idtoken = await
//         AuthService.instance.firebaseAuth.currentUser!.getIdTokenResult();

// }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (Navigator.canPop(context)) {
            Get.back();
          } else {
            // User? user=  AuthService.instance.firebaseAuth.currentUser;
            // if (user!=null && !user.isAnonymous) {

            // }
            Get.offAll(() => const TimelineScreen());
          }
        },
        child: const RoundedBorderWithIcon(icon: Icons.arrow_back),
      ),
    );
  }
}
