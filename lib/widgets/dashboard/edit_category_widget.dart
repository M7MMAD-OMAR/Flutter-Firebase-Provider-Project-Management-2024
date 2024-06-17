import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_management_muhmad_omar/constants/app_constants.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/categoryController.dart';
import 'package:project_management_muhmad_omar/widgets/Dashboard/select_color_dialog_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheet_holder_widget.dart';

import '../../models/task/user_task_category_model.dart';
import '../add_sub_icon_widget.dart';
import '../forms/form_input_with_label_widget.dart';
import '../snackbar/custom_snackber_widget.dart';
import 'icon_selection_widget.dart';

class EditUserCategory extends StatefulWidget {
  final UserTaskCategoryModel category;

  EditUserCategory({
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  _EditUserCategoryState createState() => _EditUserCategoryState();
}

class _EditUserCategoryState extends State<EditUserCategory> {
  final TextEditingController _taskNameController = TextEditingController();
  String color = "";
  IconData icon = Icons.home;
  String name = "";

  @override
  void initState() {
    super.initState();
    color = widget.category.hexColor;
    // Assign icon and name in the initState using constant values if possible
    // icon = IconData(widget.category.iconCodePoint,
    //     fontFamily: widget.category.fontfamily);
    name = widget.category.name!;
    _taskNameController.text = name;
  }

  void onChanged(String value) {
    setState(() {
      name = value;
    });
  }

  void handleColorChanged(String selectedColor) {
    setState(() {
      color = selectedColor;
    });
  }

  void handleIconChanged(IconData selectedIcon) {
    setState(() {
      icon = selectedIcon;
    });
  }

  Future<void> _editCategory() async {
    try {
      TaskCategoryController taskCategoryController =
          Get.put(TaskCategoryController());
      await taskCategoryController.updateCategory(data: {
        fontFamilyK: icon.fontFamily,
        iconK: icon.codePoint,
        colorK: color,
        nameK: name,
        createdAtK: widget.category.createdAt,
        updatedAtK: DateTime.now(),
      }, id: widget.category.id);
      CustomSnackBar.showSuccess(
          "${AppConstants.category_key.tr} $name ${AppConstants.updated_successfully_key.tr}");
      await Future.delayed(const Duration(seconds: 1));
      Get.key.currentState!.pop();
    } catch (e) {
      CustomSnackBar.showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppSpaces.verticalSpace10,
            const BottomSheetHolder(),
            AppSpaces.verticalSpace10,
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        ),
                      ),
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
                          width: Utils.screenHeight *
                              0.06, // Adjust the percentage as needed
                          height: Utils.screenHeight * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: HexColor.fromHex(color),
                          ),
                        ),
                      ),
                      AppSpaces.horizontalSpace20,
                      Expanded(
                        child: LabelledFormInput(
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              // Add your validation logic here
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
                          label: AppConstants.name_key.tr,
                          readOnly: false,
                          autovalidateMode: AutovalidateMode.always,
                          placeholder: AppConstants.category_name_key.tr,
                          keyboardType: "text",
                          controller: _taskNameController,
                          obscureText: false,
                        ),
                      ),
                    ],
                  ),
                  AppSpaces.verticalSpace20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AddSubIcon(
                        icon: const Icon(FontAwesomeIcons.pencil,
                            color: Colors.white),
                        scale: 1,
                        color: AppColors.primaryAccentColor,
                        callback: () async {
                          await _editCategory();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
