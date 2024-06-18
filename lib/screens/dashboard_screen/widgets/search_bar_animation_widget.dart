import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class MySearchBarWidget extends StatelessWidget {
  final TextEditingController editingController;
  final String searchWord;
  final Function? onChanged;
  const MySearchBarWidget(
      {required this.searchWord,
      super.key,
      required this.editingController,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    bool isArabic = Directionality.of(context) == TextDirection.rtl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: SearchBarAnimation(
        hintText: "البحث في $searchWord",
        searchBoxColour: HexColor.fromHex("616575"),
        searchBoxWidth: Get.width * 0.5,
        // isSearchBoxOnRightSide: isArabic,
        textEditingController: editingController,
        isOriginalAnimation: true,
        enableKeyboardFocus: true,
        onExpansionComplete: () {
          debugPrint('do something just after searchbox is opened.');
        },
        onCollapseComplete: () {
          debugPrint('do something just after searchbox is closed.');
        },
        onPressButton: (isSearchBarOpens) {
          debugPrint(
              'do something before animation started. It\'s the ${isSearchBarOpens ? 'opening' : 'closing'} animation');
        },
        trailingWidget: InkWell(
          onTap: () {
            editingController.clear();
          },
          child: Icon(
            Icons.clear,
            size: Utils.screenWidth * 0.05,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        secondaryButtonWidget: Icon(
          Icons.close,
          size: Utils.screenWidth * 0.05,
          color: Colors.black,
        ),
        buttonWidget: Icon(
          Icons.search,
          size: Utils.screenWidth * 0.05,
          color: Colors.black,
        ),
        // textAlignToRight: true,
        onChanged: onChanged,
      ),
    );
  }
}
