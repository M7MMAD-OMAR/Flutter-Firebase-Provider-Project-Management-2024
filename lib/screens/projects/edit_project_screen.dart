import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_management_muhmad_omar/constants/app_constants.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/manger_controller.dart';
import 'package:project_management_muhmad_omar/controllers/projectController.dart';
import 'package:project_management_muhmad_omar/controllers/teamController.dart';
import 'package:project_management_muhmad_omar/controllers/team_member_controller.dart';
import 'package:project_management_muhmad_omar/controllers/userController.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_model.dart';
import 'package:project_management_muhmad_omar/models/team/teamModel.dart';
import 'package:project_management_muhmad_omar/models/team/team_members_model.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/services/collections_refrences.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';
import 'package:project_management_muhmad_omar/widgets/Team/show_team_members_widget.dart';
import 'package:project_management_muhmad_omar/widgets/add_sub_icon_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheet_holder_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dummy/profile_dummy_widget.dart';
import 'package:project_management_muhmad_omar/widgets/forms/form_input_with_label_widget.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';
import 'package:project_management_muhmad_omar/widgets/user/new_sheet_goto_calender_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/projects/add_team_to_create_project_provider.dart';

class EditProject extends StatefulWidget {
  EditProject({
    required this.userAsManager,
    required this.teamModel,
    required this.projectModel,
    super.key,
  });

  ProjectModel projectModel;
  TeamModel teamModel;
  ManagerModel userAsManager;

