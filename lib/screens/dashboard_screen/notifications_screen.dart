// import 'package:flutter/material.dart';

// import '../../Data/data_model.dart';
// import 'package:project_management_muhmad_omar/constants/values.dart';
// import '../../widgets/Navigation/default_back_widget.dart';
// import '../../widgets/Notification/notification_card.dart';
// import '../../widgets/dummy/profile_dummy_widget.dart';

// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final dynamic notificationData = AppData.notificationMentions;

//     List<Widget> notificationCards = List.generate(
//         notificationData.length,
//         (index) => NotificationCard(
//               read: notificationData[index]['read'],
//               userName: notificationData[index]['mentionedBy'],
//               date: notificationData[index]['date'],
//               image: notificationData[index]['profileImage'],
//               mentioned: notificationData[index]['hashTagPresent'],
//               message: notificationData[index]['message'],
//               mention: notificationData[index]['mentionedIn'],
//               imageBackground: notificationData[index]['color'],
//               userOnline: notificationData[index]['userOnline'],
//             ));
//     return Padding(
//         padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//         child: SafeArea(
//           child: Column(children: [
//              DefaultNav(title: "Notification", type: ProfileDummyType.Image),
//             AppSpaces.verticalSpace20,
//             Expanded(child: ListView(children: [...notificationCards]))
//           ]),
//         ));
//   }
// }