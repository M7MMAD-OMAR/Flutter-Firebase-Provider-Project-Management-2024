import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/providers/user_provider.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/routes.dart';
import 'package:project_management_muhmad_omar/screens/profile/my_profile_screen.dart';
import 'package:project_management_muhmad_omar/widgets/buttons/primary_buttons_widget.dart';
import 'package:project_management_muhmad_omar/widgets/buttons/primary_progress_button_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dashboard/dashboard_meeting_details_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dummy/profile_dummy_widget.dart';
import 'package:project_management_muhmad_omar/widgets/forms/form_input_with_label_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/app_header_widget.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel? user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name = "";
  RegExp regExletters = RegExp(r"(?=.*[a-z])\w+");
  RegExp regExnumbers = RegExp(r"(?=.*[0-9])\w+");
  RegExp regExbigletters = RegExp(r"(?=.*[A-Z])\w+");

  RegExp regEx2 = RegExp(r'[^\w\d\u0600-\u06FF\s]');
  String password = "";
  String userName = "";
  String bio = "";
  String email = "";
  final nameController = TextEditingController();
  final userNameController = TextEditingController();
  final passController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    name = widget.user!.name!;
    nameController.text = widget.user!.name!;
    userName = widget.user!.userName ?? "";
    userNameController.text = widget.user!.userName ?? "";
    bio = widget.user!.bio ?? "";
    bioController.text = widget.user!.bio ?? "";
    email = widget.user!.email ?? "";
    emailController.text = widget.user!.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    const String tabSpace = "\t\t\t";

    return Scaffold(
      body: Stack(
        children: [
          DarkRadialBackground(
            color: HexColor.fromHex("#181a1f"),
            position: "topLeft",
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  right: Utils.screenWidth * 0.04,
                  left: Utils.screenWidth * 0.04,
                  top: Utils.screenHeight * 0.05),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TaskezAppHeader(
                        title: "$tabSpace تحرير الملف الشخصي",
                        widget: PrimaryProgressButton(
                          callback: () async {
                            try {
                              bool pop = false;
                              bool changes = false;

                              if (formKey.currentState!.validate()) {
                                showDialogMethod(context);

                                if (selectedImagePath != null) {
                                  showDialogMethod(context);

                                  final resOfUpload = await uploadImageToStorge(
                                      selectedImagePath: selectedImagePath!,
                                      imageName: AuthProvider
                                          .firebaseAuth.currentUser!.uid,
                                      folder: "Users");
                                  resOfUpload.fold((left) {
                                    Navigator.pop(context);
                                    CustomSnackBar.showError(
                                        "${left.toString()} ");
                                  }, (right) async {
                                    right.then((value) async {
                                      String imageNetWork = value!;
                                      await UserProvider().updateUser(
                                          id: AuthProvider
                                              .firebaseAuth.currentUser!.uid,
                                          data: {imageUrlK: imageNetWork});
                                      Navigator.pop(context);
                                    });
                                  });
                                }

                                if (name.trim() != widget.user!.name) {
                                  name = name.trim();
                                  await UserProvider().updateUser(
                                      data: {nameK: name}, id: widget.user!.id);
                                  changes = true;
                                }
                                if (userName.isNotEmpty &&
                                    userName.trim() != widget.user!.userName) {
                                  userName = userName.trim();
                                  await UserProvider().updateUser(
                                      data: {userNameK: userName},
                                      id: widget.user!.id);
                                  changes = true;
                                }

                                if (bio.isNotEmpty &&
                                    bio.trim() != widget.user!.bio) {
                                  bio = bio.trim();
                                  await UserProvider().updateUser(
                                      data: {bioK: bio}, id: widget.user!.id);
                                  changes = true;
                                }

                                if (email.isNotEmpty &&
                                    email.trim() != widget.user!.email) {
                                  email = email.trim();
                                  var emailupdate = await AuthProvider()
                                      .updateEmail(email: email);

                                  emailupdate.fold((left) async {
                                    CustomSnackBar.showError(left.toString());
                                  }, (right) async {
                                    await UserProvider().updateUser(
                                        data: {emailK: email},
                                        id: widget.user!.id);

                                    pop = true;
                                    Navigator.of(context).pop();
                                    CustomSnackBar.showSuccess(
                                        'تم تحديث البريد الإلكتروني بنجاح..الرجاء تسجيل الدخول والتحقق من البريد الإلكتروني الجديد');
                                    AuthProvider().logOut();
                                    changes = true;
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        Routes.onboardingCarouselScreen,
                                        (Route<dynamic> route) => false);

                                    return;
                                  });
                                }
                                if (!pop) {
                                  Navigator.of(context).pop();

                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => MyProfileScreen(
                                            user: widget.user!)),
                                    (Route<dynamic> route) => false,
                                  );
                                }
                                if (changes) {
                                  CustomSnackBar.showSuccess(
                                      "تم التحديث بنجاح");
                                }
                              }
                            } on Exception catch (e) {
                              Navigator.of(context).pop();
                              CustomSnackBar.showError(e.toString());
                            }
                          },
                          width: Utils.screenWidth * 0.2,
                          height: Utils.screenHeight * 0.1,
                          label: " حفظ",
                          textStyle: GoogleFonts.lato(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: Utils.screenHeight * 0.03),
                      Column(
                        children: [
                          Builder(builder: (context) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      _showImagePickerDialog(context);
                                    },
                                    child: Stack(
                                      children: [
                                        ProfileDummy(
                                          imageType: selectedImagePath == null
                                              ? ImageType.Network
                                              : ImageType.File,
                                          color: HexColor.fromHex("94F0F1"),
                                          dummyType: ProfileDummyType.Image,
                                          scale: 3.0,
                                          image: selectedImagePath ??
                                              widget.user!.imageUrl,
                                        ),
                                        Visibility(
                                          visible: selectedImagePath == null,
                                          child: Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                                color: AppColors
                                                    .primaryAccentColor
                                                    .withOpacity(0.75),
                                                shape: BoxShape.circle),
                                            child: const Icon(
                                                FeatherIcons.camera,
                                                color: Colors.white,
                                                size: 20),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          AppSpaces.verticalSpace20,
                          LabelledFormInput(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'لا يمكن أن يكون الاسم فارغًا';
                                }
                                if (regExnumbers.hasMatch(value) ||
                                    regEx2.hasMatch(value)) {
                                  return 'لا يمكن أن يحتوي الاسم على أرقام أو رموز';
                                }
                                return null;
                              },
                              onChanged: (value) async {
                                setState(() {
                                  name = value;
                                });
                              },
                              onClear: () {
                                setState(() {
                                  name = "";
                                  nameController.text = "";
                                });
                              },
                              autovalidateMode: AutovalidateMode.always,
                              readOnly: false,
                              placeholder: widget.user!.name!,
                              keyboardType: "text",
                              controller: nameController,
                              obscureText: false,
                              label: 'اسمك'),
                          AppSpaces.verticalSpace20,
                          Visibility(
                            visible: !AuthProvider
                                .firebaseAuth.currentUser!.isAnonymous,
                            child: LabelledFormInput(
                                onChanged: (value) {
                                  setState(() {
                                    userName = value;
                                  });
                                },
                                onClear: () {
                                  setState(() {
                                    userName = "";
                                    userNameController.text = "";
                                  });
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                readOnly: false,
                                placeholder: widget.user!.userName == null
                                    ? ""
                                    : widget.user!.userName!,
                                keyboardType: "text",
                                controller: userNameController,
                                obscureText: false,
                                label: 'اسم المستخدم الخاص بك'),
                          ),
                          AppSpaces.verticalSpace20,
                          Visibility(
                            visible: !AuthProvider
                                .firebaseAuth.currentUser!.isAnonymous,
                            child: LabelledFormInput(
                                validator: (value) {
                                  if (!EmailValidator.validate(value!)) {
                                    return 'أدخل بريد إلكتروني صالح';
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                onClear: () {
                                  setState(() {
                                    email = "";
                                    emailController.text = "";
                                  });
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                readOnly: false,
                                placeholder: widget.user!.email == null
                                    ? ""
                                    : widget.user!.email!,
                                keyboardType: "text",
                                controller: emailController,
                                obscureText: false,
                                label: 'بريدك الإلكتروني'),
                          ),
                          AppSpaces.verticalSpace20,
                          LabelledFormInput(
                              onChanged: (value) {
                                bio = value;
                              },
                              onClear: () {
                                bio = "";
                                bioController.text = "";
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              readOnly: false,
                              placeholder: widget.user!.bio == null
                                  ? ""
                                  : widget.user!.bio!,
                              keyboardType: "text",
                              controller: bioController,
                              obscureText: false,
                              label: 'السيرة الذاتية'),
                        ],
                      ),
                      Visibility(
                        visible:
                            !AuthProvider.firebaseAuth.currentUser!.isAnonymous,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: AppPrimaryButton(
                              callback: () {
                                CustomDialog.showPasswordDialog(context);
                              },
                              buttonText: 'تغيير كلمة المرور',
                              buttonHeight: 50,
                              buttonWidth: 175),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String? selectedImagePath;

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'اختر صورة',
          ),
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
                  child: Text("إلغاء"),
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
}
