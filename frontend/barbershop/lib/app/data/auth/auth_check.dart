import 'package:barbershop/app/data/auth/auth.dart';
import 'package:barbershop/app/pages/home/home_page.dart';
import 'package:barbershop/app/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final auth = Provider.of<Auth>(context, listen: false);
    final isAutoLoggedIn = await auth.tryAutoLogin();

    if (!isAutoLoggedIn) {
      // Caso não consiga realizar o auto login, limpa os dados para garantir que a UI esteja correta
      auth.logout();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (auth.isAuth) {
      return HomePage(userData: auth.userData);
    } else {
      return const LoginPage();
    }
  }
}
