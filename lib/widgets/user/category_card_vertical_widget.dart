import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/categoryController.dart';
import 'package:project_management_muhmad_omar/controllers/user_task_controller.dart';
import 'package:project_management_muhmad_omar/models/task/user_task_category_model.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';
import 'package:project_management_muhmad_omar/widgets/user/category_tasks_widget_widget.dart';
import 'package:project_management_muhmad_omar/widgets/user/colured_category_badge_widget.dart';

import '../Dashboard/edit_category_widget.dart';
import 'focused_menu_item_widget.dart';

class CategoryCardVertical extends StatefulWidget {
  final UserTaskCategoryModel userTaskCategoryModel;

  const CategoryCardVertical({
    super.key,
    required this.userTaskCategoryModel,
    // required this.ratingsLowerNumber,
    // required this.ratingsUpperNumber
  });

  @override
  State<CategoryCardVertical> createState() => _CategoryCardVerticalState();
}

class _CategoryCardVerticalState extends State<CategoryCardVertical> {
  int first = 0;
  int second = 0;
  double percento = 0;

  //Stream _streamZip = StreamZip([]);

  @override
  void initState() {
    super.initState();
    //TaskCategoryController userTaskCategoryController =
    Get.put(TaskCategoryController());
    //UserTaskController userTaskController = Get.put(UserTaskController());
  }

  @override
  Widget build(BuildContext context) {
    UserTaskController userTaskController = Get.find();

    TaskCategoryController userTaskCategoryController = Get.find();
    // _streamZip = StreamZip([
    //   userTaskController.getCategoryTasksStream(
    //       folderId: widget.userTaskCategoryModel.id),
    //   userTaskController.getCategoryTasksForAStatusStream(
    //       folderId: widget.userTaskCategoryModel.id, status: "Done")
    // ]).asBroadcastStream();
    int iconCodePoint = widget.userTaskCategoryModel.iconCodePoint;
    String? fontFamily = widget.userTaskCategoryModel.fontfamily;

    // Icon icon = Icon(
    //   IconData(iconCodePoint, fontFamily: fontFamily),
    //   color: Colors.white,
    // );
    return FocusedMenu(
      onClick: () {
        Get.to(() => CategoryTasks(
              categoryModel: widget.userTaskCategoryModel,
            ));
      },
      deleteButton: () async {
        await userTaskCategoryController
            .deleteCategory(widget.userTaskCategoryModel.id);
      },
      editButton: () {
        showAppBottomSheet(
          EditUserCategory(category: widget.userTaskCategoryModel),
          isScrollControlled: true,
          popAndShow: false,
        );
      },
      widget: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: HexColor.fromHex("20222A"),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ColouredCategoryBadge(
                color: widget.userTaskCategoryModel.hexColor,
                icon: const Icon(Icons.home)),
            AppSpaces.verticalSpace20,
            Text(
              widget.userTaskCategoryModel.name!,
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: StreamBuilder(
                stream: userTaskController
                    .getCategoryTasksStream(
                        folderId: widget.userTaskCategoryModel.id)
                    .asBroadcastStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return StreamBuilder(
                      stream: userTaskController
                          .getCategoryTasksForAStatusStream(
                              folderId: widget.userTaskCategoryModel.id,
                              status: statusDone)
                          .asBroadcastStream(),
                      builder: (context, snapshot2) {
                        if (snapshot2.hasData) {
                          first = snapshot.data!.size;
                          second = snapshot2.data!.size;
                          percento = (snapshot.data!.size != 0
                              ? ((snapshot2.data!.size / snapshot.data!.size) *
                                  1000)
                              : 0);

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: HexColor.fromHex("343840")),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: percento.toInt(),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            gradient: LinearGradient(
                                              colors: [
                                                darken(HexColor.fromHex(widget
                                                    .userTaskCategoryModel
                                                    .hexColor)),
                                                HexColor.fromHex(widget
                                                    .userTaskCategoryModel
                                                    .hexColor)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1000 - percento.toInt(),
                                          child: const SizedBox())
                                    ],
                                  ),
                                ),
                              ),
                              AppSpaces.horizontalSpace10,
                              Text("$first/$second",
                                  style: GoogleFonts.lato(color: Colors.white))
                            ],
                          );
                        }
                        return Text("loading",
                            style: GoogleFonts.lato(color: Colors.white));
                      },
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: HexColor.fromHex("343840")),
                          child: Row(
                            children: [
                              Expanded(
                                flex: percento.toInt(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    gradient: LinearGradient(
                                      colors: [
                                        darken(HexColor.fromHex(widget
                                            .userTaskCategoryModel.hexColor)),
                                        HexColor.fromHex(widget
                                            .userTaskCategoryModel.hexColor)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1000 - percento.toInt(),
                                  child: const SizedBox())
                            ],
                          ),
                        ),
                      ),
                      AppSpaces.horizontalSpace10,
                      Text(first.toString() + "/" + second.toString(),
                          style: GoogleFonts.lato(color: Colors.white))
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
