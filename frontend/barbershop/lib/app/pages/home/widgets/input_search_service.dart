import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:validatorless/validatorless.dart';

class InputServiceService extends StatelessWidget {
  const InputServiceService({
    super.key,
    required this.colorsPalletes,
  });

  final ColorsPalletes colorsPalletes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        // controller: _confirmPasswordController,
        decoration: InputDecoration(
          hintText: "Pesquisar",
          hintStyle: TextStyle(
            fontSize: 15,
            color: colorsPalletes.secondaryColor,
          ),
          filled: true,
          fillColor: colorsPalletes.white.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
            borderSide: BorderSide(
              color: colorsPalletes.secondaryColor,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
            borderSide: BorderSide(
              color: colorsPalletes.secondaryColor,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
            borderSide: BorderSide(
              color: colorsPalletes.secondaryColor,
              width: 1.0,
            ),
          ),
          prefixIcon: Icon(
            // Iconsax.search_favorite,
            Ionicons.search_outline,
            color: colorsPalletes.secondaryColor,
            size: 20,
          ),
        ),
        style: GoogleFonts.lato(
          color: colorsPalletes.secondaryColor,
        ),
        cursorColor: colorsPalletes.secondaryColor,
        validator: Validatorless.multiple([
          Validatorless.required('A senha não é igual a anterior'),
          Validatorless.min(6, 'A senha não é igual a anterior'),
        ]),
      ),
    );
  }
}
