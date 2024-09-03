import 'package:barbershop/app/pages/details/details_page.dart';
import 'package:barbershop/app/pages/home/barbershop_store.dart';
import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ionicons/ionicons.dart';

class BarbershopCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  const BarbershopCard({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    final ColorsPalletes colorsPalletes = ColorsPalletes();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Divider(
          color: colorsPalletes.denaryColor,
          thickness: .5,
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                'Barbearias'.toUpperCase(),
                style: GoogleFonts.abel(
                  color: colorsPalletes.denaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              Ionicons.cut_sharp,
              color: colorsPalletes.denaryColor,
              size: 19,
            ),
          ],
        ),
        Consumer(
          builder: (context, BarbershopStore store, child) {
            if (store.isLoading) {
              return Center(
                child: SpinKitFadingCircle(
                  color: colorsPalletes.septenaryColor,
                  size: 50.0,
                ),
              );
            }
            if (store.error.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  color: colorsPalletes.nonaryColor,
                  child: Center(
                    child: Text(
                      "Erro ao carregar barbearias ASDASDASD ${store.error.toString()}",
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
            if (store.barbershops.isEmpty) {
              return const Center(
                child: Text('Nenhuma barbearia encontrada'),
              );
            }
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: store.barbershops.length,
                itemBuilder: (context, index) {
                  final barbershop = store.barbershops[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: colorsPalletes.secondaryColor,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: colorsPalletes.denaryColor,
                              width: .4,
                            ),
                          ),
                          width: 190,
                          height: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    barbershop.imageUrl,
                                    fit: BoxFit.cover,
                                    height: 170,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 0),
                                child: Text(
                                  'Aberto Agora - 9:00-21:00',
                                  style: GoogleFonts.abel(
                                    color: colorsPalletes.denaryColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  barbershop.name.toUpperCase(),
                                  style: GoogleFonts.abel(
                                    color: colorsPalletes.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: colorsPalletes.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        height: 41,
                                        width: 41,
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(
                                            Ionicons.bookmark_outline,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ElevatedButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              colorsPalletes.nonaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => DetailsPage(
                                                userData: userData,
                                                barbershop: barbershop,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text('Serviços'.toUpperCase(),
                                            style: GoogleFonts.lato(
                                              color: colorsPalletes.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w900,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
