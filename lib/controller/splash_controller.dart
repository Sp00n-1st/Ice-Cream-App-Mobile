import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ice_mobile/controller/auth_controller.dart';
import 'package:oktoast/oktoast.dart';
import '../view/home.dart';
import '../view/login_mobile.dart';

class SplashController extends GetxController {
  var authController = Get.put(AuthController());
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void onReady() {
    try {
      if (user != null) {
        Future.delayed(
            Duration(milliseconds: 3000), () => Get.offAll(MyHomePage()));
      } else {
        Future.delayed(
            Duration(milliseconds: 3000), () => Get.offAll(LoginPageMobile()));
      }
    } on FirebaseAuthException catch (e) {
      showToast(e.message!);
      authController.logoutAuth(false);
    }
    super.onReady();
  }
}
