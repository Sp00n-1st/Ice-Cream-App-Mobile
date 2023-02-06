import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ice_mobile/main.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void route() {
    Get.offAll(Check());
  }

  initialRoute() {
    var duration = Duration(milliseconds: 3500);
    return Timer(duration, route);
  }

  @override
  void initState() {
    initialRoute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
            width: 200, height: 200, child: Image.asset('assets/iconice.png')),
        SizedBox(
          height: 40,
        ),
        AnimatedTextKit(animatedTexts: [
          WavyAnimatedText('Sweet Dream',
              speed: Duration(milliseconds: 250),
              textStyle:
                  GoogleFonts.lemon(fontSize: 30, color: Color(0xff404258)))
        ])
      ]),
    ));
  }
}
