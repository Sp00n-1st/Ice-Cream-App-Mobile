import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Order extends StatelessWidget {
  String box1, box2, box3, box4, box5, box6;
  num totalAll;
  Order(
      {super.key,
      required this.box1,
      required this.box2,
      required this.box3,
      required this.box4,
      required this.box5,
      required this.box6,
      required this.totalAll});
  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 5),
            width: sizeWidth * 0.25,
            child: Text(
              box1,
              style: GoogleFonts.poppins(fontSize: 12),
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            width: sizeWidth * 0.15,
            child: Text(
              '£ ${NumberFormat.currency(locale: 'en', symbol: ' ').format(double.tryParse(box2))}',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            width: sizeWidth * 0.1,
            child: Center(
              child: Text(
                box3,
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            width: sizeWidth * 0.15,
            child: Text(
              '£ ${NumberFormat.currency(locale: 'en', symbol: ' ').format(double.tryParse(box4))}',
              style: GoogleFonts.poppins(fontSize: 12),
              overflow: TextOverflow.clip,
              softWrap: false,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            width: sizeWidth * 0.15,
            child: Text(
              '£ ${NumberFormat.currency(locale: 'en', symbol: ' ').format(double.tryParse(box5))}',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            width: sizeWidth * 0.15,
            child: Text(
              '£ ${NumberFormat.currency(locale: 'en', symbol: ' ').format(double.tryParse(box6))}',
              style: GoogleFonts.poppins(fontSize: 12),
              overflow: TextOverflow.clip,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}
