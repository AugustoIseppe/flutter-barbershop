import 'package:barbershop/app/data/auth/auth.dart';
import 'package:barbershop/app/pages/home/home_page.dart';
import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({
    super.key,
  });

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  // Map<String, dynamic> _formDataLogin = {};
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _loginPage() async {
    Auth auth = Provider.of<Auth>(context, listen: false);
    try {
      if (_formKey.currentState!.validate()) {
        final teste = await auth.login(
          _emailController.text,
          _passwordController.text,
        );
        print('USERDATA LOGINPAGE: ${teste[0].toMap()}');
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userData: auth.userData)));
      }
    } catch (e) {
      print('Erro ao fazer login: $e');
      _showErrorDialog(
          'Credenciais inválidas. Tente novamente ou contate o administrador');
    }
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        backgroundColor: Colors.grey[300],
        title: const Text(
          "Erro ao realizar login",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'NotoSans',
            fontSize: 14,
          ),
        ),
        content: Text(
          msg,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'NotoSans',
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
            child: const Center(
              child: Text(
                "Fechar",
                style: TextStyle(
                  fontFamily: 'NotoSans',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorsPalletes colorsPallete = ColorsPalletes();

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "E-mail",
                          hintStyle: TextStyle(
                            color: colorsPallete.secondaryColor,
                          ),
                          filled: true,
                          fillColor: colorsPallete.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            borderSide: BorderSide(
                              color: colorsPallete.secondaryColor,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            borderSide: BorderSide(
                              color: colorsPallete.secondaryColor,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            borderSide: BorderSide(
                              color: colorsPallete.secondaryColor,
                              width: 1.0,
                            ),
                          ),
                          prefixIcon: Icon(
                            Iconsax.user,
                            color: colorsPallete.secondaryColor,
                          ),
                        ),
                        style: GoogleFonts.lato(
                          color: colorsPallete.secondaryColor,
                          // fontWeight: FontWeight.bold,
                        ),
                        cursorColor: colorsPallete.secondaryColor,
                        validator: Validatorless.multiple([
                          Validatorless.required('E-mail é obrigatório'),
                          Validatorless.email('E-mail inválido'),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: "Senha",
                          hintStyle: TextStyle(
                            color: colorsPallete.secondaryColor,
                          ),
                          filled: true,
                          fillColor: colorsPallete.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            borderSide: BorderSide(
                              color: colorsPallete.secondaryColor,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            borderSide: BorderSide(
                              color: colorsPallete.secondaryColor,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            borderSide: BorderSide(
                              color: colorsPallete.secondaryColor,
                              width: 1.0,
                            ),
                          ),
                          prefixIcon: Icon(
                            Iconsax.lock,
                            color: colorsPallete.secondaryColor,
                          ),
                        ),
                        style: GoogleFonts.lato(
                          color: colorsPallete.secondaryColor,
                        ),
                        cursorColor: colorsPallete.secondaryColor,
                        validator: Validatorless.multiple([
                          Validatorless.required('E-mail é obrigatório'),
                          Validatorless.min(6, 'Senha muito curta'),
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: colorsPallete.secondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                          ),
                          onPressed: () {
                            // Navigator.pushNamed(context, "/home");
                            print(_emailController.text);
                            print(_passwordController.text);
                            _loginPage();
                          },
                          child: Text(
                            "Entrar",
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: colorsPallete.denaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      // height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/register-page");
                            },
                            child: Text(
                              "Cadastrar",
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                color: colorsPallete.denaryColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: colorsPallete.denaryColor,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/forgot-password");
                            },
                            child: Text(
                              "Esqueci a senha",
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                color: colorsPallete.denaryColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: colorsPallete.denaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
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
