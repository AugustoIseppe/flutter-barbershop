import 'package:barbershop/app/data/http/http_client.dart';
import 'package:barbershop/app/data/model/barbershop_model.dart';
import 'package:barbershop/app/data/repositories/booking_repository.dart';
import 'package:barbershop/app/pages/booking/booking_page.dart';
import 'package:barbershop/app/pages/booking/booking_store.dart';
import 'package:barbershop/app/pages/details/barber_store.dart';
import 'package:barbershop/app/pages/details/details.store.dart';
import 'package:barbershop/app/pages/details/slots_store.dart';
import 'package:barbershop/app/pages/details/widgets/barbers.dart';
import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final BarbershopModel barbershop;

  const DetailsPage(
      {super.key, required this.barbershop, required this.userData});

  @override
  State<DetailsPage> createState() => _DatailsPageState();
}

class _DatailsPageState extends State<DetailsPage> {
  BookingRepository bookingRepository = BookingRepository(client: HttpClient());
  bool showServices = false;
  bool showBarbers = false;
  bool showDateService = false;
  List<bool>? _isCheckedList;
  List<String> _selectedServices = [];
  DateTime? _selectedDate;
  DateTime? _selectTime;

  DateTime? _confirmTime;
  DateTime? _confirmDate;
  String? _confirmId;
  String? _confirmTimeId;
  // String? _confirmBarbershopId;
  String? _confirmBarberId;
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: colorBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  child: Icon(
                    icon,
                    color: colorIcon,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  message,
                  style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(snackBar);

    // Remover o SnackBar após a duração especificada
    Future.delayed(const Duration(seconds: 3)).then((_) => snackBar.remove());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = Provider.of<DetailsStore>(context, listen: false);
      store.getBarbershopsWithServices(widget.barbershop.id.toString());

      final storeBooking = Provider.of<BookingStore>(context, listen: false);
      storeBooking.getBookingById(widget.userData['id'], widget.barbershop.id);

      final storeBarbers = Provider.of<BarberStore>(context, listen: false);
      storeBarbers.getBarbers(widget.barbershop.id);
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   final store = Provider.of<DetailsStore>(context, listen: false);
  //   store.getBarbershopsWithServices(widget.barbershop.id.toString());
  //   final storeBooking = Provider.of<BookingStore>(context, listen: false);
  //   storeBooking.getBookingById(widget.userData['id'], widget.barbershop.id);
  //   // final storeSlots = Provider.of<SlotsStore>(context, listen: false);
  //   final storeBarbers = Provider.of<BarberStore>(context, listen: false);
  //   storeBarbers.getBarbers(widget.barbershop.id);
  // }

  String _formatDateForPostgres(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatDateForView(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatTimeForPostgres(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  DateTime _formatDateForPostgres1(DateTime date) {
    // Retorna um DateTime apenas com a data (hora, minuto, segundo e milissegundo zerados)
    return DateTime(date.year, date.month, date.day);
  }

  _clearField() {
    setState(() {
      _selectedDate = null;
      _selectTime = null;
      _selectedServices = [];
      _isCheckedList = List<bool>.filled(_isCheckedList!.length, false);
    });
  }

  // void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  //   setState(() {
  //     if (args.value is DateTime) {
  //       _selectedDate = args.value;
  //     }
  //   });
  // }

  // final SlotsRepository slotsRepository =
  //     SlotsRepository(client: HttpClient());

  // Future<void> _fetchAndlogBarbershops() async {
  //   try {
  //     List<SlotsModel> slots =
  //         await slotsRepository.getSlots(widget.barbershop.id, '2024-08-19');
  //     slots.map((slots) {
  //       ;
  //       print('EITAAAAAAAA: ${_formatTimeForPostgres(slots.time)}');
  //     }).toList();
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<SlotsStore>(context, listen: false);
    _showDialog(DateTime date, DateTime time) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: ColorsPalletes().primaryColor,
            title: Text(
              'Confirmar Agendamento?',
              style: GoogleFonts.lato(
                color: ColorsPalletes().denaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Reserva para ${_formatDateForView(date)} às ${_formatTimeForPostgres(time)}h',
              style: GoogleFonts.lato(
                  color: ColorsPalletes().nonaryColor, fontSize: 13),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  // _clearField();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Não',
                  style: GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () async {
                  final userId = widget.userData['id'];
                  await bookingRepository.createBooking(
                    userId,
                    _selectedServices,
                    _confirmDate!,
                    _confirmTime!,
                  );
                  try {
                    print('ID: $_confirmId');
                    print('TimeID: $_confirmTimeId');
                    print('Date: ${_formatDateForPostgres(_confirmDate!)}');
                    print('Barerid: $_confirmBarberId');

                    store.updateSlots(
                      _confirmId!,
                      _confirmTimeId!,
                      _confirmDate!.toIso8601String(),
                      _confirmBarberId!,
                    );
                    print("_confirmBarberId: $_confirmBarberId");
                  } catch (e) {
                    throw Exception('Erro ao atualizar o slot: $e');
                  }
                  showTopSnackBar(
                    context,
                    'Agendamento realizado com sucesso!',
                    Colors.greenAccent.shade700,
                    Colors.greenAccent.shade700,
                    Icons.check_circle,
                  );
                  _clearField();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Sim',
                  style: GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ],
          );
        },
      );
    }

    final ColorsPalletes colorsPalletes = ColorsPalletes();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: colorsPalletes.white,
          centerTitle: true,
          actions: [
            Consumer<BookingStore>(
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

                // Acessando o primeiro serviço para pegar a data
                final firstBooking =
                    store.bookings.isNotEmpty ? store.bookings.first : null;

                if (firstBooking != null) {
                  // Formatando a data para o formato dia/mês/ano
                  DateTime.parse(store.bookings.first.date.toString());
                }
                return Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BookingPage(
                              barbershopData: widget.barbershop.toMap(),
                              userData: widget.userData,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Iconsax.archive_book,
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top:3,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.redAccent[700],
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          store.bookings.length.toString(),
                          style: GoogleFonts.lato(
                            color: colorsPalletes.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        backgroundColor: colorsPalletes.primaryColor,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.barbershop.imageUrl == ''
                      ? Image.asset(
                          'assets/images/logo1.jpeg',
                          width: MediaQuery.of(context).size.width,
                          height: 280,
                          fit: BoxFit.cover,
                        )
                      :
                  Image.network(
                      "http://10.0.2.2:8800/users/uploads/${widget.barbershop.imageUrl}",
                      width: MediaQuery.of(context).size.width,
                      height: 280,
                      fit: BoxFit.cover),
                  _buildBarbershopInfo(colorsPalletes),
                  _buildSectionDivider(colorsPalletes),
                  if (Provider.of<BarberStore>(context).barbers.isEmpty)
                    Container()
                  else
                    Barbers( barbershop: widget.barbershop),
                  if (Provider.of<BarberStore>(context).barbers.isNotEmpty)
                    _buildSectionDivider(colorsPalletes),
                  _buildAboutSection(colorsPalletes),
                  _buildSectionDivider(colorsPalletes),
                  _buildBarberSelector(colorsPalletes),
                  _buildServiceSelector(colorsPalletes),
                  _buildDateSelector(colorsPalletes),
                  _buildSectionDivider(colorsPalletes),
                  if (_selectedServices.isNotEmpty)
                    _buildServiceList(colorsPalletes),
                  if (_selectedServices.isNotEmpty)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: colorsPalletes.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        onPressed: () async {
                          if (_selectedServices.isEmpty) {
                            showTopSnackBar(
                              context,
                              'Selecione ao menos um serviço!',
                              Colors.redAccent.shade700,
                              Colors.redAccent.shade700,
                              Icons.error,
                            );
                          } else if (_selectedDate == null) {
                            showTopSnackBar(
                              context,
                              'Selecione uma data!',
                              Colors.redAccent.shade700,
                              Colors.redAccent.shade700,
                              Icons.calendar_month,
                            );
                          } else if (_confirmTime == null) {
                            showTopSnackBar(
                              context,
                              'Selecione um horário!',
                              Colors.redAccent.shade700,
                              Colors.redAccent.shade700,
                              Icons.time_to_leave,
                            );
                          }
                          _showDialog(_confirmDate!, _confirmTime!);
                          print(
                              'Data: ${_formatDateForPostgres(_confirmDate!)}');
                          print(
                              'Hora: ${_formatTimeForPostgres(_confirmTime!)}');
                        },
                        child: Text(
                          'Confirmar Agendamento',
                          style: GoogleFonts.lato(
                            color: colorsPalletes.nonaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                ],
              ),
              // _buildBackButton(colorsPalletes),
              if (showBarbers) _buildBarberCheckboxList(colorsPalletes),
              if (showDateService) _buildDatePicker(),
              if (showServices) _buildServiceModal(colorsPalletes),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildBarbershopInfo(ColorsPalletes colorsPalletes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.barbershop.name,
            style: GoogleFonts.lato(
              color: colorsPalletes.nonaryColor,
              fontSize: 35,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          // Text(widget.userData['id'].toString(),
          //     style: const TextStyle(color: Colors.white)),
          Row(
            children: [
              Icon(
                Iconsax.location,
                color: colorsPalletes.white,
                size: 15,
              ),
              const SizedBox(width: 5),
              Text(
                widget.barbershop.address,
                style: GoogleFonts.lato(
                  color: colorsPalletes.white,
                  fontSize: 14,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Ionicons.call_outline,
                color: colorsPalletes.white,
                size: 15,
              ),
              const SizedBox(width: 5),
              Text(widget.barbershop.phones,
                  style: GoogleFonts.lato(
                    color: colorsPalletes.white,
                    fontSize: 14,
                    // fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Divider _buildSectionDivider(ColorsPalletes colorsPalletes) {
    return Divider(
      color: colorsPalletes.nonaryColor,
      thickness: 1,
      endIndent: 15,
      indent: 15,
    );
  }

  Padding _buildAboutSection(ColorsPalletes colorsPalletes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sobre nós'.toUpperCase(),
            style: GoogleFonts.lato(
              color: colorsPalletes.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.barbershop.description,
            style: GoogleFonts.lato(
              color: colorsPalletes.white,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildBarberSelector(ColorsPalletes colorsPalletes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            showBarbers = !showBarbers;
          });
        },
        child: Card(
          color: colorsPalletes.secondaryColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Iconsax.personalcard,
                      color: colorsPalletes.nonaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 15),
                    Provider.of<BarberStore>(context).selectedBarberId != null
                        ? Text(
                            Provider.of<BarberStore>(context)
                                .barbers
                                .firstWhere((element) =>
                                    element.barberid ==
                                    Provider.of<BarberStore>(context)
                                        .selectedBarberId)
                                .barbername,
                            style: GoogleFonts.lato(
                              color: colorsPalletes.nonaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )
                        : Text(
                            'Selecione o profissional',
                            style: GoogleFonts.lato(
                              color: colorsPalletes.nonaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )
                  ],
                ),
                const SizedBox(width: 10),
                Icon(
                  Iconsax.arrow_right_1,
                  size: 18,
                  color: colorsPalletes.quinaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildServiceSelector(ColorsPalletes colorsPalletes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            showServices = !showServices;
          });
        },
        child: Card(
          color: colorsPalletes.secondaryColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Iconsax.scissor_1,
                      color: colorsPalletes.nonaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 15),
                    _selectedServices.isEmpty
                        ? Text(
                            'Selecione os serviços',
                            style: GoogleFonts.lato(
                              color: colorsPalletes.nonaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )
                        : SizedBox(
                            width: 280,
                            child: Text(
                              _selectedServices.map((serviceId) {
                                final service =
                                    Provider.of<DetailsStore>(context)
                                        .barbershopsServices
                                        .firstWhere((element) =>
                                            element.id == serviceId);
                                return service.name;
                              }).join(
                                  ', '), // Une os nomes com vírgula e espaço
                              style: GoogleFonts.lato(
                                color: colorsPalletes.nonaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                  ],
                ),
                const SizedBox(width: 10),
                Icon(
                  Iconsax.arrow_right_1,
                  size: 18,
                  color: colorsPalletes.quinaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildDateSelector(ColorsPalletes colorsPalletes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            showDateService = !showDateService;
          });
        },
        child: Card(
          color: colorsPalletes.secondaryColor,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Iconsax.calendar_1,
                      color: colorsPalletes.nonaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      _selectedDate != null && _confirmTime != null
                          ? '${_formatDateForView(_selectedDate!)} | ${_formatTimeForPostgres(_confirmTime!)}h'
                          : 'Escolha a melhor data',
                      style: GoogleFonts.lato(
                        color: colorsPalletes.nonaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Icon(
                  Iconsax.arrow_right_1,
                  size: 18,
                  color: colorsPalletes.quinaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildServiceList(ColorsPalletes colorsPalletes) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        height: 200,
        child: Consumer<DetailsStore>(
          builder: (context, store, child) {
            if (store.isLoading) {
              return Center(
                child: SpinKitFadingCircle(
                  color: colorsPalletes.septenaryColor,
                  size: 50.0,
                ),
              );
            }
            if (store.error.isNotEmpty) {
              return Text(store.error);
            }
            if (store.barbershopsServices.isEmpty) {
              return Container();
            }

            // Inicialize a lista _isCheckedList após os serviços serem carregados
            if (_isCheckedList == null ||
                _isCheckedList!.length != store.barbershopsServices.length) {
              _isCheckedList =
                  List<bool>.filled(store.barbershopsServices.length, false);
            }

            return Column(
              children: [
                if (_isCheckedList!.any((element) => element))
                  Text(
                    _selectedDate != null && _confirmTime != null
                        ? 'Data: ${_formatDateForView(_selectedDate!)} | Horário: ${_formatTimeForPostgres(_confirmTime!)}h'
                        : 'Escolha a melhor data',
                    style: GoogleFonts.lato(
                      color: colorsPalletes.nonaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: store.barbershopsServices.length,
                    itemBuilder: (context, index) {
                      final service = store.barbershopsServices[index];
                      if (!_isCheckedList![index]) {
                        return const SizedBox();
                      }
                      return Card(
                        color: colorsPalletes.secondaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(service.imageUrl),
                                    // radius: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        service.name,
                                        style: GoogleFonts.lato(
                                          color: colorsPalletes.nonaryColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'R\$ ${service.price.toString()}',
                                        style: GoogleFonts.lato(
                                          color: colorsPalletes.nonaryColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isCheckedList![index] = false;
                                  });
                                },
                                icon: Icon(
                                  Iconsax.trash,
                                  color: colorsPalletes.nonaryColor,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Positioned _buildBackButton(ColorsPalletes colorsPalletes) {
  //   return Positioned(
  //     left: 10,
  //     top: 20,
  //     child: GestureDetector(
  //       onTap: () {
  //         Navigator.of(context).pop();
  //       },
  //       child: Container(
  //         padding: const EdgeInsets.all(8),
  //         decoration: BoxDecoration(
  //           color: colorsPalletes.secondaryColor,
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         child: Icon(
  //           Ionicons.arrow_back_circle,
  //           color: colorsPalletes.nonaryColor,
  //           size: 20,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDatePicker() {
    ColorsPalletes colorsPalletes = ColorsPalletes();
    return Container(
      height: 750,
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Card(
        elevation: 20,
        color: colorsPalletes.secondaryColor,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    'Data do Agendamento',
                    style: GoogleFonts.lato(
                      color: colorsPalletes.nonaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        showDateService = !showDateService;
                      });
                    },
                    icon: Icon(
                      Icons.close,
                      color: colorsPalletes.nonaryColor,
                    )),
              ],
            ),
            SfDateRangePicker(
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: colorsPalletes.secondaryColor,
                textStyle: GoogleFonts.lato(
                  color: colorsPalletes.nonaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // monthViewSettings: DateRangePickerMonthViewSettings(
              //   dayFormat: 'E', // Formato dos dias da semana (ex.: Seg, Ter)
              // ),
              monthCellStyle: DateRangePickerMonthCellStyle(
                textStyle: GoogleFonts.lato(
                  color: colorsPalletes.nonaryColor, // Cor das fontes das datas
                  fontSize: 15,
                ),
                todayTextStyle: GoogleFonts.lato(
                  color: colorsPalletes.white, // Cor da data de hoje
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                todayCellDecoration: BoxDecoration(
                  color: colorsPalletes
                      .primaryColor, // Fundo da célula da data de hoje
                  shape: BoxShape.circle,
                ),
                leadingDatesTextStyle: GoogleFonts.lato(
                  color: colorsPalletes
                      .white, // Cor das datas anteriores ao mês atual
                ),
                weekendTextStyle: GoogleFonts.lato(
                  color: colorsPalletes.white, // Cor das datas de fim de semana
                ),
                disabledDatesTextStyle: GoogleFonts.lato(
                  color: Colors.grey, // Cor das datas desabilitadas (passadas)
                  fontSize: 15,
                ),
                blackoutDatesDecoration: BoxDecoration(
                  color: colorsPalletes
                      .white, // Fundo das células de datas bloqueadas
                  shape: BoxShape.circle,
                  border: Border.all(color: colorsPalletes.white, width: 1),
                ),
              ),
              monthViewSettings: DateRangePickerMonthViewSettings(
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                  backgroundColor: colorsPalletes
                      .secondaryColor, // Cor de fundo do cabeçalho (dias da semana)
                  textStyle: GoogleFonts.lato(
                    color: colorsPalletes
                        .nonaryColor, // Cor das fontes dos dias da semana
                    fontWeight: FontWeight.bold,
                  ),
                ),
                dayFormat:
                    'E', // Formato dos dias da semana (ex.: Mon, Tue, ...)
              ),
              backgroundColor:
                  colorsPalletes.secondaryColor, // Cor de fundo do calendário
              enablePastDates: false, // Desabilitar a seleção de datas passadas
              minDate:
                  DateTime.now(), // Definindo a data mínima como a data atual

              endRangeSelectionColor: colorsPalletes.primaryColor,
              yearCellStyle: DateRangePickerYearCellStyle(
                textStyle: GoogleFonts.lato(
                  color: colorsPalletes.nonaryColor, // Cor das fontes do ano
                  fontSize: 15,
                ),
              ),
              rangeSelectionColor: colorsPalletes.primaryColor,
              selectionColor: colorsPalletes.primaryColor,
              rangeTextStyle: GoogleFonts.lato(
                color: colorsPalletes
                    .nonaryColor, // Cor das fontes do intervalo de datas
                fontSize: 15,
              ),

              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                setState(() {
                  _selectedDate = args.value as DateTime?;
                  if (_selectedDate != null) {
                    final formattedDate =
                        _formatDateForPostgres(_selectedDate!);
                    Provider.of<SlotsStore>(context, listen: false)
                        .getSlots(_confirmBarberId!, formattedDate);
                  }
                });
              },

              selectionMode: DateRangePickerSelectionMode.single,
              initialSelectedDate: DateTime.now(),
            ),
            Divider(
              color: colorsPalletes.nonaryColor,
              thickness: 0.2,
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = _selectedDate;
                    });
                  },
                  child: Text(
                    _selectedDate == null || _selectTime == null
                        ? 'Selecione a melhor data e hora!'
                        : "Voce escolheu o dia  ${_formatDateForPostgres(_selectedDate!)} | ${_formatTimeForPostgres(_selectTime!)}h",
                    style: GoogleFonts.lato(
                      color: colorsPalletes.nonaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_selectedDate != null)
                  Container(
                    height: 320,
                    width: 330,
                    color: colorsPalletes.secondaryColor,
                    child: Consumer<SlotsStore>(
                      builder: (context, store, child) {
                        if (store.isLoading) {
                          return Center(
                            child: SpinKitFadingCircle(
                              color: colorsPalletes.septenaryColor,
                              size: 50.0,
                            ),
                          );
                        }
                        if (store.error.isNotEmpty) {
                          return Center(
                            child: Text(store.error),
                          );
                        }
                        if (store.slots.isEmpty) {
                          return Center(
                            child: Text(
                              'Nenhum horário disponível',
                              style: GoogleFonts.lato(
                                color: colorsPalletes.nonaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: [
                            Expanded(
                              child: GridView.builder(
                                itemCount: store.slots.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 3,
                                ),
                                itemBuilder: (context, index) {
                                  bool isSelected =
                                      store.selectedSlotIndex == index;
                                  return GestureDetector(
                                    onTap: () {
                                      store.setSelectedSlotIndex(index);
                                      print(store.selectedSlotIndex);
                                      print(store.slots[index].timeid);
                                      // Atualiza o índice do slot selecionado
                                      // store.setSelectedSlotIndex(index);
                                      // DateTime formattedDate =
                                      //     _formatDateForPostgres1(
                                      //         _selectedDate!);
                                      // setState(() {
                                      //   _selectTime = store.slots[index].time;
                                      //   isSelected = !isSelected;
                                      // });
                                      // print(isSelected);
                                      // final id = store.slots[index].id;
                                      // final barbershopid =
                                      //     store.slots[index].barbershopid;
                                      // final timeid = store.slots[index].timeid;
                                      // final date = formattedDate;
                                      // print('ID: $id');
                                      // print('BarbershopID: $barbershopid');
                                      // print('TimeID: $timeid');
                                      // print('Date: $date');
                                      // print(
                                      //     'Time: ${_formatTimeForPostgres(store.slots[index].time)}');
                                      // // Id do horário selecionado
                                      // try {
                                      //   store.updateSlots(id, timeid, date.toIso8601String(), barbershopid);
                                      // } catch (e) {
                                      //   throw Exception(
                                      //       'Erro ao atualizar o slot: $e');
                                      // }

                                      // print('Horário selecionado: ${store.slots[index].time}');
                                      // print('Horário selecionado formatado: ${_formatTimeForPostgres(store.slots[index].time)}');
                                      // print("Isavailable do horário selecionado: ${store.slots[index].isavailable}");
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? colorsPalletes.primaryColor
                                            : colorsPalletes.secondaryColor,
                                        border: Border.all(
                                          color: colorsPalletes.nonaryColor,
                                          width: 0.5,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _formatTimeForPostgres(
                                              store.slots[index].time),
                                          style: GoogleFonts.lato(
                                            color: colorsPalletes.nonaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // const SizedBox(height: 10),
                            SizedBox(
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10),
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                      backgroundColor:
                                          colorsPalletes.primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      fixedSize: const Size(300, 40)),
                                  onPressed: () {
                                    setState(() {
                                      showDateService = !showDateService;
                                    });

                                    //* Lógica para alterar o valor do slot
                                    if (store.selectedSlotIndex != null) {
                                      final selectedSlot =
                                          store.slots[store.selectedSlotIndex!];
                                      DateTime formattedDate =
                                          _formatDateForPostgres1(
                                              _selectedDate!);

                                      // Chama o método updateSlots com os dados do slot selecionado
                                      // store.updateSlots(
                                      //   selectedSlot.id,
                                      //   selectedSlot.timeid,
                                      //   formattedDate.toIso8601String(),
                                      //   selectedSlot.barbershopid,
                                      // );
                                      print(
                                          'Horário selecionado: ${_formatTimeForPostgres(selectedSlot.time)}');
                                      print(
                                          "Data selecionada: ${_formatDateForPostgres(_selectedDate!)}");

                                      setState(() {
                                        showDateService = !showDateService;
                                        _confirmDate = formattedDate;
                                        _confirmTime = selectedSlot.time;
                                        _confirmId = selectedSlot.id;
                                        _confirmTimeId = selectedSlot.timeid;
                                        // _confirmBarbershopId = selectedSlot.barberid;
                                      });

                                      // Mensagem de confirmação ou ação adicional após a atualização
                                      // print('Horário atualizado com sucesso!');
                                      // showTopSnackBar(
                                      //   context,
                                      //   'Horário Selecionado: ${_formatTimeForPostgres(_confirmTime!)}h!',
                                      //    Colors.greenAccent.shade700,
                                      //    Colors.greenAccent.shade700,
                                      //    Icons.check_circle,
                                      // );
                                      setState(() {
                                        showDateService = !showDateService;
                                      });
                                    } else {
                                      // Exibir mensagem de erro ou notificação se nenhum horário estiver selecionado
                                      // print('Nenhum horário selecionado.');
                                    }
                                  },
                                  child: Text(
                                    'Confirmar',
                                    style: TextStyle(
                                        color: colorsPalletes.nonaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildServiceModal(ColorsPalletes colorsPalletes) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: colorsPalletes.secondaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        height: 800,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              _buildModalHeader(colorsPalletes),
              const SizedBox(height: 10),
              _buildServiceCheckboxList(colorsPalletes),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModalHeader(ColorsPalletes colorsPalletes) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Selecione os serviços',
              style: GoogleFonts.lato(
                color: colorsPalletes.nonaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  showServices = !showServices;
                });
              },
              child: Icon(Icons.close,
                  color: colorsPalletes.denaryColor, size: 20),
            ),
          ],
        ),
        Divider(
          color: colorsPalletes.nonaryColor,
          thickness: 0.5,
        ),
      ],
    );
  }

  Widget _buildServiceCheckboxList(ColorsPalletes colorsPalletes) {
    return Column(
      children: [
        SizedBox(
          height: 650,
          child: Consumer<DetailsStore>(
            builder: (context, store, child) {
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: colorsPalletes.primaryColor,
                  thickness: 1,
                ),
                itemCount: store.barbershopsServices.length,
                itemBuilder: (context, index) {
                  final service = store.barbershopsServices[index];
                  print('ID: ${service.id} | Nome: ${service.name}');
                  if (_isCheckedList == null ||
                      _isCheckedList!.length !=
                          store.barbershopsServices.length) {
                    _isCheckedList = List<bool>.filled(
                        store.barbershopsServices.length, false);
                  }
                  return CheckboxListTile(
                    checkboxShape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(service.imageUrl),
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.name,
                              style: GoogleFonts.lato(
                                color: colorsPalletes.nonaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'R\$ ${service.price}',
                              style: GoogleFonts.lato(
                                color: colorsPalletes.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    value: _isCheckedList![index],
                    onChanged: (value) {
                      setState(() {
                        _isCheckedList![index] = value!;
                      });
                      debugPrint(
                          'ID: ${service.id} | Nome: ${service.name} | Valor: $value');

                      if (!_selectedServices.contains(service.id)) {
                        _selectedServices.add(service.id);
                      } else {
                        _selectedServices.remove(service.id);
                      }

                      debugPrint(
                          "LISTA DE SERVIÇOS DO USUÁRIO: $_selectedServices");
                    },
                    activeColor: colorsPalletes.nonaryColor,
                    checkColor: colorsPalletes.primaryColor,
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: colorsPalletes.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                fixedSize: const Size(300, 40)),
            onPressed: () {
              setState(() {
                showServices = !showServices;
              });
            },
            child: Text(
              'Confirmar',
              style: TextStyle(color: colorsPalletes.nonaryColor),
            ),
          ),
        ),
      ],
    );
  }
  //!-----------------

  Widget _buildBarberCheckboxList(ColorsPalletes colorsPalletes) {
    return Container(
      decoration: BoxDecoration(
        color: colorsPalletes.primaryColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 1),
      ),
      height: 650,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(30),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Selecione o barbeiro',
              style: GoogleFonts.lato(
                color: colorsPalletes.nonaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          Consumer<BarberStore>(
            builder: (context, store, child) {
              return Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: colorsPalletes.white,
                    thickness: 1,
                  ),
                  itemCount: store.barbers.length,
                  itemBuilder: (context, index) {
                    final barber = store.barbers[index];

                    // Verifica se este barbeiro é o selecionado
                    bool isSelected = store.selectedBarberId == barber.barberid;

                    return SizedBox(
                      height: 55,
                      // width: 300,
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "http://10.0.2.2:8800/users/uploads/${barber.barberimage}"),
                            radius: 20,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              barber.barbername,
                              style: GoogleFonts.lato(
                                color: colorsPalletes.nonaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Serviços realizados ${barber.barberqtdservices.toString()}',
                              style: GoogleFonts.lato(
                                color: colorsPalletes.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: Checkbox(
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          checkColor: Colors.black,
                          fillColor:
                              WidgetStateProperty.all(colorsPalletes.white),
                          hoverColor: colorsPalletes.primaryColor,
                          value: isSelected,
                          onChanged: (bool? value) {
                            if (value == true) {
                              // Seleciona apenas este barbeiro e desmarca os outros
                              store.selectBarber(barber.barberid);
                              _confirmBarberId = barber.barberid;
                            }
                          },
                          activeColor: colorsPalletes.primaryColor,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: colorsPalletes.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  fixedSize: const Size(300, 40)),
              onPressed: () {
                setState(() {
                  showBarbers = !showBarbers;
                });
                _confirmBarberId =
                    Provider.of<BarberStore>(context, listen: false)
                        .selectedBarberId;
                // print('Barbeiro selecionado: ${Provider.of<BarberStore>(context, listen: false).selectedBarberId}');
                print('Barbeiro selecionado _confirmId: $_confirmBarberId');
              },
              child: Text(
                'Confirmar',
                style: TextStyle(color: colorsPalletes.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
