import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ice_mobile/controller/controller.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import '../view/home.dart';
import '../view/login_mobile.dart';

class AuthController extends GetxController {
  var controller = Get.put(Controller());
  var isLogin = false.obs;

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
      Get.offAll(MyHomePage());
      isLogin.value = !isLogin.value;
      showToast('Hello $name You Are Login Now',
          position: const ToastPosition(align: Alignment.bottomCenter),
          backgroundColor: const Color(0xff00AA13));
    } else {
      isLogin.value = !isLogin.value;
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
    controller.selectedPages.value = 0;
  }
}
