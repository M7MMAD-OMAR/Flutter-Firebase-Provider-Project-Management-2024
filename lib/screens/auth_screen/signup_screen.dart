import 'dart:developer' as dev;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/topController.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/routes.dart';
import 'package:project_management_muhmad_omar/services/collections_refrences.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dashboard/dashboard_meeting_details_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dummy/profile_dummy_widget.dart';
import 'package:project_management_muhmad_omar/widgets/forms/form_input_with_label_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/back_widget.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';

class SignUpScreen extends StatefulWidget {
  final String email;

  const SignUpScreen({super.key, required this.email});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isTakean = false;
  String name = "";
  String password = "";
  String userName = "";
  String confirm = "";

  bool obscureText = false;

  RegExp regExletters = RegExp(r"(?=.*[a-z])\w+");
  RegExp regExnumbers = RegExp(r"(?=.*[0-9])\w+");
  RegExp regExbigletters = RegExp(r"(?=.*[A-Z])\w+");

  RegExp regEx2 = RegExp(r'[^\w\d\u0600-\u06FF\s]');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        DarkRadialBackground(
          color: HexColor.fromHex("#181a1f"),
          position: "topLeft",
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const NavigationBack(),
                      const SizedBox(height: 40),
                      Text(
                        'إنشاء حساب',
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      AppSpaces.verticalSpace20,
                      RichText(
                        text: TextSpan(
                          text: 'يستخدم ',
                          style: GoogleFonts.lato(
                            color: HexColor.fromHex("676979"),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: " ${widget.email} ",
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' لإنشاء حساب ',
                              style: GoogleFonts.lato(
                                color: HexColor.fromHex("676979"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Builder(builder: (context) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: GestureDetector(
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
                                          "assets/dummy-profile.png",
                                    ),
                                    Visibility(
                                      visible: selectedImagePath == null,
                                      child: Container(
                                          width: Utils.screenWidth * 0.310,
                                          height: Utils.screenWidth * 0.310,
                                          decoration: BoxDecoration(
                                              color: AppColors
                                                  .primaryAccentColor
                                                  .withOpacity(0.75),
                                              shape: BoxShape.circle),
                                          child: Icon(FeatherIcons.camera,
                                              color: Colors.white,
                                              size: Utils.screenWidth * 0.06)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: Utils.screenHeight * 0.06),
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
                              _nameController.text = "";
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: false,
                          placeholder: "الاسم",
                          keyboardType: "text",
                          controller: _nameController,
                          obscureText: false,
                          label: 'اسمك'),
                      SizedBox(height: Utils.screenHeight * 0.03),
                      LabelledFormInput(
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              if (isTakean) {
                                return 'يرجى استخدام اسم مستخدم آخر';
                              }
                            }
                            return null;
                          },
                          onClear: () {
                            setState(() {
                              userName = "";
                              _userNameController.text = "";
                            });
                          },
                          onChanged: (value) async {
                            setState(() {
                              userName = value;
                            });
                            if (await TopController().existByOne(
                                collectionReference: usersRef,
                                value: userName,
                                field: userNameK)) {
                              setState(() {
                                isTakean = true;
                              });
                            } else {
                              setState(() {
                                isTakean = false;
                              });
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: false,
                          placeholder: 'اسم المستخدم',
                          keyboardType: "text",
                          controller: _userNameController,
                          obscureText: false,
                          label: 'اسم المستخدم الخاص بك'),
                      SizedBox(height: Utils.screenHeight * 0.03),
                      LabelledFormInput(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'يجب أن تحتوي كلمة المرور على أكثر من 7 أحرف';
                            }
                            if (regExletters.hasMatch(value) == false) {
                              return 'يرجى إدخال حرف صغير واحد على الأقل';
                            }
                            if (regExnumbers.hasMatch(value) == false) {
                              return 'الرجاء إدخال رقم واحد على الأقل';
                            }
                            if (regExbigletters.hasMatch(value) == false) {
                              return 'الرجاء إدخال حرف كبير واحد على الأقل';
                            }
                            return null;
                          },
                          onClear: (() {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          }),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: false,
                          placeholder: 'كلمة المرور',
                          keyboardType: "text",
                          controller: _passController,
                          obscureText: obscureText,
                          label: 'كلمة المرور الخاصة بك'),
                      SizedBox(height: Utils.screenHeight * 0.03),
                      LabelledFormInput(
                          validator: (value) {
                            if (password.isNotEmpty && confirm != password) {
                              return 'كلمة المرور غير متطابقة';
                            }
                            return null;
                          },
                          onClear: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              confirm = value;
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: false,
                          placeholder: 'تأكيد',
                          keyboardType: "text",
                          controller: _confirmPassController,
                          obscureText: obscureText,
                          label: 'تأكيد كلمة المرور'),
                      SizedBox(height: Utils.screenHeight * 0.04),
                      SizedBox(
                        width: double.infinity,
                        height: Utils.screenHeight * 0.15,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    });
                                User? user = AuthProvider
                                    .instance.firebaseAuth.currentUser;
                                if (user != null) {
                                  await AuthProvider.instance.firebaseAuth
                                      .signOut();
                                }
                                if (selectedImagePath != null) {
                                  String? imagePathNetWork = "";
                                  final resOfUpload = await uploadImageToStorge(
                                      selectedImagePath: selectedImagePath!,
                                      imageName: name,
                                      folder: "Users");
                                  resOfUpload.fold((left) {
                                    CustomSnackBar.showError(
                                        "${left.toString()} ");
                                  }, (right) {
                                    right.then((value) async {
                                      imagePathNetWork = value;
                                      UserModel userModel = UserModel(
                                        emailParameter: widget.email,
                                        userNameParameter:
                                            userName.isEmpty ? null : userName,
                                        nameParameter: name,
                                        imageUrlParameter: imagePathNetWork!,
                                        idParameter: usersRef.doc().id,
                                        createdAtParameter: DateTime.now(),
                                        updatedAtParameter: DateTime.now(),
                                      );
                                      await AuthProvider()
                                          .createUserWithEmailAndPassword(
                                              userModel: userModel,
                                              email: widget.email,
                                              password: password);
                                    });
                                  });
                                } else {
                                  UserModel userModel = UserModel(
                                    emailParameter: widget.email,
                                    nameParameter: name,
                                    userNameParameter:
                                        userName.isEmpty ? null : userName,
                                    imageUrlParameter: defaultUserImageProfile,
                                    idParameter: usersRef.doc().id,
                                    createdAtParameter: DateTime.now(),
                                    updatedAtParameter: DateTime.now(),
                                  );
                                  var authserviceDone = await AuthProvider()
                                      .createUserWithEmailAndPassword(
                                          userModel: userModel,
                                          email: widget.email,
                                          password: password);
                                  authserviceDone.fold((left) {
                                    CustomSnackBar.showError(
                                        "${left.toString()} ");
                                    Navigator.of(context).pop();
                                  },
                                      (right) => {
                                            Navigator.of(context).pop(),
                                            CustomSnackBar.showSuccess(
                                              'مرحبًا بك في فريقنا، يسعدنا وجودك',
                                            ),
                                            Navigator.pushNamed(context,
                                                Routes.verifyEmailAddressScreen)
                                          });
                                }
                              } on Exception catch (e) {
                                Navigator.of(context).pop();
                                CustomSnackBar.showError(e.toString());
                              }
                            }
                            dev.log("message");
                          },
                          style: ButtonStyles.blueRounded,
                          child: Text(
                            'إنشاء حساب',
                            style: GoogleFonts.lato(
                                fontSize: Utils.screenWidth * 0.06,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          ),
        )
      ]),
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
