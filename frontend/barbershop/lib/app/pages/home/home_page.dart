import 'package:barbershop/app/pages/home/barbershop_store.dart';
import 'package:barbershop/app/pages/home/best_rated_barber_store.dart';
import 'package:barbershop/app/pages/home/widgets/app_drawer.dart';
import 'package:barbershop/app/pages/home/widgets/barbershop_card.dart';
import 'package:barbershop/app/pages/home/widgets/best_rated_barber.dart';
import 'package:barbershop/app/pages/home/widgets/input_search_service.dart';
import 'package:barbershop/app/pages/home/widgets/welcome_header.dart';
import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  Map<String, dynamic> userData;
  HomePage({super.key, required this.userData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final store = Provider.of<BarbershopStore>(context, listen: false);
    store.getBarbershops();
    final bestRatedBarberStore = Provider.of<BestRatedBarberStore>(context, listen: false);
    bestRatedBarberStore.getBestRatedBarbers();
  }

  @override
  Widget build(BuildContext context) {
    final ColorsPalletes colorsPalletes = ColorsPalletes();
    return SafeArea(
      child: Scaffold(
        drawer: AppDrawer(colorsPalletes: colorsPalletes),
        backgroundColor: colorsPalletes.primaryColor,
        appBar: AppBar(
          backgroundColor: colorsPalletes.primaryColor,
          foregroundColor: colorsPalletes.white,
          title: Text(
            'BarberShop',
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorsPalletes.white,
                letterSpacing: 2.0,
              ),
            ),
          ),
          centerTitle: true,
        ),
        // ignore: prefer_const_constructors
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 15,
              top: 10,
              bottom: 10,
            ),
            child: Column(
              children: [
                WelcomeHeader(userData: widget.userData),
                const SizedBox(height: 20),
                InputServiceService(colorsPalletes: colorsPalletes),
                const BestRatedBarber(),
                BarbershopCard(userData: widget.userData),
                // const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


