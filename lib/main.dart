import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ice_mobile/splash.dart';
import 'package:oktoast/oktoast.dart';

import 'service/database.dart';
import 'view/home.dart';
import 'view/login_mobile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splash(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

class Check extends StatelessWidget {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        Get.offAll(MyHomePage());
      } else {
        //DataBaseServices().logoutAuth(false);
        Get.offAll(LoginPageMobile());
      }
    } on FirebaseAuthException catch (e) {
      showToast(e.message!);
      DataBaseServices().logoutAuth(false);
    }
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) => CircularProgressIndicator(),
      ),
    );
  }
}

class CheckStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('user');
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        body: StreamBuilder(
      stream: users.doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          DataBaseServices().logoutAuth(false);
          return LoginPageMobile();
        } else if (snapshot.hasData) {
          if (snapshot.data!['isDisable'] == false) {
            DataBaseServices().logoutAuth(false);
          } else {
            return MyHomePage();
          }
        }
        return CircularProgressIndicator();
      },
    ));
  }
}
