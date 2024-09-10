import 'package:barbershop/app/pages/booking/booking_store.dart';
import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> barbershopData;
  const BookingPage({
    super.key,
    required this.userData,
    required this.barbershopData,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  void initState() {
    super.initState();
    final store = Provider.of<BookingStore>(context, listen: false);
    store.getBookingById(widget.userData['id'], widget.barbershopData['id']);
  }

  String _formatTimeForPostgres(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    ColorsPalletes colorsPalletes = ColorsPalletes();
    return Scaffold(
      backgroundColor: colorsPalletes.primaryColor,
      appBar: AppBar(
        foregroundColor: colorsPalletes.nonaryColor,
        backgroundColor: colorsPalletes.primaryColor,
        title: Text(widget.barbershopData['name']),
        centerTitle: true,
      ),
      body: Consumer<BookingStore>(
        builder: (context, store, child) {
          if (store.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (store.error.isNotEmpty) {
            return Center(
              child: Text(store.error),
            );
          }
          if (store.bookings.isEmpty) {
            return Center(
              child: Text(
                'Ainda nao há agendamentos',
                style: GoogleFonts.lato(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: colorsPalletes.nonaryColor,
                ),
              ),
            );
          }
          // Agrupando os agendamentos por data
          Map<String, List<dynamic>> groupedBookings = {};

          for (var booking in store.bookings) {
            String formattedDate = DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(booking.date.toString()));
            if (!groupedBookings.containsKey(formattedDate)) {
              groupedBookings[formattedDate] = [];
            }
            groupedBookings[formattedDate]!.add(booking);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Histórico de Agendamentos',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: colorsPalletes.nonaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: store.bookings.length,
                    itemBuilder: (context, index) {
                      var booking = store.bookings[index];
                      String formattedDate = DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(booking.date.toString()));
                      String formattedTime = _formatTimeForPostgres(
                          DateTime.parse(booking.time.toString()));

                      // Agrupando os serviços da mesma reserva
                      List<dynamic> services = store.bookings
                          .where((b) =>
                              b.date == booking.date && b.time == booking.time)
                          .toList();
                      // List<dynamic> services = store.bookings.where((b) => b.id == booking.id).toList();

                      // Calculando o total para a reserva
                      double totalReserva = services.fold(
                          0, (sum, service) => sum + service.price);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Card(
                          color: colorsPalletes.secondaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$formattedDate | $formattedTime h",
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: colorsPalletes.nonaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...services.map(
                                  (service) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  service.imageUrl,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                service.name,
                                                style: GoogleFonts.lato(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'R\$ ${service.price.toStringAsFixed(2)}',
                                            style: GoogleFonts.lato(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                Divider(
                                  color: colorsPalletes.nonaryColor,
                                  thickness: 1,
                                ),
                                // Exibir o total da reserva
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'TOTAL: R\$ ${totalReserva.toStringAsFixed(2)}',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: colorsPalletes.nonaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
