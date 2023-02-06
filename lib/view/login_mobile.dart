import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/globals.dart' as globals;
import '../service/database.dart';
import '../utils/funtions.dart';
import 'register_mobile.dart';

class LoginPageMobile extends StatefulWidget {
  @override
  State<LoginPageMobile> createState() => _LoginPageMobileState();
}

class _LoginPageMobileState extends State<LoginPageMobile> {
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  double getWidthImage(BuildContext context) =>
      MediaQuery.of(context).size.width * 1;

  double getHeightImage(BuildContext context) =>
      MediaQuery.of(context).size.height * 1;

  String? email;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              width: getWidthImage(context),
              height: getHeightImage(context),
              child: const Image(
                image: AssetImage('assets/ice0.5.jfif'),
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '     Sweet',
                          style: GoogleFonts.lemon(
                              fontSize: 50, color: const Color(0xffffffff)),
                          maxLines: 2,
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '          dream',
                          style: GoogleFonts.lemon(
                              fontSize: 50, color: const Color(0xffffffff)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getHeightImage(context) / 12,
                    ),
                    GlassContainer(
                      borderColor: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      height: 350,
                      width: 350,
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.withOpacity(0.30),
                          Colors.white.withOpacity(0.30)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderGradient: const LinearGradient(
                        colors: [
                          Colors.white, //.withOpacity(0.50),
                          Colors.white, //.withOpacity(0.50),
                          Colors.white, //.withOpacity(0.50),
                          Colors.white, //.withOpacity(0.50)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      blur: 2.0,
                      borderWidth: 0.1,
                      elevation: 10,
                      isFrostedGlass: true,
                      shadowColor: Colors.black.withOpacity(0.20),
                      alignment: Alignment.center,
                      frostedOpacity: 0.1,
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: GoogleFonts.poppins(
                                    color: Color(0xffffffff), fontSize: 20),
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
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  cursorColor: Colors.orange,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Input Email'),
                                ),
                              ),
                              Text(
                                'Password',
                                style: GoogleFonts.poppins(
                                    color: Color(0xffffffff), fontSize: 20),
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
                                  obscureText: true,
                                  controller: passwordController,
                                  cursorColor: Colors.orange,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Input Password'),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        emailController.clear();
                                        passwordController.clear();
                                        Get.to(RegisterMobile(),
                                            duration:
                                                Duration(milliseconds: 500),
                                            transition:
                                                Transition.circularReveal);
                                      },
                                      child: Text(
                                        'Register',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        // CODE HERE: Send reset code to the given email
                                        try {
                                          await FirebaseAuth.instance
                                              .sendPasswordResetEmail(
                                                  email: '');
                                        } on FirebaseAuthException catch (e) {
                                          showNotification(
                                              context, e.message.toString());
                                        }
                                      },
                                      child: Text(
                                        'Forgot password?',
                                        maxLines: 1,
                                        style: TextStyle(color: Colors.black),
                                      )),
                                ],
                              ),
                              Center(
                                child: Container(
                                    margin: EdgeInsets.only(top: 20),
                                    width: getWidthImage(context) / 2,
                                    height: 50,
                                    child: StatefulBuilder(
                                      builder: (context, setState) => SizedBox(
                                        width: getWidthImage(context) / 6,
                                        height: getHeightImage(context) * 0.06,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: const StadiumBorder()),
                                            onPressed: () async {
                                              if (FirebaseAuth
                                                      .instance.currentUser ==
                                                  null) {
                                                try {
                                                  setState(
                                                    () {
                                                      globals.isLogin =
                                                          !globals.isLogin;
                                                    },
                                                  );
                                                  await DataBaseServices()
                                                      .loginAuth(
                                                          context,
                                                          emailController.text,
                                                          passwordController
                                                              .text);
                                                } on FirebaseAuthException catch (e) {
                                                  setState(
                                                    () {
                                                      globals.isLogin =
                                                          !globals.isLogin;
                                                    },
                                                  );
                                                  showNotification(context,
                                                      e.message.toString());
                                                }
                                              } else {
                                                await FirebaseAuth.instance
                                                    .signOut();
                                              }
                                            },
                                            child: (globals.isLogin == false)
                                                ? Text(
                                                    'Login',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 18),
                                                  )
                                                : const CircularProgressIndicator(
                                                    color: Colors.black,
                                                    backgroundColor:
                                                        Colors.white,
                                                  )),
                                      ),
                                    )),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
