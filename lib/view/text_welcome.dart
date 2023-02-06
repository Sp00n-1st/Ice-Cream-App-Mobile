import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/user.dart';

// ignore: must_be_immutable
class TextWelcome extends StatelessWidget {
  UserAccount? userAccount;
  TextWelcome({required this.userAccount});
  @override
  Widget build(BuildContext context) {
    return Text(
      userAccount!.firstName,
      style: GoogleFonts.poppins(color: Colors.black),
    );
  }
}
