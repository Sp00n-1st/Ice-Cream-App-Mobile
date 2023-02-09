// ignore: must_be_immutable
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import '../controller/controller.dart';
import '../controller/password_controller.dart';
import '../controller/photo_controller.dart';
import '../model/user.dart';

// ignore: must_be_immutable
class EditProfile extends StatelessWidget {
  UserAccount userAccount;
  EditProfile({super.key, required this.userAccount});

  var photoController = Get.put(PhotoC());
  var passController = Get.put(PasswordController());
  var controller = Get.put(Controller());
  String? imageSave;
  final auth = FirebaseAuth.instance.currentUser!.uid;
  final emailUpdate = FirebaseAuth.instance.currentUser;
  String? emailChange;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    photoController.pathImage.value = '';
    firstName.text = userAccount.firstName;
    lastName.text = userAccount.lastName;
    email.text = userAccount.email;
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    CollectionReference user = firebase.collection('user');

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                CupertinoIcons.arrow_left,
                color: Colors.black,
              ),
            )),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Obx(() {
              return MaterialButton(
                onPressed: photoController.pickPhotoFromGallery,
                child: Container(
                  margin: const EdgeInsets.only(top: 0),
                  child: Center(
                      child: (photoController.pathImage.value != '')
                          ? CircleAvatar(
                              radius: 100,
                              backgroundImage: FileImage(
                                  File(photoController.pathImage.toString())))
                          : CircleAvatar(
                              radius: 100,
                              backgroundImage: userAccount.imageProfile == null
                                  ? const NetworkImage(
                                      'https://www.its.ac.id/aktuaria/wp-content/uploads/sites/100/2018/03/user-320x320.png')
                                  : NetworkImage(userAccount.imageProfile!),
                            )),
                ),
              );
            }),
            Container(
                margin: const EdgeInsets.only(left: 20, top: 30, bottom: 10),
                child: const Text('First Name')),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: firstName,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Colors.blue.shade900, width: 2)),
                  hintText: 'Input First Name',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Can\'t Be Empty';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 20, top: 30, bottom: 10),
                child: const Text('Last Name')),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: lastName,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Colors.blue.shade900, width: 2)),
                  hintText: 'Input Last Name',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Can\'t Be Empty';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 20, top: 30, bottom: 10),
                child: const Text('Email')),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Colors.blue.shade900, width: 2)),
                  hintText: 'Input Email',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Can\'t Be Empty';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
            Obx(
              () => Center(
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder()),
                      onPressed: (photoController.uploading.isTrue)
                          ? null
                          : () async {
                              if (firstName.text.isNotEmpty &&
                                  lastName.text.isNotEmpty &&
                                  email.text.isNotEmpty) {
                                try {
                                  photoController.uploading.value =
                                      !photoController.uploading.value;
                                  print(photoController.uploading);
                                  await emailUpdate!.updateEmail(email.text);
                                  await photoController.upload();
                                  if (photoController.pathImage == '' &&
                                      userAccount.imageProfile != null) {
                                    imageSave = userAccount.imageProfile;
                                  } else if (photoController.pathImage != '' &&
                                      userAccount.imageProfile != null) {
                                    imageSave =
                                        photoController.downloadUrl.value;
                                  } else if (photoController.pathImage != '') {
                                    imageSave =
                                        photoController.downloadUrl.value;
                                  }
                                  user.doc(auth).update(({
                                        'email': email.text,
                                        'firstName': firstName.text,
                                        'imageProfile': imageSave,
                                        'lastName': lastName.text
                                      }));
                                  var token = await emailUpdate!.getIdToken();
                                  print(token);
                                  Get.back();
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'requires-recent-login') {
                                    print('cred');
                                    final cred = EmailAuthProvider.credential(
                                        email: userAccount.email,
                                        password: passController.decryptedPass(
                                            userAccount.password));
                                    await emailUpdate!
                                        .reauthenticateWithCredential(cred);
                                    await emailUpdate!.updateEmail(email.text);
                                    await photoController.upload();
                                    if (photoController.pathImage == '' &&
                                        userAccount.imageProfile != null) {
                                      imageSave = userAccount.imageProfile;
                                    } else if (photoController.pathImage !=
                                            '' &&
                                        userAccount.imageProfile != null) {
                                      // await DataBaseServices().deleteImage(
                                      //     widget.userAccount.imageProfile!);
                                      imageSave =
                                          photoController.downloadUrl.value;
                                    } else if (photoController.pathImage !=
                                        '') {
                                      imageSave =
                                          photoController.downloadUrl.value;
                                    }
                                    user.doc(auth).update(({
                                          'email': email.text,
                                          'firstName': firstName.text,
                                          'imageProfile': imageSave,
                                          'lastName': lastName.text
                                        }));
                                    Get.back();
                                    photoController.uploading.value =
                                        !photoController.uploading.value;
                                  } else {
                                    photoController.uploading.value =
                                        !photoController.uploading.value;
                                    controller.showNotification(
                                        context, e.message.toString());
                                  }
                                }
                              } else {
                                showToast(
                                    'Please Enter All Required Data Before Data Input!',
                                    backgroundColor: Colors.red,
                                    position: const ToastPosition(
                                        align: Alignment.bottomCenter));
                              }
                            },
                      child: !photoController.uploading.isTrue
                          ? Text(
                              'Save',
                              style: GoogleFonts.poppins(fontSize: 16),
                            )
                          : const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                backgroundColor: Colors.black,
                              ))),
                ),
              ),
            ),
          ]),
        ));
  }
}
