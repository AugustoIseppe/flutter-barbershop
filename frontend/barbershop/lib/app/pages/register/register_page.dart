import 'package:barbershop/app/pages/register/widgets/form_register.dart';
import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    ColorsPalletes colorsPallete = ColorsPalletes();
    return Scaffold(
      appBar: AppBar(
        
        title: Text(
          "Cadastro",
          style: GoogleFonts.lato(
            color: colorsPallete.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorsPallete.secondaryColor,
        foregroundColor: colorsPallete.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: colorsPallete.primaryColor,
        ),
        child: const FormRegister(),
      ),
    );
  }
}

