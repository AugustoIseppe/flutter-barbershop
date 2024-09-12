import 'package:barbershop/app/pages/home/best_rated_barber_store.dart';
import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BestRatedBarber extends StatefulWidget {
  const BestRatedBarber({super.key});

  @override
  State<BestRatedBarber> createState() => _BestRatedBarberState();
}

class _BestRatedBarberState extends State<BestRatedBarber> {
  @override
  Widget build(BuildContext context) {
    final ColorsPalletes colorsPalletes = ColorsPalletes();
    return Consumer(
      builder: (context, BestRatedBarberStore store, child) {
        if (store.error.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              color: colorsPalletes.nonaryColor,
              child: Center(
                child: Text(
                  "Erro ao carregar melhores barbeiros ${store.error.toString()}",
                  style: GoogleFonts.abel(
                    color: colorsPalletes.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          );
        }
        if (store.bestRatedBarbers.isEmpty) {
          return const Center(
            child: Text('Nenhum barbeiro encontrado', style: TextStyle(fontSize: 20, color: Colors.white)),
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Divider(
              color: colorsPalletes.denaryColor,
              thickness: .5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    'MAIS PROCURADOS'.toUpperCase(),
                    style: GoogleFonts.abel(
                      color: colorsPalletes.denaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.star,
                  color: colorsPalletes.denaryColor,
                  size: 19,
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.155,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: store.bestRatedBarbers.length,
                    itemBuilder: (context, index) {
                      final bestRatedBarber = store.bestRatedBarbers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                              CircleAvatar(
                                radius: 36,
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(
                                  "http://10.0.2.2:8800/users/uploads/${bestRatedBarber.barberimage}"
                                  ),
                                ),
                              ),
                              Container(
                                width: 21,
                                height: 21,
                                decoration: BoxDecoration(
                                  color: colorsPalletes.nonaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    bestRatedBarber.barberqtdservices.toString(),
                                    style: GoogleFonts.lato(
                                      color: colorsPalletes.primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                              ] 
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: [
                                  Text(
                                    bestRatedBarber.barbername.toUpperCase(),
                                    style: GoogleFonts.abel(
                                      color: colorsPalletes.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    bestRatedBarber.name.toUpperCase(),
                                    style: GoogleFonts.abel(
                                      color: colorsPalletes.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          ],
        );
      },
    );
  }
}
