import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:intl/intl.dart';
import '../model/user.dart';
import '../utils/funtions.dart';
import '../utils/globals.dart' as globals;
import '../view/home.dart';
import '../view/login_mobile.dart';

class DataBaseServices {
  Future<void> downloadUrlEx(String loc) async {
    await FirebaseStorage.instance.ref().child('$loc').getDownloadURL();
  }

  Future<void> deleteImage(String loc) async {
    await FirebaseStorage.instance.ref().storage.refFromURL(loc).delete();
  }

  Future<void> loginAuth(
      BuildContext context, String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    final auth = FirebaseAuth.instance.currentUser!.uid;
    var collection = FirebaseFirestore.instance.collection('user').doc(auth);
    var querySnapshot = await collection.get();
    Map<String, dynamic>? data = querySnapshot.data();
    var name = data!['firstName'];
    var isDisable = data['isDisable'];
    if (isDisable == false) {
      collection.update(({'isLogin': true}));
      Get.offAll(const MyHomePage());
      globals.isLogin = !globals.isLogin;
      showToast('Hello $name You Are Login Now',
          position: const ToastPosition(align: Alignment.bottomCenter),
          backgroundColor: const Color(0xff00AA13));
    } else {
      globals.isLogin = !globals.isLogin;
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              'You can\'t login because you\'ve been banned',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            content: Column(
              children: [
                const Icon(
                  CupertinoIcons.clear_circled,
                  color: Colors.red,
                  size: 80,
                ),
                Text(
                  'Contact Sweet Dream customer service for more information',
                  style: GoogleFonts.poppins(fontSize: 14),
                )
              ],
            ),
            actions: [
              MaterialButton(
                  child: const Text('OK'),
                  onPressed: () {
                    logoutAuth(false);
                  })
            ],
          );
        },
      );
    }
  }

  Future<void> logoutAuth(bool isShowToast) async {
    DateTime now = DateTime.now();
    final date = DateFormat('dd-MM-yyyy').format(now);
    final auth = FirebaseAuth.instance.currentUser!.uid;
    var collection = FirebaseFirestore.instance.collection('user').doc(auth);
    await FirebaseAuth.instance.signOut();
    collection.update(({'isLogin': false, 'lastLogin': date}));
    Get.offAll(LoginPageMobile());
    isShowToast == true
        ? showToast('You Are Logout',
            position: const ToastPosition(align: Alignment.bottomCenter))
        : null;
  }

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
    globals.isLogin = !globals.isLogin;
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
                'password': DataBaseServices().encryptPass(newPassword),
              }));
          EasyLoading.showSuccess('Change Password Success!');
          Navigator.pop(context);
          //Success
        }).catchError((error) {
          showNotification(context, error);
        });
      }).catchError((err) {
        showToast(err.toString(),
            textStyle: GoogleFonts.poppins(),
            backgroundColor: Colors.red,
            position: const ToastPosition(align: Alignment.bottomCenter));
      });
    } on FirebaseAuthException catch (e) {
      showNotification(context, e.message!);
    }
  }
}
