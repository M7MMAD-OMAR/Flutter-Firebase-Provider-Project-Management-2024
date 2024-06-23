// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
//
// class LanguageWidget extends StatelessWidget {
//   final LanguageModel languageModel;
//   final int index;
//
//   const LanguageWidget(
//       {super.key, required this.languageModel, required this.index});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LangProvider>(
//       builder: (context, localizationProvider, child) {
//         return InkWell(
//           onTap: () {
//             localizationProvider.setLanguage(Locale(
//               AppConstants.languages[index].languageCode,
//               AppConstants.languages[index].countryCode,
//             ));
//             localizationProvider.setSelectIndex(index);
//           },
//           child: Container(
//             padding: const EdgeInsets.all(10),
//             margin: const EdgeInsets.all(5),
//             decoration: BoxDecoration(
//               color: Theme.of(context).cardColor,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)
//               ],
//             ),
//             child: Stack(children: [
//               Center(
//                 child: Column(mainAxisSize: MainAxisSize.min, children: [
//                   const SizedBox(height: 5),
//                   Text(
//                     languageModel.languageName!,
//                   ),
//                 ]),
//               ),
//               localizationProvider.selectedIndex == index
//                   ? Positioned(
//                       top: 0,
//                       right: 0,
//                       left: 0,
//                       bottom: 40,
//                       child: Icon(Icons.check_circle,
//                           color: Theme.of(context).primaryColor, size: 25),
//                     )
//                   : const SizedBox(),
//             ]),
//           ),
//         );
//       },
//     );
//   }
// }
