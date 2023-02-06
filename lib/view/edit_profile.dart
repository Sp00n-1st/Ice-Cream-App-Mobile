// ignore: must_be_immutable
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uuid/uuid.dart';
import '../model/user.dart';
import '../service/database.dart';
import '../utils/funtions.dart';

// ignore: must_be_immutable
class EditProfile extends StatefulWidget {
  UserAccount userAccount;
  EditProfile({super.key, required this.userAccount});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<Widget> itemPhotosWidgetList = <Widget>[];
  final ImagePicker _picker = ImagePicker();
  File? file;
  XFile? photo;
  XFile? itemImagesList;
  String? downloadUrl;
  bool uploading = false;
  bool submit = false;
  String? imageSave;
  final auth = FirebaseAuth.instance.currentUser!.uid;
  final emailUpdate = FirebaseAuth.instance.currentUser;
  String? emailChange;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  void initState() {
    firstName.text = widget.userAccount.firstName;
    lastName.text = widget.userAccount.lastName;
    email.text = widget.userAccount.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            MaterialButton(
              onPressed: pickPhotoFromGallery,
              child: Container(
                margin: const EdgeInsets.only(top: 0),
                child: Center(
                    child: (photo != null)
                        ? CircleAvatar(
                            radius: 100,
                            backgroundImage: FileImage(File(photo!.path)))
                        : CircleAvatar(
                            radius: 100,
                            backgroundImage: widget.userAccount.imageProfile ==
                                    null
                                ? const NetworkImage(
                                    'https://www.its.ac.id/aktuaria/wp-content/uploads/sites/100/2018/03/user-320x320.png')
                                : NetworkImage(
                                    widget.userAccount.imageProfile!),
                          )),
              ),
            ),
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
            Center(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    onPressed: () async {
                      if (firstName.text.isNotEmpty &&
                          lastName.text.isNotEmpty &&
                          email.text.isNotEmpty) {
                        try {
                          setState(() {
                            uploading = !uploading;
                          });
                          await emailUpdate!.updateEmail(email.text);
                          await upload();
                          if (photo == null &&
                              widget.userAccount.imageProfile != null) {
                            imageSave = widget.userAccount.imageProfile;
                          } else if (photo != null &&
                              widget.userAccount.imageProfile != null) {
                            imageSave = downloadUrl;
                          } else if (photo != null) {
                            imageSave = downloadUrl;
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
                                email: widget.userAccount.email,
                                password: DataBaseServices().decryptedPass(
                                    widget.userAccount.password));

                            await emailUpdate!
                                .reauthenticateWithCredential(cred);
                            await emailUpdate!.updateEmail(email.text);
                            await upload();
                            if (photo == null &&
                                widget.userAccount.imageProfile != null) {
                              imageSave = widget.userAccount.imageProfile;
                            } else if (photo != null &&
                                widget.userAccount.imageProfile != null) {
                              // await DataBaseServices().deleteImage(
                              //     widget.userAccount.imageProfile!);
                              imageSave = downloadUrl;
                            } else if (photo != null) {
                              imageSave = downloadUrl;
                            }
                            user.doc(auth).update(({
                                  'email': email.text,
                                  'firstName': firstName.text,
                                  'imageProfile': imageSave,
                                  'lastName': lastName.text
                                }));
                            Get.back();
                            setState(() {
                              uploading = !uploading;
                            });
                          } else {
                            setState(() {
                              uploading = !uploading;
                            });
                            showNotification(context, e.message.toString());
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
                    child: !uploading
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
          ]),
        ));
  }

  pickPhotoFromGallery() async {
    photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        itemImagesList = photo!;
        // addImage();
        // photo!.clear();
      });
    }
  }

  upload() async {
    await uplaodImageAndSaveItemInfo();
    setState(() {
      uploading = false;
    });
    itemPhotosWidgetList.clear();
    showToast("Edit Profile Successfully !",
        textStyle: GoogleFonts.poppins(),
        backgroundColor: Colors.green,
        position: const ToastPosition(align: Alignment.bottomCenter));
  }

  Future<String> uplaodImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String? productId = const Uuid().v4();
    if (itemImagesList != null) {
      PickedFile? pickedFile = PickedFile(itemImagesList!.path.toString());
      await uploadImageToStorage(pickedFile, productId);
    }
    return productId;
  }

  uploadImageToStorage(PickedFile? pickedFile, String productId) async {
    Reference reference =
        FirebaseStorage.instance.ref().child('ProfileImages/$auth');
    await reference.putData(
      await pickedFile!.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String value = await reference.getDownloadURL();
    downloadUrl = value;
  }
}