  @override
  State<EditProject> createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  String? selectedImagePath;

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppConstants.choose_an_image_key.tr),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text(AppConstants.camera_key.tr),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text(AppConstants.gallery_key.tr),
                  onTap: () {
                    _getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text(AppConstants.cancel_key.tr),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value == null) {
        // Handle the case where the user did not choose a photo
        // Display a message or perform any required actions
      }
    });
  }

  void _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        selectedImagePath = pickedFile.path;
      });
    }
  }

  final addTeamToCreatProjectScreen =
      Provider.of<AddTeamToCreatProjectProvider>(context);
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectDescController = TextEditingController();
  int? selectedDashboardOption;
  List<TeamMemberModel> membersList = [];
  String? teamMemberId;

  @override
  void initState() {
    super.initState();
    widget.projectModel.startDate = firebaseTime(widget.projectModel.startDate);
    widget.projectModel.endDate = firebaseTime(widget.projectModel.endDate!);
    startDate = widget.projectModel.startDate;
    dueDate = widget.projectModel.endDate!;

    formattedStartDate = formatDateTime(widget.projectModel.startDate);
    formattedDueDate = formatDateTime(widget.projectModel.endDate!);
    name = widget.projectModel.name!;
    _projectNameController.text = widget.projectModel.name!;
    desc = widget.projectModel.description!;
    _projectDescController.text = widget.projectModel.description!;
  }

  @override
  void dispose() {
    super.dispose();
    addTeamToCreatProjectScreen.teams.clear();
  }

  String formattedStartDate = "";
  String formattedDueDate = "";

  void onChanged(String value) async {}

  DateTime startDate = DateTime.now();

  DateTime dueDate = DateTime.now();
  ProjectController projectController = Get.put(ProjectController());
  TeamController teamController = Get.put(TeamController());
  TeamMemberController teamMemberController = Get.put(TeamMemberController());
  ManagerController managerController = Get.put(ManagerController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name = "";
  String desc = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(children: [
          AppSpaces.verticalSpace10,
          const BottomSheetHolder(),
          AppSpaces.verticalSpace20,
          Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                _showImagePickerDialog(context);
                //  dev.log("message");
              },
              child: Stack(
                children: [
                  ProfileDummy(
                    imageType: selectedImagePath == null
                        ? ImageType.Network
                        : ImageType.File,
                    color: HexColor.fromHex("94F0F1"),
                    dummyType: ProfileDummyType.Image,
                    scale: Utils.screenWidth * 0.0077,
                    image: selectedImagePath ?? widget.projectModel.imageUrl,
                  ),
                  Visibility(
                    visible: selectedImagePath == null,
                    child: Container(
                        width: Utils.screenWidth *
                            0.310, // Adjust the percentage as needed
                        height: Utils.screenWidth * 0.310,
                        decoration: BoxDecoration(
                            color:
                                AppColors.primaryAccentColor.withOpacity(0.75),
                            shape: BoxShape.circle),
                        child: const Icon(FeatherIcons.camera,
                            color: Colors.white, size: 20)),
                  )
                ],
              ),
            );
          }),
          AppSpaces.verticalSpace10,
          Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppSpaces.verticalSpace10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StreamBuilder<DocumentSnapshot<TeamModel>>(
                    stream: TeamController()
                        .getTeamByIdStream(id: widget.projectModel.teamId!),
                    builder: (context, snapshotTeam) {
                      return Text(
                        snapshotTeam.data!.data()!.name!,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Utils.screenWidth * 0.06,
                            fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  StreamBuilder<QuerySnapshot<TeamMemberModel>>(
                      stream: TeamMemberController().getMembersInTeamIdStream(
                          teamId: widget.projectModel.teamId!),
                      builder: (context, snapshotMembers) {
                        List<String> listIds = [];
                        if (snapshotMembers.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (snapshotMembers.hasData) {
                          if (snapshotMembers.data!.docs.isNotEmpty) {
                            for (var member in snapshotMembers.data!.docs) {
                              listIds.add(member.data().userId);
                            }
                          }
                          if (listIds.isEmpty) {
                            return buildStackedImages(
                              addMore: true,
                              numberOfMembers: 0.toString(),
                              users: <UserModel>[],
                              onTap: () {},
                            );
                          }
                          return StreamBuilder<QuerySnapshot<UserModel>>(
                              stream: UserController()
                                  .getUsersWhereInIdsStream(usersId: listIds),
                              builder: (context, snapshotUsers) {
                                if (snapshotUsers.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                List<UserModel> users = [];
                                for (var element in snapshotUsers.data!.docs) {
                                  users.add(element.data());
                                }
                                return buildStackedImages(
                                    onTap: () {
                                      Get.to(() => ShowTeamMembers(
                                            teamModel: widget.teamModel,
                                            userAsManager: widget.userAsManager,
                                          ));
                                    },
                                    users: users,
                                    numberOfMembers: users.length.toString(),
                                    addMore: true);
                              });
                        }
                        return Container();
                      }),
                ],
              ),
              AppSpaces.verticalSpace10,
              Row(
                children: [
                  AppSpaces.horizontalSpace20,
                  Expanded(
                    child: GetBuilder<STXProvider>(
                      init: STXProvider(),
                      builder: (controller) => LabelledFormInput(
                        ///  value: name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppConstants.name_can_not_be_empty_key.tr;
                          }
                          if (value.isNotEmpty) {
                            if (controller.isTaked.value) {
                              return AppConstants
                                  .please_use_another_project_name_key.tr;
                            }
                          }
                          return null;
                        },
                        onClear: () {
                          setState(() {
                            name = "";
                            _projectNameController.text = "";
                          });
                        },
                        onChanged: (value) async {
                          //setState(() {
                          name = value;
                          //     });

                          if (await projectController.existByTow(
                                  reference: projectsRef,
                                  value: name,
                                  field: nameK,
                                  field2: managerIdK,
                                  value2: widget.projectModel.managerId) &&
                              name != widget.projectModel.name) {
                            controller.updateIsTaked(true);

                            //   controller.isTaked.value = true;
                          } else {
                            controller.updateIsTaked(false);

                            // controller.isTaked.value = false;
                          }
                        },
                        label: AppConstants.name_key.tr,
                        readOnly: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        placeholder: "${AppConstants.project_name_key.tr} ....",
                        keyboardType: "text",
                        controller: _projectNameController,
                        obscureText: false,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpaces.verticalSpace20,
              LabelledFormInput(
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return AppConstants
                        .description_cannot_be_empty_spaces_key.tr;
                  }
                  return null;
                },
                onChanged: (p0) {
                  // setState(() {

                  desc = p0;
                  //});
                },
                onClear: () {
                  //setState(() {
                  desc = "";
                  _projectDescController.text = "";
                  //  });
                },
                label: AppConstants.description_key.tr,
                readOnly: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                placeholder: "${AppConstants.project_description_key.tr}....",
                keyboardType: "text",
                controller: _projectDescController,
                obscureText: false,
              ),
              AppSpaces.verticalSpace20,
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                NewSheetGoToCalendarWidget(
                  selectedDay: startDate,
                  onSelectedDayChanged: handleStartDayChanged,
                  cardBackgroundColor: HexColor.fromHex("7DBA67"),
                  textAccentColor: HexColor.fromHex("A9F49C"),
                  value: formattedStartDate,
                  label: AppConstants.start_date_key.tr,
                ),
                NewSheetGoToCalendarWidget(
                  onSelectedDayChanged: handleDueDayChanged,
                  selectedDay: dueDate,
                  cardBackgroundColor: HexColor.fromHex("BA67A3"),
                  textAccentColor: HexColor.fromHex("BA67A3"),
                  value: formattedDueDate,
                  label: AppConstants.due_date_validation_key.tr,
                )
              ]),
              // Spacer(),
              AppSpaces.verticalSpace20,
              AppSpaces.verticalSpace20,
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                AddSubIcon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  scale: 1,
                  color: AppColors.primaryAccentColor,
                  callback: () async {
                    if (formKey.currentState!.validate()) {
                      showDialogMethod(context);
                      await updateProjecr();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ])
            ]),
          ),
        ]),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "${AppConstants.today_key.tr} ${DateFormat('h:mma').format(dateTime)}";
    } else {
      return DateFormat('dd/MM h:mma').format(dateTime);
    }
  }

  void handleDueDayChanged(DateTime selectedDay) {
    setState(() {
      // Update the selectedDay variable in the first screen
      dueDate = selectedDay;
      formattedDueDate = formatDateTime(dueDate);
    });
  }

  void handleStartDayChanged(DateTime selectedDay) {
    setState(() {
      // Update the selectedDay variable in the first screen

      startDate = selectedDay;
      formattedStartDate = formatDateTime(startDate);
    });
  }

  Future<void> updateProjecr() async {
    name = name.trim();
    desc = desc.trim();

    if (startDate != widget.projectModel.startDate ||
        dueDate != widget.projectModel.endDate) {
      if (startDate.isAfter(dueDate) || startDate.isAtSameMomentAs(dueDate)) {
        CustomSnackBar.showError(
            "start date cannot be After end date Or in tha same Time");
        return;
      }
    }

    try {
      if (name != widget.projectModel.name ||
          desc != widget.projectModel.description ||
          startDate != widget.projectModel.startDate ||
          dueDate != widget.projectModel.endDate) {
        await ProjectController().updateProject(
            managerModel: widget.userAsManager,
            oldProject: widget.projectModel,
            data: {
              nameK: name,
              descriptionK: desc,
              startDateK: startDate,
              endDateK: dueDate,
            },
            id: widget.projectModel.id);
        CustomSnackBar.showSuccess("Projec $name Updated successfully");
        Get.key.currentState!.pop();
      } else {
        CustomSnackBar.showError("No Chages to Update");
      }
    } catch (e) {
      CustomSnackBar.showError(e.toString());
    }
  }
}

class BottomSheetIcon extends StatelessWidget {
  final IconData icon;

  const BottomSheetIcon({
    required this.icon,
    super.key,
  });

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
