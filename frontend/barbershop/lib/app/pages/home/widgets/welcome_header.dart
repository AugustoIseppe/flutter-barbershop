import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeHeader extends StatefulWidget {
  final Map<String, dynamic> userData;
  const WelcomeHeader({super.key, required this.userData});

  @override
  State<WelcomeHeader> createState() => _WelcomeHeaderState();
}

class _WelcomeHeaderState extends State<WelcomeHeader> {
  @override
  Widget build(BuildContext context) {
    final ColorsPalletes colorsPalletes = ColorsPalletes();
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Olá, ${widget.userData['name']}',
          style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorsPalletes.white,
              letterSpacing: 2.0,
            ),
          ),
        ),
        // Text(userData['id'].toString(), style: TextStyle(color: Colors.white)),
        Row(
          children: [
            Text(
              '${now.weekday == 1 ? 'Segunda-feira' : now.weekday == 2 ? 'Terça-feira' : now.weekday == 3 ? 'Quarta-feira' : now.weekday == 4 ? 'Quinta-feira' : now.weekday == 5 ? 'Sexta-feira' : now.weekday == 6 ? 'Sábado' : 'Domingo'}, ',
              style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorsPalletes.white,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            Text(
              '${now.day}/${now.month}/${now.year}',
              style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorsPalletes.white,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
