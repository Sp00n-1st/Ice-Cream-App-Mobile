import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import '../controller/auth_controller.dart';
import '../controller/controller.dart';
import '../controller/createUser_controller.dart';
import '../controller/password_controller.dart';

// ignore: must_be_immutable
class RegisterMobile extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  var createController = Get.put(CreateUserController());
  var authController = Get.put(AuthController());
  var passController = Get.put(PasswordController());
  var controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          width: sizeWidth,
          height: sizeHeight,
          child: Image.asset(
            'assets/bg1.jpg',
            fit: BoxFit.fill,
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          margin: EdgeInsets.only(top: 80, bottom: 70, right: 25, left: 25),
          width: sizeWidth,
          height: sizeHeight,
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register Form',
                    style: GoogleFonts.poppins(fontSize: 24),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('First Name', style: GoogleFonts.poppins(fontSize: 18)),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: firstNameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.blue.shade900, width: 1.5)),
                      hintText: 'Input First Name',
                      border: OutlineInputBorder(
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
                  SizedBox(
                    height: 20,
                  ),
                  Text('Last Name', style: GoogleFonts.poppins(fontSize: 18)),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: lastNameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.blue.shade900, width: 1.5)),
                      hintText: 'Input Last Name',
                      border: OutlineInputBorder(
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
                  SizedBox(
                    height: 10,
                  ),
                  Text('Email', style: GoogleFonts.poppins(fontSize: 18)),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.blue.shade900, width: 1.5)),
                      hintText: 'Input Email',
                      border: OutlineInputBorder(
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
                  SizedBox(
                    height: 10,
                  ),
                  Text('Password', style: GoogleFonts.poppins(fontSize: 18)),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.blue.shade900, width: 1.5)),
                      hintText: 'Input Password',
                      border: OutlineInputBorder(
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
                  SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () {
                      return (authController.isLogin.isFalse)
                          ? Center(
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                elevation: 5,
                                child: Container(
                                  width: 200,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                          colors: [
                                            Color(0xff667db6),
                                            Color(0xff0082c8),
                                            Color(0xff0082c8),
                                            Color(0xff667db6),
                                          ],
                                          begin: FractionalOffset.topLeft,
                                          end: FractionalOffset.bottomRight)),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      splashColor: Colors.grey,
                                      onTap: () async {
                                        if (firstNameController
                                                .text.isNotEmpty &&
                                            lastNameController
                                                .text.isNotEmpty &&
                                            emailController.text.isNotEmpty &&
                                            passwordController
                                                .text.isNotEmpty) {
                                          try {
                                            authController.isLogin.value =
                                                !authController.isLogin.value;
                                            await createController
                                                .createUserWithEmail(
                                                    emailController.text,
                                                    passwordController.text,
                                                    passController.encryptPass(
                                                        passwordController
                                                            .text),
                                                    firstNameController.text,
                                                    lastNameController.text,
                                                    null,
                                                    null,
                                                    context);
                                            firstNameController.clear();
                                            lastNameController.clear();
                                            emailController.clear();
                                            passwordController.clear();
                                          } on FirebaseAuthException catch (e) {
                                            authController.isLogin.value =
                                                !authController.isLogin.value;
                                            controller.showNotification(
                                                context, e.message.toString());
                                          }
                                        } else {
                                          showToast(
                                              'Please Enter All Data Required !',
                                              position: ToastPosition(
                                                  align:
                                                      Alignment.bottomCenter),
                                              backgroundColor: Colors.red);
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          'Register',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Center(child: CircularProgressIndicator());
                    },
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
