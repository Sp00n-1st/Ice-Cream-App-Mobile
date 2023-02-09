import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import '../model/user.dart';
import 'controller.dart';

class PasswordController extends GetxController {
  var controller = Get.put(Controller());

  encryptPass(String password) {
    final key = enc.Key.fromUtf8('my 32 length key................');
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return encrypted.base64;
  }

  decryptedPass(String passwordEncrypt) {
    final key = enc.Key.fromUtf8('my 32 length key................');
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));
    final decrypted =
        encrypter.decrypt(enc.Encrypted.fromBase64(passwordEncrypt), iv: iv);
    return decrypted;
  }

  Future<void> changePassword(BuildContext context, UserAccount userAccount,
      String currentPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      final cred = EmailAuthProvider.credential(
          email: userAccount.email, password: currentPassword);
      user!.reauthenticateWithCredential(cred).then((value) async {
        await EasyLoading.show(status: 'Loading...');
        user.updatePassword(newPassword).then((_) async {
          final firebase = FirebaseFirestore.instance;
          final userData = firebase.collection('user');
          userData.doc(user.uid).update(({
                'password': encryptPass(newPassword),
              }));
          EasyLoading.showSuccess('Change Password Success!');
          Navigator.pop(context);
          //Success
        }).catchError((error) {
          controller.showNotification(context, error);
        });
      }).catchError((err) {
        showToast(err.toString(),
            textStyle: GoogleFonts.poppins(),
            backgroundColor: Colors.red,
            position: const ToastPosition(align: Alignment.bottomCenter));
      });
    } on FirebaseAuthException catch (e) {
      controller.showNotification(context, e.message!);
    }
  }
}
