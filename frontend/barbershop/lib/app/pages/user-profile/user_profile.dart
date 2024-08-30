import 'package:barbershop/app/data/auth/auth.dart';
import 'package:barbershop/app/data/http/http_client.dart';
import 'package:barbershop/app/data/repositories/user_repository.dart';
import 'package:barbershop/app/pages/user-profile/user_store.dart';
import 'package:barbershop/app/pages/user-profile/widgets/info_consumer.dart';
import 'package:barbershop/app/pages/user-profile/widgets/photo_and_name.dart';
import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:barbershop/app/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'widgets/header_user_page.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    //* Função para exibir um SnackBar no topo da tela
    void showTopSnackBar(BuildContext context, String message, Color colorIcon,
        Color colorBackground, IconData icon) {
      final overlay = Overlay.of(context);
      final snackBar = OverlayEntry(
        builder: (context) => Positioned(
          top: 50, // Distância do topo da tela
          // left: MediaQuery.of(context).size.width * 0.1, // Margem esquerda
          width: MediaQuery.of(context).size.width, // Largura do SnackBar
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: colorBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  child: Icon(
                    icon,
                    color: colorIcon,
                    size: 20,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  message,
                  style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
          ),
        ),
      );

      overlay.insert(snackBar);

      // Remover o SnackBar após a duração especificada
      Future.delayed(Duration(seconds: 5)).then((_) => snackBar.remove());
    }
    final _formKey = GlobalKey<FormState>();
    final _formKey1 = GlobalKey<FormState>();

    final ColorsPalletes colorsPalletes = ColorsPalletes();
    final UserStore userStore = Provider.of(context, listen: false);
    final Auth auth = Provider.of<Auth>(context, listen: false);
    TextEditingController newPhone =
        TextEditingController(text: auth.userData['phone']);
    TextEditingController newEmail =
        TextEditingController(text: auth.userData['email']);
    TextEditingController oldPassword = TextEditingController();
    TextEditingController newPassword = TextEditingController();
    TextEditingController newPasswordConfirm = TextEditingController();
    final UserRepository userRepository = UserRepository(client: HttpClient());
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorsPalletes.secondaryColor,
                colorsPalletes.secondaryColor,
                colorsPalletes.primaryColor,
                colorsPalletes.primaryColor,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // color: Colors.white,
                child: Column(
                  children: [
                    //* Header
                    HeaderUserPage(),
                    //* Photo and Name - User
                    PhotoAndName(auth: auth, colorsPalletes: colorsPalletes),
                    Container(
                      // color: Colors.red,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      'Suas informações',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          // fontWeight: FontWeight.bold,
                                          color: colorsPalletes.nonaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          //* Info Consumer
                          InfoConsumer(
                              colorsPalletes: colorsPalletes, auth: auth),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //!----------------- BOTÕES DE EDIÇÃO (editar perfil)-------------------
              Container(
                margin:
                    EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: colorsPalletes.primaryColor,
                                  title: Text(
                                    'Editar Perfil',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: colorsPalletes.nonaryColor,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.8, // Defina a largura desejada
                                    height: 120,
                                    child: Column(
                                      children: [
                                        Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller: newPhone,
                                                style: GoogleFonts.lato(
                                                  color: colorsPalletes.white,
                                                ),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    color: colorsPalletes.white,
                                                  ),
                                                  labelText: 'Telefone',
                                                  hintText:
                                                      'Digite seu telefone',
                                                  labelStyle: TextStyle(
                                                    color: colorsPalletes.white,
                                                  ),
                                                ),
                                              ),
                                              TextFormField(
                                                controller: newEmail,
                                                style: GoogleFonts.lato(
                                                  color: colorsPalletes.white,
                                                ),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    color: colorsPalletes.white,
                                                  ),
                                                  labelText: 'Email',
                                                  hintText: 'Digite seu email',
                                                  labelStyle: TextStyle(
                                                    color: colorsPalletes.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    Column(
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    //!---------------ONTAP EDITAR PERFIL-------------------

                                                    final id = auth.userData['id'];
                                                    final email = newEmail.text;
                                                    final name = auth.userData['name'];
                                                    final password = auth.userData['password'];
                                                    final phone = newPhone.text;
                                                    print(id);
                                                    print(email);
                                                    print(name);
                                                    print(password);
                                                    print(phone);

                                                    // Chama o método getUsers da UserStore para atualizar os dados
                                                    await userStore.getUsers(
                                                      id,
                                                      newEmail.text,
                                                      name,
                                                      password,
                                                      newPhone.text,
                                                    );

                                                    // Após a atualização, você pode também atualizar os dados armazenados no Auth (opcional)
                                                    await auth.tryAutoLogin(); // Isso reatualiza os dados do usuário no Auth

                                                    // Redesenha a tela para refletir os novos dados
                                                    setState(() {});

                                                    // Exibe o SnackBar informando sucesso
                                                    // Exibe o SnackBar no topo
                                                    showTopSnackBar(
                                                        context,
                                                        'Dados atualizados com sucesso!',
                                                        Colors.greenAccent
                                                            .shade700,
                                                        Colors.greenAccent
                                                            .shade700,
                                                        Icons.check_circle);

                                                    // Fecha o AlertDialog
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                      color: colorsPalletes
                                                          .white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(Iconsax.refresh,
                                                              color: colorsPalletes
                                                                  .nonaryColor),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(
                                                            'Atualizar',
                                                            style: GoogleFonts
                                                                .lato(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: colorsPalletes
                                                                    .nonaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                      color: colorsPalletes
                                                          .white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                              Iconsax
                                                                  .close_square,
                                                              color: colorsPalletes
                                                                  .nonaryColor),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(
                                                            'Cancelar',
                                                            style: GoogleFonts
                                                                .lato(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: colorsPalletes
                                                                    .nonaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: colorsPalletes.secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Iconsax.edit,
                                    color: colorsPalletes.nonaryColor),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Editar Perfil',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: colorsPalletes.nonaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    //!----------------- BOTÕES DE EDIÇÃO (editar senha)-------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: colorsPalletes.primaryColor,
                                  title: Text(
                                    'Editar Senha',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: colorsPalletes.nonaryColor,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.8, // Defina a largura desejada
                                    height: 230,
                                    child: Column(
                                      children: [
                                        Form(
                                          key: _formKey1,
                                          child: Column(
                                            children: [
                                              //* Senha antiga
                                              TextFormField(
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Digite sua senha antiga';
                                                  }
                                                  if (value.length < 6) {
                                                    return 'A senha deve ter no mínimo 6 caracteres';
                                                  }
                                                  return null;
                                                },
                                                controller: oldPassword,
                                                style: GoogleFonts.lato(
                                                  color: colorsPalletes.white,
                                                ),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    color: colorsPalletes.white,
                                                  ),
                                                  labelText: 'Senha Antiga',
                                                  labelStyle: TextStyle(
                                                      color:
                                                          colorsPalletes.white,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              //* Nova senha
                                              TextFormField(
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Digite sua nova senha';
                                                  }
                                                  if (value.length < 6) {
                                                    return 'A senha deve ter no mínimo 6 caracteres';
                                                  }
                                                  return null;
                                                },
                                                controller: newPassword,
                                                style: GoogleFonts.lato(
                                                  color: colorsPalletes.white,
                                                ),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    color: colorsPalletes.white,
                                                  ),
                                                  labelText: 'Nova Senha',
                                                  labelStyle: TextStyle(
                                                      color:
                                                          colorsPalletes.white,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              //* Confirmar nova senha
                                              TextFormField(
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Confirme sua nova senha';
                                                  }
                                                  if (value.length < 6) {
                                                    return 'A senha deve ter no mínimo 6 caracteres';
                                                  }
                                                  if (value !=
                                                      newPassword.text) {
                                                    return 'As senhas não coincidem';
                                                  }
                                                  return null;
                                                },
                                                controller: newPasswordConfirm,
                                                style: GoogleFonts.lato(
                                                  color: colorsPalletes.white,
                                                ),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    color: colorsPalletes.white,
                                                  ),
                                                  labelText: 'Confirmar Senha',
                                                  labelStyle: TextStyle(
                                                      color:
                                                          colorsPalletes.white,
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    Column(
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    //!---------------ONTAP EDITAR SENHA-------------------
                                                    if (_formKey1.currentState!
                                                        .validate()) {
                                                      if (auth.userData[
                                                              'password'] !=
                                                          oldPassword.text) {
                                                        showTopSnackBar(
                                                            context,
                                                            'Senha antiga incorreta!',
                                                            Colors.redAccent
                                                                .shade700,
                                                            Colors.redAccent
                                                                .shade700,
                                                            Icons.error);
                                                        return;
                                                      } else {
                                                        print(
                                                            "oldPassword.text: ${oldPassword.text}");
                                                        print(
                                                            "newPassword.text: ${newPassword.text}");
                                                        print(
                                                            "newPasswordConfirm.text: ${newPasswordConfirm.text}");

                                                        final id =
                                                            auth.userData['id'];
                                                        final email = auth
                                                            .userData['email'];
                                                        final name = auth
                                                            .userData['name'];
                                                        final password =
                                                            newPassword.text;
                                                        final phone = auth
                                                            .userData['phone'];
                                                        print(id);
                                                        print(email);
                                                        print(name);
                                                        print(password);
                                                        print(phone);

                                                        // Chama o método getUsers da UserStore para atualizar os dados
                                                        await userStore
                                                            .getUsers(
                                                          id,
                                                          email,
                                                          name,
                                                          password,
                                                          phone,
                                                        );

                                                        // Após a atualização, você pode também atualizar os dados armazenados no Auth (opcional)
                                                        await auth
                                                            .tryAutoLogin(); // Isso reatualiza os dados do usuário no Auth

                                                        // Redesenha a tela para refletir os novos dados
                                                        setState(() {});

                                                        // Exibe o SnackBar informando sucesso
                                                        // Exibe o SnackBar no topo
                                                        showTopSnackBar(
                                                            context,
                                                            'Senha atualizada com sucesso!',
                                                            Colors.greenAccent
                                                                .shade700,
                                                            Colors.greenAccent
                                                                .shade700,
                                                            Icons.check_circle);

                                                        // Fecha o AlertDialog
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                      color: colorsPalletes
                                                          .secondaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(Iconsax.refresh,
                                                              color: colorsPalletes
                                                                  .nonaryColor),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(
                                                            'Atualizar',
                                                            style: GoogleFonts
                                                                .lato(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: colorsPalletes
                                                                    .nonaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                      color: colorsPalletes
                                                          .secondaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                              Iconsax
                                                                  .close_square,
                                                              color: colorsPalletes
                                                                  .nonaryColor),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(
                                                            'Cancelar',
                                                            style: GoogleFonts
                                                                .lato(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: colorsPalletes
                                                                    .nonaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: colorsPalletes.secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Iconsax.edit,
                                    color: colorsPalletes.nonaryColor),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Editar Senha',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: colorsPalletes.nonaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    //!----------------- BOTÕES DE EXCLUSÃO (excluir conta)-------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: colorsPalletes.primaryColor,
                                  title: Text(
                                    'Excluir Conta',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: colorsPalletes.nonaryColor,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.8, // Defina a largura desejada
                                    height: 65,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Tem certeza que deseja excluir sua conta?',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                              color: colorsPalletes.nonaryColor,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    Column(
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    //!--------------- ONTAP EXCLUIR CONTA -------------------
                                                    try {
                                                      final id =
                                                          auth.userData['id'];
                                                      await userRepository
                                                          .deleteUser(id);
                                                      await auth.logout();

                                                      // Verifica se os dados foram removidos corretamente
                                                      final storedUserData =
                                                          await Preferences.getMap(
                                                              'userDataSharedPreferences');
                                                      print(
                                                          'Dados após logout: $storedUserData');

                                                      // Navega para a página de login
                                                      Navigator.of(context)
                                                          .pushReplacementNamed(
                                                              '/login-page');
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                      color: colorsPalletes
                                                          .secondaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(Iconsax.refresh,
                                                              color: colorsPalletes
                                                                  .nonaryColor),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(
                                                            'Sim',
                                                            style: GoogleFonts
                                                                .lato(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: colorsPalletes
                                                                    .nonaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                      color: colorsPalletes
                                                          .secondaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                              Iconsax
                                                                  .close_square,
                                                              color: colorsPalletes
                                                                  .nonaryColor),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(
                                                            'Cancelar',
                                                            style: GoogleFonts
                                                                .lato(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: colorsPalletes
                                                                    .nonaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: colorsPalletes.secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Iconsax.trash,
                                    color: colorsPalletes.nonaryColor),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Excluir Conta',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: colorsPalletes.nonaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
