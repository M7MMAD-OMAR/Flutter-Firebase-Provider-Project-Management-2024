import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/manger_controller.dart';
import 'package:project_management_muhmad_omar/controllers/teamController.dart';
import 'package:project_management_muhmad_omar/controllers/waitingMamberController.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/models/team/teamModel.dart';
import 'package:project_management_muhmad_omar/models/team/waiting_member.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/screens/Projects/search_for_members_screen.dart';
import 'package:project_management_muhmad_omar/services/collections_refrences.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheet_holder_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheet_selectable_container_widget.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';

import '../../screens/Projects/add_user_to_team_provider.dart';
import '../../services/auth_service.dart';
import '../Buttons/primary_buttons_widget.dart';
import '../dummy/profile_dummy_widget.dart';
import '../forms/form_input_with_label_widget.dart';
import 'in_bottomsheet_subtitle_widget.dart';

class DashboardMeetingDetails extends StatefulWidget {
  static List<UserModel?>? users = <UserModel?>[];

  const DashboardMeetingDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardMeetingDetails> createState() =>
      _DashboardMeetingDetailsState();
}

class _DashboardMeetingDetailsState extends State<DashboardMeetingDetails> {
  String teamName = "";
  String? selectedImagePath;

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('اختر صورة'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('الكاميرا'),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('المعرض'),
                  onTap: () {
                    _getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text(
                    "إلغاء",
                  ),
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
      if (value == null) {}
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

  TextEditingController teamNameCobtroller = TextEditingController();
  final DashboardMeetingDetailsScreenController userController =
      Get.find<DashboardMeetingDetailsScreenController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void clearUsers() {
    userController.users.clear();
  }

  @override
  @override
  void dispose() {
    clearUsers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex("#181a1f"),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppSpaces.verticalSpace10,
                      const BottomSheetHolder(),
                      AppSpaces.verticalSpace20,
                      Builder(builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            _showImagePickerDialog(context);
                            dev.log("message");
                          },
                          child: Stack(
                            children: [
                              ProfileDummy(
                                imageType: selectedImagePath == null
                                    ? ImageType.Assets
                                    : ImageType.File,
                                color: HexColor.fromHex("94F0F1"),
                                dummyType: ProfileDummyType.Image,
                                scale: Utils.screenWidth * 0.0077,
                                image: selectedImagePath ??
                                    "assets/defaultGroup.png",
                              ),
                              Visibility(
                                visible: selectedImagePath == null,
                                child: Container(
                                    width: Utils.screenWidth * 0.310,
                                    height: Utils.screenWidth * 0.310,
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryAccentColor
                                            .withOpacity(0.75),
                                        shape: BoxShape.circle),
                                    child: const Icon(FeatherIcons.camera,
                                        color: Colors.white, size: 20)),
                              )
                            ],
                          ),
                        );
                      }),
                      AppSpaces.verticalSpace10,
                      InBottomSheetSubtitle(
                        title: teamName.isEmpty ? "اسم الفريق" : teamName,
                        alignment: Alignment.center,
                        textStyle: GoogleFonts.lato(
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                          color: Colors.white,
                        ),
                      ),
                      AppSpaces.verticalSpace10,
                      const InBottomSheetSubtitle(
                        title: 'انقر على الشعار لتحميل صورة جديد',
                        alignment: Alignment.center,
                      ),
                      AppSpaces.verticalSpace20,
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: LabelledFormInput(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "اسم الفريق لا يمكن أن يكون فارغًا";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            readOnly: false,
                            onClear: () {
                              setState(() {
                                teamNameCobtroller.clear();
                                teamName = "";
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                teamName = value;
                              });
                            },
                            placeholder: 'ادخل اسم الفريق',
                            keyboardType: "text",
                            controller: teamNameCobtroller,
                            obscureText: false,
                            label: "اسم الفريق"),
                      ),
                      AppSpaces.verticalSpace20,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => SearchForMembers(
                                  newTeam: true,
                                  users: DashboardMeetingDetails.users,
                                ));
                          },
                          child: LabelledSelectableContainer(
                            label: "الأعضاء",
                            value: 'اختر الأعضاء',
                            icon: Icons.add,
                            valueColor: AppColors.primaryAccentColor,
                          ),
                        ),
                      ),
                      AppSpaces.verticalSpace20,
                      Obx(
                        () => buildStackedImagesKaremEdit(),
                      ),
                      AppSpaces.verticalSpace40,
                      AppPrimaryButton(
                        buttonHeight: 50,
                        buttonWidth: 180,
                        buttonText: 'إنشاء فريق جديد',
                        callback: () async {
                          teamName = teamName.trim();
                          if (formKey.currentState!.validate()) {
                            try {
                              if (userController.users.isEmpty) {
                                CustomSnackBar.showError(
                                    'الرجاء اختيار عضو واحد على الأقل لإنشاء فريق');
                              } else {
                                showDialogMethod(context);
                                ManagerModel managerModel =
                                    await ManagerController()
                                        .getManagerOrMakeOne(
                                            userId: AuthProvider.instance
                                                .firebaseAuth.currentUser!.uid);
                                if (selectedImagePath != null) {
                                  String? imagePathNetWork = "";
                                  final resOfUpload = await uploadImageToStorge(
                                      selectedImagePath: selectedImagePath!,
                                      imageName: teamName,
                                      folder: "Teams");

                                  resOfUpload.fold((left) {
                                    Navigator.of(context).pop();

                                    CustomSnackBar.showError(
                                        "${left.toString()} ");
                                    return;
                                  }, (right) async {
                                    right.then((value) async {
                                      imagePathNetWork = value;
                                      TeamModel teamModel = TeamModel(
                                        idParameter: teamsRef.doc().id,
                                        managerIdParameter: managerModel.id,
                                        nameParameter: teamName,
                                        imageUrlParameter: imagePathNetWork!,
                                        createdAtParameter: DateTime.now(),
                                        updatedAtParameter: DateTime.now(),
                                      );
                                      await createTheTeam(teamModel: teamModel);
                                      Navigator.of(context).pop();

                                      CustomSnackBar.showSuccess(
                                          " إنشاء فريق ${teamModel.name} تم الانتهاء بنجاح");
                                    });
                                  });
                                } else {
                                  TeamModel teamModel = TeamModel(
                                      idParameter: teamsRef.doc().id,
                                      managerIdParameter: managerModel.id,
                                      nameParameter: teamName,
                                      imageUrlParameter: defaultProjectImage,
                                      createdAtParameter: DateTime.now(),
                                      updatedAtParameter: DateTime.now());
                                  await createTheTeam(teamModel: teamModel);
                                  Navigator.of(context).pop();

                                  CustomSnackBar.showSuccess(
                                      "إنشاء فريق ${teamModel.name} تم الانتهاء بنجاح");
                                }

                                dev.log("message Ysss");
                                Get.close(1);
                              }
                            } on Exception catch (e) {
                              CustomSnackBar.showError(e.toString());
                            }
                          } else {}
                        },
                      ),
                      AppSpaces.verticalSpace20,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

