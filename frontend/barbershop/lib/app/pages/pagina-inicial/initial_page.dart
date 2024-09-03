// import 'package:barbershop/app/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class InitialPage extends StatefulWidget {
  final Map<String, dynamic> userData;


  const InitialPage({super.key, required this.userData});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  late List<Widget> _pages;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      // Adicione outras páginas aqui
      // HomePage(userData: widget.userData,),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.white54,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
          selectedLabelStyle:
              GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          elevation: 10,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(

              icon: Icon(Iconsax.home_hashtag, color: Colors.red,),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.user, color: Colors.red,),
              label: 'Usuários',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Iconsax.shopping_bag),
            //   label: 'Produtos',
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(Iconsax.category),
            //   label: 'Categorias',
            // ),
          ],
        ),
      ),
    );
  }
}
