import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';

// class TaskezBottomSheet {
//   // static const MethodChannel _channel = MethodChannel('taskezBottomSheet');
// }

void showAppBottomSheet(Widget widget,
    {bool isScrollControlled = false,
    bool popAndShow = false,
    double? height}) {
  if (popAndShow) Navigator.pop(context);
  showModalBottomSheet(
    context: context,
    isScrollControlled: isScrollControlled,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    backgroundColor: AppColors.primaryBackgroundColor,
    builder: (BuildContext context) {
      return height == null ? widget : SizedBox(height: height, child: widget);
    },
  );
}
