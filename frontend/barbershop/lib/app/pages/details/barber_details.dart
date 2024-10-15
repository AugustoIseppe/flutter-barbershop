import 'package:barbershop/app/data/model/barbershop_model.dart';
import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:barbershop/app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_media_buttons/social_media_buttons.dart';

class BarberDetails extends StatelessWidget {
  const BarberDetails(
      {super.key, required this.barber, required this.barbershop});

  final Map<String, dynamic> barber;
  final BarbershopModel barbershop;
  @override
  Widget build(BuildContext context) {
    ColorsPalletes colorsPalletes = ColorsPalletes();
    final Constants constants = Constants();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            barber["barbername"],
            style: TextStyle(
                fontWeight: FontWeight.bold, color: colorsPalletes.white),
          ),
          centerTitle: true,
          backgroundColor: colorsPalletes.primaryColor, // Cor personalizada
          foregroundColor: colorsPalletes.white, // Cor do ícone
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                // color: Colors.blue,
                image: DecorationImage(
                  image: NetworkImage(
                      "http://${constants.apiUrl}/users/uploads/${barber['barberimage']}"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorsPalletes.primaryColor.withOpacity(0),
                    colorsPalletes.primaryColor.withOpacity(0),
                    colorsPalletes.primaryColor.withOpacity(0),
                    colorsPalletes.primaryColor.withOpacity(0),
                    colorsPalletes.primaryColor.withOpacity(0),
                    colorsPalletes.primaryColor.withOpacity(.5),
                    Colors.transparent.withOpacity(1),
                    Colors.transparent.withOpacity(1),
                    Colors.transparent.withOpacity(1),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              barber['barbername'],
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: colorsPalletes.white,
                              ),
                            ),
                            Text(
                              " - ${(barbershop.name)}",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: colorsPalletes.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          barbershop.address,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: colorsPalletes.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SocialMediaButton.whatsapp(
                                  url:
                                      "https://wa.me/${barber["barberwhatsapp"]}",
                                  color: colorsPalletes.white,
                                  size: 18,
                                ),
                                Text(
                                  "${barber["barberwhatsapp"]}  ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: colorsPalletes.white,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Iconsax.call,
                                    color: colorsPalletes.white, size: 18),
                                Text(
                                  " ${(barbershop.phones)}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: colorsPalletes.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
