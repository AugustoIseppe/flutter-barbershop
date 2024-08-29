import 'package:barbershop/app/pages/login/widgets/form_login.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/logo1.jpeg"),
              fit: BoxFit.fitHeight,
              filterQuality: FilterQuality.high,
            ),
          ),
          child: Stack(
            children: <Widget>[
              // Filtro de opacidade
              Opacity(
                opacity:
                    0.7, // Valor de 0.0 a 1.0 onde 0.0 é totalmente transparente e 1.0 é totalmente opaco
                child: Container(
                  color: Colors.black, // A cor que você deseja aplicar
                ),
              ),
              const FormLogin(),
            ],
          ),
        ),
      ),
    );
  }
}
