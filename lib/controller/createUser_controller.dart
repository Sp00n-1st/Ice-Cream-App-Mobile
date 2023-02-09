import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view/login_mobile.dart';
import 'auth_controller.dart';

class CreateUserController extends GetxController {
  var authController = Get.put(AuthController());
  Future<void> createUserWithEmail(
      String email,
      String password,
      String encryptPass,
      String firstName,
      String lastName,
      String? imageProfile,
      String? token,
      BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    await createUserToStorage(email, encryptPass, auth.currentUser!.uid,
        firstName, lastName, imageProfile, token);
    authController.isLogin.value = !authController.isLogin.value;
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            'Hooray You Have Successfully Registered',
            style: GoogleFonts.poppins(),
          ),
          content: Column(
            children: [
              //#D8D8DC
              Image.asset('assets/success7.gif'),
              Text(
                'Now You Can Login Using The Account You Registered',
                style: GoogleFonts.poppins(),
              )
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                Get.offAll(LoginPageMobile());
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  Future<void> createUserToStorage(
      String email,
      String password,
      String uid,
      String firstName,
      String lastName,
      String? imageProfile,
      String? token) async {
    bool isDisable = false;
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    final userCreated = <String, dynamic>{
      'token': token,
      'isDisable': isDisable,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'imageProfile': imageProfile,
      'isLogin': null,
      'lastLogin': null
    };
    firebase.collection('user').doc(uid).set(userCreated);
  }
}
