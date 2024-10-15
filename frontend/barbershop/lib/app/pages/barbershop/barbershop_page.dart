import 'package:barbershop/app/data/auth/auth.dart';
import 'package:barbershop/app/pages/details/details_page.dart';
import 'package:barbershop/app/pages/home/barbershop_store.dart';
import 'package:barbershop/app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:barbershop/app/utils/colors_palletes.dart';

class BarbershopPage extends StatefulWidget {
  const BarbershopPage({super.key});

  @override
  State<BarbershopPage> createState() => _BarbershopPageState();
}

class _BarbershopPageState extends State<BarbershopPage> {
  @override
  void initState() {
    super.initState();
    final store = Provider.of<BarbershopStore>(context, listen: false);
    store.getBarbershops();
  }

  @override
  Widget build(BuildContext context) {
    final ColorsPalletes colorsPallete = ColorsPalletes();
    final Constants constants = Constants();
    final auth = Provider.of<Auth>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Imagem de fundo
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo1.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Camada escura sobre a imagem
            Container(
              color: Colors.black
                  .withOpacity(0.75), // Ajuste a opacidade conforme necessário
            ),
            // Conteúdo principal
            Column(
              children: [
                Container(
                  height: 60,
                  color: Colors.black.withOpacity(0.4),
                  child: Center(
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.19,
                        ),
                        Text(
                          'Barbearias',
                          style: GoogleFonts.aclonica(
                            textStyle: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Consumer<BarbershopStore>(
                    builder: (context, store, child) {
                      if (store.isLoading) {
                        return const Center(
                          child: SpinKitFadingCircle(
                            color: Color(0xff6f1610),
                            size: 50.0,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: store.barbershops.length,
                        itemBuilder: (context, index) {
                          final barbershop = store.barbershops[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                  userData: auth.userData,
                                  barbershop: barbershop,
                                ),
                              ));
                            },
                            child: Card(
                              color: index.isOdd
                                  ? colorsPallete.secondaryColor
                                  : colorsPallete.primaryColor,
                              child: ListTile(
                                leading: barbershop.imageUrl != ''
                                    ? CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            "http://${constants.apiUrl}/users/uploads/${barbershop.imageUrl}"),
                                      )
                                    : const CircleAvatar(
                                        radius: 30,
                                        backgroundImage: AssetImage(
                                          'assets/images/logo1.jpeg',
                                        ),
                                      ),
                                title: Text(
                                  barbershop.name,
                                  style: GoogleFonts.aclonica(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: colorsPallete.nonaryColor,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  barbershop.address,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        color: colorsPallete.nonaryColor),
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
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
          ],
        ),
      ),
    );
  }
}