EitherException<Future<String?>> uploadImageToStorge({
  required String selectedImagePath,
  required String imageName,
  required String folder,
}) async {
  try {
    Random random = Random();
    int number = random.nextInt(10000000);

    final Reference reference =
        firebaseStorage.ref().child("images/$folder/$number$imageName.png");
    final UploadTask uploadTask = reference.putFile(File(selectedImagePath));

    TaskSnapshot snapshot = await uploadTask;
    if (snapshot.state == TaskState.success) {
      final String downloadURL = await reference.getDownloadURL();

      return Right(Future.value(downloadURL));
    } else {
      return Left(Exception('Image upload failed'));
    }
  } catch (error) {
    return Left(Exception('Image upload error: ${error.toString()}}'));
  }
}

createTheTeam({required TeamModel teamModel}) async {
  await TeamController().addTeam(teamModel);
  for (var user in userController.users) {
    WaitingMemberModel waitingMemberModel = WaitingMemberModel(
        idParameter: watingMamberRef.doc().id,
        userIdParameter: user.id,
        teamIdParameter: teamModel.id,
        createdAtParameter: DateTime.now(),
        updatedAtParameter: DateTime.now());

    await WaitingMamberController()
        .addWaitingMamber(waitingMemberModel: waitingMemberModel);
  }
}
