import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import '../controller/auth_controller.dart';
import '../controller/password_controller.dart';
import '../model/user.dart';
import 'edit_profile.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  var authController = Get.put(AuthController());
  var passController = Get.put(PasswordController());
  UserAccount userAccount;
  Profile({super.key, required this.userAccount});
  TextEditingController currentPassword = TextEditingController();
  TextEditingController passwordNewController = TextEditingController();
  TextEditingController passwordRepeatController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:
          AppBar(elevation: 0, backgroundColor: Colors.transparent, actions: [
        IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) {
                  bool isNotShow1 = true;
                  bool isNotShow2 = true;
                  bool isNotShow3 = true;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return CupertinoAlertDialog(
                        title: Text(
                          'Change Password ?',
                          style: GoogleFonts.poppins(fontSize: 18),
                        ),
                        content: Material(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Current Password',
                                style: GoogleFonts.poppins(
                                    color: Colors.black, fontSize: 20),
                              ),
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: TextField(
                                  controller: currentPassword,
                                  obscureText: isNotShow1,
                                  cursorColor: Colors.orange,
                                  decoration: InputDecoration(
                                      suffixIcon: isNotShow1
                                          ? IconButton(
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    isNotShow1 = !isNotShow1;
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                  CupertinoIcons.eye_slash))
                                          : IconButton(
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    isNotShow1 = !isNotShow1;
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                  CupertinoIcons.eye)),
                                      border: InputBorder.none,
                                      hintText: 'Input Current Password',
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 14)),
                                ),
                              ),
                              Text(
                                'Password New',
                                style: GoogleFonts.poppins(
                                    color: Colors.black, fontSize: 20),
                              ),
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: TextField(
                                  controller: passwordNewController,
                                  obscureText: isNotShow2,
                                  cursorColor: Colors.orange,
                                  decoration: InputDecoration(
                                      suffixIcon: isNotShow2
                                          ? IconButton(
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    isNotShow2 = !isNotShow2;
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                  CupertinoIcons.eye_slash))
                                          : IconButton(
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    isNotShow2 = !isNotShow2;
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                  CupertinoIcons.eye)),
                                      border: InputBorder.none,
                                      hintText: 'Input Password New',
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 14)),
                                ),
                              ),
                              Text(
                                'Repeat New Password',
                                style: GoogleFonts.poppins(
                                    color: Colors.black, fontSize: 20),
                              ),
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: TextField(
                                  controller: passwordRepeatController,
                                  obscureText: isNotShow3,
                                  cursorColor: Colors.orange,
                                  decoration: InputDecoration(
                                      suffixIcon: isNotShow3
                                          ? IconButton(
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    isNotShow3 = !isNotShow3;
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                  CupertinoIcons.eye_slash))
                                          : IconButton(
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    isNotShow3 = !isNotShow3;
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                  CupertinoIcons.eye)),
                                      border: InputBorder.none,
                                      hintText: 'Input  Repeat New Password',
                                      hintMaxLines: 1,
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 14)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                              currentPassword.clear();
                              passwordNewController.clear();
                              passwordRepeatController.clear();
                            },
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (currentPassword.text.isNotEmpty &&
                                  passwordNewController.text.isNotEmpty &&
                                  passwordRepeatController.text.isNotEmpty) {
                                if (passwordNewController.text ==
                                    passwordRepeatController.text) {
                                  passController.changePassword(
                                      context,
                                      userAccount,
                                      currentPassword.text,
                                      passwordNewController.text);
                                  currentPassword.clear();
                                  passwordNewController.clear();
                                  passwordRepeatController.clear();
                                } else {
                                  showToast('Passwords Are Not Same',
                                      backgroundColor: Colors.red,
                                      position: const ToastPosition(
                                          align: Alignment.bottomCenter));
                                }
                              } else {
                                showToast(
                                    'Please Enter All Required Data Before Data Input!',
                                    backgroundColor: Colors.red,
                                    position: const ToastPosition(
                                        align: Alignment.bottomCenter));
                              }
                            },
                            child: Text(
                              'Save',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
            icon: const Icon(
              Icons.lock_reset_sharp,
              color: Colors.black,
              size: 25,
            )),
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(
                      'Are Sure To Logout ?',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                    content: const Icon(
                      Icons.logout_rounded,
                      size: 50,
                    ),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'No',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          authController.logoutAuth(true);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Yes',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
              size: 25,
            )),
        const SizedBox(
          width: 10,
        )
      ]),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: const EdgeInsets.only(top: 0),
            child: Center(
              child: CircleAvatar(
                  radius: 100,
                  backgroundImage: userAccount.imageProfile == null
                      ? const NetworkImage(
                          'https://www.its.ac.id/aktuaria/wp-content/uploads/sites/100/2018/03/user-320x320.png')
                      : NetworkImage(userAccount.imageProfile!)),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 20, top: 30),
              child: const Text('First Name')),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.black, width: 2)),
            child: Text(userAccount.firstName),
          ),
          Container(
              margin: const EdgeInsets.only(left: 20, top: 30),
              child: const Text('Last Name')),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.black, width: 2)),
            child: Text(userAccount.lastName),
          ),
          Container(
              margin: const EdgeInsets.only(left: 20, top: 30),
              child: const Text('Email')),
          Container(
            padding: const EdgeInsets.all(10),
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.black, width: 2)),
            child: Text(userAccount.email),
          ),
          Center(
            child: SizedBox(
              width: 150,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: const StadiumBorder()),
                  onPressed: () async {
                    Get.to(EditProfile(
                      userAccount: userAccount,
                    ));
                  },
                  child: Text(
                    'Edit Profile',
                    style: GoogleFonts.poppins(fontSize: 16),
                  )),
            ),
          ),
        ]),
      ),
    );
  }
}
