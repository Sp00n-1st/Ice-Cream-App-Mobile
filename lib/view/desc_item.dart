import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class DescItem extends StatelessWidget {
  String title, per;
  double needs, gram;

  DescItem(this.needs, this.gram, this.title, this.per, {super.key});
  @override
  Widget build(BuildContext context) {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    num persen = gram / needs * 100;
    persen = num.parse(persen.toStringAsFixed(2));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              GoogleFonts.roboto(color: const Color(0xff4d4d4d), fontSize: 20),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Text(
              '${persen.toString().replaceAll(regex, '')}%',
              style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              '${gram.toString().replaceAll(regex, '')} ${per}',
              style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ],
        )
      ],
    );
  }
}
