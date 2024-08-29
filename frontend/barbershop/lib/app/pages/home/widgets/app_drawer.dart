import 'package:barbershop/app/data/auth/auth.dart';
import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:barbershop/app/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.colorsPalletes,
  });

  final ColorsPalletes colorsPalletes;

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: false);

    return Drawer(
      backgroundColor: colorsPalletes.primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorsPalletes.primaryColor,
              image: const DecorationImage(
                  image: AssetImage('assets/images/logo2.jpeg'),
                  fit: BoxFit.fitWidth,
                  opacity: 0.8),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'BarberShop',
                style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: colorsPalletes.nonaryColor,
                    letterSpacing: 4.0,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 5.0,
                        color: colorsPalletes.secondaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      FaIcon(FontAwesomeIcons.house).icon,
                      color: colorsPalletes.nonaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Home',
                      style: GoogleFonts.abel(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorsPalletes.nonaryColor,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  color: colorsPalletes.nonaryColor,
                ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      FaIcon(FontAwesomeIcons.scissors).icon,
                      color: colorsPalletes.nonaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Barbearias',
                      style: GoogleFonts.abel(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorsPalletes.nonaryColor,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  color: colorsPalletes.nonaryColor,
                ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/barbershop-page');
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      FaIcon(FontAwesomeIcons.userLarge).icon,
                      color: colorsPalletes.nonaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Perfil',
                      style: GoogleFonts.abel(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorsPalletes.nonaryColor,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  color: colorsPalletes.nonaryColor,
                ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/user-profile');
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      FaIcon(FontAwesomeIcons.xmark).icon,
                      color: colorsPalletes.nonaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Sair',
                      style: GoogleFonts.abel(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorsPalletes.nonaryColor,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  color: colorsPalletes.nonaryColor,
                ),
              ],
            ),
            onTap: () async {
              await auth.logout();

              // Verifica se os dados foram removidos corretamente
              final storedUserData =
                  await Preferences.getMap('userDataSharedPreferences');
              print('Dados após logout: $storedUserData');

              // Navega para a página de login
              Navigator.of(context).pushReplacementNamed('/login-page');
            },
          ),
        ],
      ),
    );
  }
}
