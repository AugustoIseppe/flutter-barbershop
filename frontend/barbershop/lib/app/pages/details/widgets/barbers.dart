import 'package:barbershop/app/pages/details/barber_details.dart';
import 'package:barbershop/app/pages/details/barber_store.dart';
import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Barbers extends StatefulWidget {
  const Barbers({super.key});

  @override
  State<Barbers> createState() => _BarbersState();
}

class _BarbersState extends State<Barbers> {
  @override
  Widget build(BuildContext context) {
    ColorsPalletes colorsPalletes = ColorsPalletes();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nosso time de barbeiros',
            style: GoogleFonts.lato(
              color: colorsPalletes.nonaryColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 90, // Defina uma altura adequada
            child: Consumer<BarberStore>(
              builder: (context, store, child) {
                if (store.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (store.error.isNotEmpty) {
                  return Center(child: Text(store.error));
                }
                if (store.barbers.isEmpty) {
                  return Container();
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: store.barbers.length,
                  itemBuilder: (context, index) {
                    final barber = store.barbers[index];
                    print(barber.barbername);
                    return GestureDetector(
                      onTap: () {
                        // Navegação para a tela de detalhes do barbeiro
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BarberDetails(barber: barber.toMap()))); 
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: colorsPalletes.white,
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(
                                    "http://10.0.2.2:8800/users/uploads/${barber.barberimage}"),
                              ),
                            ),
                            Text(
                              barber.barbername,
                              style: GoogleFonts.lato(
                                color: colorsPalletes.nonaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
