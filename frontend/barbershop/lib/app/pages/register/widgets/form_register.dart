import 'dart:io';

import 'package:barbershop/app/data/http/http_client.dart';
import 'package:barbershop/app/data/repositories/user_repository.dart';
import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:validatorless/validatorless.dart';
import 'package:image_picker/image_picker.dart';

class FormRegister extends StatefulWidget {
  const FormRegister({super.key});

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    // ignore: empty_catches
    } catch (e) {
    }
  }



  void createUser() async {

    try {
      UserRepository repository = UserRepository(client: HttpClient());
      if (_formKey.currentState!.validate()) {
        final userResponse = await repository.createUser(
          _emailController.text,
          _nameController.text,
          _passwordController.text,
          _selectedImage,
          _phoneController.text,
        );
        if (userResponse.isNotEmpty) {
          _showDialog(userResponse.first['name']);
        } else {
        }
        
      }
    // ignore: empty_catches
    } catch (e) {
    }
  }

  _clearField() {
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
    _confirmPasswordController.clear();
    _phoneController.clear();
    setState(() {
      _selectedImage = null;
    });
  }

  _showDialog(String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorsPalletes().primaryColor,
          title: Text(
            'Usuário criado com sucesso!',
            style: GoogleFonts.lato(
              color: ColorsPalletes().denaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Bem-vindo, $userName!',
            style: GoogleFonts.lato(
              color: ColorsPalletes().nonaryColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _clearField();
                Navigator.of(context).pop();
              },
              child: Text(
                'Fechar',
                style: GoogleFonts.lato(
                  color: ColorsPalletes().quaternaryColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _clearField();
                Navigator.pushNamed(context, '/login-page');
              },
              child: Text(
                'Ir para o login',
                style: GoogleFonts.lato(
                  color: ColorsPalletes().quaternaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorsPalletes colorsPallete = ColorsPalletes();
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.92,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _selectedImage != null
                          ? InkWell(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                  radius: 80,
                                  backgroundImage: FileImage(_selectedImage!),
                                  child: const Text('')),
                            )
                          : InkWell(
                              onTap: _pickImage,
                              child: const SizedBox(
                                child: CircleAvatar(
                                    radius: 80,
                                    child: Icon(Icons.person,
                                        size: 100, color: Colors.grey)),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: "Nome",
                            hintStyle: TextStyle(
                              fontSize: 15,
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
                              size: 20,
                            ),
                          ),
                          style: GoogleFonts.lato(
                            color: colorsPallete.secondaryColor,
                            // fontWeight: FontWeight.bold,
                          ),
                          cursorColor: colorsPallete.secondaryColor,
                          validator: Validatorless.multiple([
                            Validatorless.required('Nome é obrigatório'),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "E-mail",
                            hintStyle: TextStyle(
                              fontSize: 15,
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
                              Icons.email_outlined,
                              color: colorsPallete.secondaryColor,
                              size: 20,
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
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Senha",
                            hintStyle: TextStyle(
                              fontSize: 15,
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
                              size: 20,
                            ),
                          ),
                          style: GoogleFonts.lato(
                            color: colorsPallete.secondaryColor,
                          ),
                          cursorColor: colorsPallete.secondaryColor,
                          validator: Validatorless.multiple([
                            Validatorless.required('A senha é obrigatório'),
                            Validatorless.min(
                                6, 'A senha deve ter no mínimo 6 caracteres'),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            hintText: "Confirmar senha",
                            hintStyle: TextStyle(
                              fontSize: 15,
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
                              size: 20,
                            ),
                          ),
                          style: GoogleFonts.lato(
                            color: colorsPallete.secondaryColor,
                          ),
                          cursorColor: colorsPallete.secondaryColor,
                          validator: Validatorless.multiple([
                            Validatorless.required(
                                'A senha não é igual a anterior'),
                            Validatorless.min(
                                6, 'A senha não é igual a anterior'),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: "Telefone",
                            hintStyle: TextStyle(
                              fontSize: 15,
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
                              Iconsax.call,
                              color: colorsPallete.secondaryColor,
                              size: 20,
                            ),
                          ),
                          style: GoogleFonts.lato(
                            color: colorsPallete.secondaryColor,
                          ),
                          cursorColor: colorsPallete.secondaryColor,
                          validator: Validatorless.multiple([
                            Validatorless.required(
                                'Insira um número de telefone'),
                            Validatorless.min(
                                6, 'A senha não é igual a anterior'),
                          ]),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Ao clicar em "Criar conta", você concorda com nossos Termos de Serviço e Política de Privacidade.',
                        style: GoogleFonts.lato(
                          color: colorsPallete.octonaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 70,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: colorsPallete.tertiaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    onPressed: () {
                      createUser();
                    },
                    child: Text(
                      "Criar conta",
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        color: colorsPallete.denaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
