import 'dart:io';
import 'dart:math';

import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/routes.dart';
import 'package:project_management_muhmad_omar/widgets/Navigation/back.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background.dart';

import '../../Utils/back_utils.dart';
import '../../providers/user_provider/user_provider.dart';
import '../../widgets/forms/labelled_form_input_widget.dart';

class SignUpScreen extends StatefulWidget {
  final String email;

  const SignUpScreen({super.key, required this.email});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
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

  //يستخدم لجعل المستخدم قادر على إدخال احرف فقط اي بدون ارقام او محارف خاصة

  RegExp regExletters = RegExp(r"(?=.*[a-z])\w+");
  RegExp regExnumbers = RegExp(r"(?=.*[0-9])\w+");
  RegExp regExbigletters = RegExp(r"(?=.*[A-Z])\w+");
  String? selectedImagePath;

  RegExp regEx2 = RegExp(r'[^\w\d\u0600-\u06FF\s]');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                            text: "باستخدام  ",
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
                                text: "لإنشاء حساب  ",
                                style: GoogleFonts.lato(
                                  color: HexColor.fromHex("676979"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Builder(builder: (context) {
                        //   return Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.only(top: 10.0),
                        //         child: GestureDetector(
                        //           onTap: () {
                        //             _showImagePickerDialog(context);
                        //           },
                        //           child: Stack(
                        //             children: [
                        //               // user Image
                        //
                        //               // ProfileDummy(
                        //               //   imageType: selectedImagePath == null
                        //               //       ? ImageType.Assets
                        //               //       : ImageType.File,
                        //               //   color: HexColor.fromHex("94F0F1"),
                        //               //   dummyType: ProfileDummyType.Image,
                        //               //   scale: Utils.getScreenWidth(context) *
                        //               //       0.0077,
                        //               //   image: selectedImagePath ??
                        //               //       "assets/dummy-profile.png",
                        //               // ),
                        //               Visibility(
                        //                 visible: selectedImagePath == null,
                        //                 child: Container(
                        //                     width:
                        //                         Utils.getScreenWidth(context) *
                        //                             0.310,
                        //                     // Adjust the percentage as needed
                        //                     height:
                        //                         Utils.getScreenWidth(context) *
                        //                             0.310,
                        //                     decoration: BoxDecoration(
                        //                         color: AppColors
                        //                             .primaryAccentColor
                        //                             .withOpacity(0.75),
                        //                         shape: BoxShape.circle),
                        //                     child: Icon(FeatherIcons.camera,
                        //                         color: Colors.white,
                        //                         size: Utils.getScreenWidth(
                        //                                 context) *
                        //                             0.06)),
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   );
                        // }),
                        SizedBox(height: Utils.getScreenHeight(context) * 0.06),
                        // Adjust the percentage as needed
                        LabelledFormInputWidget(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "لا يمكن أن يكون الاسم فارغا";
                              }
                              if (regExnumbers.hasMatch(value) ||
                                  regEx2.hasMatch(value)) {
                                return "لا يمكن أن يحتوي الاسم على أرقام أو رموز";
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            readOnly: false,
                            placeholder: "الاسم",
                            keyboardType: "text",
                            controller: _nameController,
                            obscureText: false,
                            label: "الاسم"),
                        SizedBox(height: Utils.getScreenHeight(context) * 0.03),
                        // Adjust the percentage as needed

                        LabelledFormInputWidget(
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                if (isTakean) {
                                  return "الرجاء استخدام اسم مستخدم آخر";
                                  //"Please use another userName";
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
                              // if (await TopController().existByOne(
                              //     collectionReference: usersRef,
                              //     value: userName,
                              //     field: userNameK)) {
                              setState(() {
                                isTakean = true;
                              });
                              // } else {
                              //   setState(() {
                              //     isTakean = false;
                              //   });
                              // }
                              // setState(() {
                              //   isTakean;
                              // });
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            readOnly: false,
                            placeholder: "اسم المستخدم",
                            keyboardType: "text",
                            controller: _userNameController,
                            obscureText: false,
                            label: "اسم المستخدم"),
                        SizedBox(height: Utils.getScreenHeight(context) * 0.03),
                        // Adjust the percentage as needed

                        LabelledFormInputWidget(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "يجب أن تكون كلمة المرور أكثر من 7 أحرف";
                                //"The password should be more then 7 character";
                              }
                              if (regExletters.hasMatch(value) == false) {
                                return "الرجاء إدخال حرف صغير واحد على الأقل";
                                //"please enter at least one small character";
                              }
                              if (regExnumbers.hasMatch(value) == false) {
                                return "الرجاء إدخال رقم واحد على الأقل";
                                //"please enter at least one Number";
                              }
                              if (regExbigletters.hasMatch(value) == false) {
                                return "الرجاء إدخال  حرف كبير واحد على الأقل";
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            readOnly: false,
                            placeholder: "كلمة المرور",
                            keyboardType: "text",
                            controller: _passController,
                            obscureText: obscureText,
                            label: "كلمة المرور"),
                        SizedBox(height: Utils.getScreenHeight(context) * 0.03),
                        // Adjust the percentage as needed

                        LabelledFormInputWidget(
                            validator: (value) {
                              if (password.isNotEmpty && confirm != password) {
                                return "كلمة المرور غير متطابقة";
                              }
                              return null;
                            },
                            onClear: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                              // setState(() {
                              //   confirm = "";
                              //   _confirmPassController.text = "";
                              // });
                            },
                            onChanged: (value) {
                              setState(() {
                                confirm = value;
                              });
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            readOnly: false,
                            placeholder: "تأكيد كلمة المرور",
                            keyboardType: "text",
                            controller: _confirmPassController,
                            obscureText: obscureText,
                            label: "تأكيد كلمة المرور"),
                        SizedBox(height: Utils.getScreenHeight(context) * 0.04),
                        // Adjust the percentage as needed

                        SizedBox(
                          width: double.infinity,
                          height: Utils.getScreenHeight(context) *
                              0.07, // Adjust the percentage as needed

                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pushNamed(
                                  context, Routes.dashboardScreen);
                              // if (formKey.currentState!.validate()) {
                              //   try {
                              //     showDialog(
                              //         context: context,
                              //         builder: (context) {
                              //           return const Center(
                              //               child: CircularProgressIndicator());
                              //         });
                              //     User? user = Provider.of<AuthService>(context)
                              //         .firebaseAuth
                              //         .currentUser;
                              //     if (user != null) {
                              //       await Provider.of<AuthService>(context)
                              //           .firebaseAuth
                              //           .signOut();
                              //     }
                              //     if (selectedImagePath != null) {
                              //       String? imagePathNetWork = "";
                              //       final resOfUpload =
                              //           await uploadImageToStorge(
                              //               selectedImagePath:
                              //                   selectedImagePath!,
                              //               imageName: name,
                              //               folder: "Users");
                              //       resOfUpload.fold((left) {
                              //         SnackBar(
                              //             content: Text("${left.toString()} "));
                              //         // return;
                              //       }, (right) {
                              //         right.then((value) async {
                              //           imagePathNetWork = value;
                              //           UserModel userModel = UserModel(
                              //             emailParameter: widget.email,
                              //             userNameParameter: userName.isEmpty
                              //                 ? null
                              //                 : userName,
                              //             nameParameter: name,
                              //             imageUrlParameter: imagePathNetWork!,
                              //             idParameter: usersRef.doc().id,
                              //             createdAtParameter: DateTime.now(),
                              //             updatedAtParameter: DateTime.now(),
                              //           );
                              //           // await AuthService()
                              //           //     .createUserWithEmailAndPassword(
                              //           //         userModel: userModel,
                              //           //         email: widget.email,
                              //           //         password: password);
                              //           //    Navigator.of(context).pop();
                              //         });
                              //       });
                              //     } else {
                              //       UserModel userModel = UserModel(
                              //         emailParameter: widget.email,
                              //         nameParameter: name,
                              //         userNameParameter:
                              //             userName.isEmpty ? null : userName,
                              //         imageUrlParameter: "",
                              //         idParameter: usersRef.doc().id,
                              //         createdAtParameter: DateTime.now(),
                              //         updatedAtParameter: DateTime.now(),
                              //       );
                              //       // var authserviceDone = await AuthService()
                              //       //     .createUserWithEmailAndPassword(
                              //       //         userModel: userModel,
                              //       //         email: widget.email,
                              //       //         password: password);
                              //       // authserviceDone.fold((left) {
                              //       //   SnackBar(content:
                              //       //       Text("${left.toString()} "));
                              //       //   Navigator.of(context).pop();
                              //       // },
                              //       //     (right) =>
                              //       // {
                              //       //   Navigator.of(context).pop(),
                              //       //   SnackBar(content:
                              //       //   Text(
                              //       //       "Welcome in our team \n Plans to do team happy in you ")
                              //       //   ),
                              //       //   Navigator.pushNamed(context, Routes.emailAddressScreen)
                              //       //
                              //       // }
                              //       // );
                              //     }
                              //   } on Exception catch (e) {
                              //     Navigator.of(context).pop();
                              //     SnackBar(content: Text(e.toString()));
                              //   }
                              // }
                            },
                            style: ButtonStyles.blueRounded,
                            child: Text(
                              "إنشاء حساب جديد",
                              //'Sign Up',
                              style: GoogleFonts.lato(
                                  fontSize:
                                      Utils.getScreenWidth(context) * 0.06,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'اختر صورة',
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('بواسطة الكميرا'),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text("بواسطة معرض الصور"),
                  onTap: () {
                    _getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text("إلغاء"),
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
}

class VerifyEmailAddressScreen {
  const VerifyEmailAddressScreen();
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

      return Right(Future.value(downloadURL)); // Return Right for success case
    } else {
      return Left(
          Exception('Image upload failed')); // Return Left for failure case
    }
  } catch (error) {
    return Left(Exception(
        'Image upload error: ${error.toString()}}')); // Return Left for any exception/error
  }
}
