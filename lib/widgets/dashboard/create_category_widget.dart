import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/providers/task_category_provider.dart';
import 'package:project_management_muhmad_omar/providers/user_task_provider.dart';
import 'package:project_management_muhmad_omar/models/task/user_task_category_model.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/services/collections_refrences.dart';
import 'package:project_management_muhmad_omar/widgets/Dashboard/select_color_dialog_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheet_holder_widget.dart';
import 'package:provider/provider.dart';

import '../add_sub_icon_widget.dart';
import '../forms/form_input_with_label_widget.dart';
import '../snackbar/custom_snackber_widget.dart';
import 'icon_selection_widget.dart';

class CreateUserCategory extends StatefulWidget {
  CreateUserCategory({
    Key? key,
  }) : super(key: key);
  @override
  State<CreateUserCategory> createState() => _CreateUserCategoryState();
}

class _CreateUserCategoryState extends State<CreateUserCategory> {
  final TextEditingController _taskNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void onChanged(String value) async {
    name = value;
    // if (await TopController().existByTow(
    //     reference: usersRef,
    //     value: name,
    //     field: nameK,
    //     field2: categoryIdK,
    //     value2: widget.userTaskCategoryModel.id)) {
    //   isTaked = true;
    // } else {
    //   isTaked = false;
    // }
    // setState(() {
    //   isTaked;
    // });
  }

  String color = "#FDA7FF";
  UserTaskProvider userTaskController =
      Provider.of<UserTaskProvider>(context, listen: false);
  TaskCategoryProvider taskCategoryController =
      Provider.of<TaskCategoryProvider>(context, listen: false);
  IconData icon = Icons.home;
  bool isTaked = false;
  String name = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        AppSpaces.verticalSpace10,
        const BottomSheetHolder(),
        AppSpaces.verticalSpace10,
        Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return IconSelectionDialog(
                            onSelectedIconChanged: handleIconChanged,
                            initialIcon: icon,
                          );
                        },
                      );
                    },
                    child: Icon(
                      icon,
                      color: HexColor.fromHex(color),
                    )),
              ],
            ),
            AppSpaces.verticalSpace10,
            Row(
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ColorSelectionDialog(
                          onSelectedColorChanged: handleColorChanged,
                          initialColor: color,
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: HexColor.fromHex(color)),
                  ),
                ),
                AppSpaces.horizontalSpace20,
                Expanded(
                  child: LabelledFormInput(
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (isTaked) {
                          return 'يرجى استخدام اسم فئة آخر';
                        }
                      }
                      return null;
                    },
                    onClear: () {
                      setState(() {
                        name = "";
                        _taskNameController.text = "";
                      });
                    },
                    onChanged: onChanged,
                    label: "",
                    readOnly: false,
                    autovalidateMode: AutovalidateMode.always,
                    placeholder: "اسم الفئة",
                    keyboardType: "text",
                    controller: _taskNameController,
                    obscureText: false,
                  ),
                ),
              ],
            ),

            // Spacer(),
            AppSpaces.verticalSpace20,
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              AddSubIcon(
                icon: const Icon(Icons.add, color: Colors.white),
                scale: 1,
                color: AppColors.primaryAccentColor,
                callback: () async {
                  await _addCategory();
                },
              ),
            ])
          ]),
        ),
      ]),
    );
  }

  void handleColorChanged(String selectedColor) {
    setState(() {
      // Update the selectedDay variable in the first screen
      this.color = selectedColor;
    });
  }

  void handleIconChanged(IconData selectedIcon) {
    setState(() {
      // Update the selectedDay variable in the first screen
      this.icon = selectedIcon;
    });
  }

  Future<void> _addCategory() async {
    try {
      UserTaskCategoryModel userTaskModel = UserTaskCategoryModel(
        fontfamilyParameter: icon.fontFamily,
        iconCodePointParameter: icon.codePoint,
        hexColorParameter: color,
        userIdParameter: AuthProvider.firebaseAuth.currentUser!.uid,
        idParameter: usersTasksRef.doc().id,
        nameParameter: name,
        createdAtParameter: DateTime.now(),
        updatedAtParameter: DateTime.now(),
      );
      await taskCategoryController.addCategory(userTaskModel);
      CustomSnackBar.showSuccess("الفئة $name تمت الإضافة بنجاح");

      await Future.delayed(
          const Duration(seconds: 1)); // Delay closing the widget
      Navigator.pop(context);
    } catch (e) {
      CustomSnackBar.showError(e.toString());
    }
  }
}

class BottomSheetIcon extends StatelessWidget {
  final IconData icon;
  const BottomSheetIcon({
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      iconSize: 32,
      onPressed: null,
    );
  }
}
