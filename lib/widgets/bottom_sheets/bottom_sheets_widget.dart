import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/project_detail_sheet.dart';

class MyBottomSheetWidget {}

showSettingsBottomSheet(BuildContext context) =>
    showAppBottomSheet(context, const ProjectDetailBottomSheet());

showAppBottomSheet(BuildContext context, Widget widget,
    {bool isScrollControlled = false,
    bool popAndShow = false,
    double? height}) {
  if (popAndShow) Navigator.pop(context);
  return showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.primaryBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    isScrollControlled: isScrollControlled,
    builder: (context) {
      return height == null ? widget : SizedBox(height: height, child: widget);
    },
  );
}
