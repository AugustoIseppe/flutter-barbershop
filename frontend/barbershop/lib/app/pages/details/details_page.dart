import 'package:barbershop/app/data/http/http_client.dart';
import 'package:barbershop/app/data/model/barbershop_model.dart';
import 'package:barbershop/app/data/repositories/booking_repository.dart';
import 'package:barbershop/app/pages/booking/booking_page.dart';
import 'package:barbershop/app/pages/booking/booking_store.dart';
import 'package:barbershop/app/pages/details/details.store.dart';
import 'package:barbershop/app/pages/details/slots_store.dart';
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
  // String _selectedDate = '';
  BookingRepository bookingRepository = BookingRepository(client: HttpClient());
  DateTime? _selectedDate;
  bool showServices = false;
  bool showDateService = false;
  List<bool>? _isCheckedList;
  List<String> _selectedServices = [];
  DateTime? _selectTime;

  @override
  void initState() {
    super.initState();
    final store = Provider.of<DetailsStore>(context, listen: false);
    store.getBarbershopsWithServices(widget.barbershop.id.toString());
    final storeBooking = Provider.of<BookingStore>(context, listen: false);
    storeBooking.getBookingById(widget.userData['id'], widget.barbershop.id);
    // final storeSlots = Provider.of<SlotsStore>(context, listen: false);
    // storeSlots.getSlots(widget.barbershop.id, _formatDateForPostgres(_selectedDate!));
  }

  String _formatDateForPostgres(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatTimeForPostgres(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  _clearField() {
    setState(() {
      _selectedDate = null;
      _selectTime = null;
      _selectedServices = [];
      _isCheckedList = List<bool>.filled(_isCheckedList!.length, false);
    });
  }

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
            'Reserva para ${_formatDateForPostgres(date)} às ${_formatTimeForPostgres(time)}h',
            style: GoogleFonts.lato(
              color: ColorsPalletes().nonaryColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _clearField();
                Navigator.of(context).pop();
              },
              child: Text(
                'Não',
                style: GoogleFonts.lato(
                  color: ColorsPalletes().quaternaryColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final userId = widget.userData['id'];
                print('ID USUÁRIO: $userId');
                print(_selectedDate);
                print(
                    "LISTAR DE SERVIÇOS BOTAO CONFIRMAR AGENDAMENTO: $_selectedServices");
                await bookingRepository.createBooking(
                  userId,
                  _selectedServices,
                  _selectedDate!,
                  _selectTime!,
                );
              },
              child: Text(
                'Sim',
                style: GoogleFonts.lato(
                  color: ColorsPalletes().quaternaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
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
    final ColorsPalletes colorsPalletes = ColorsPalletes();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorsPalletes.primaryColor,
          foregroundColor: colorsPalletes.nonaryColor,
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
                  print(store.error);
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
                        Ionicons.cart_outline,
                      ),
                    ),
                    Positioned(
                      right: 2,
                      top: 1,
                      child: Container(
                        padding: const EdgeInsets.all(3),
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
                  Image.network(widget.barbershop.imageUrl),
                  _buildBarbershopInfo(colorsPalletes),
                  _buildSectionDivider(colorsPalletes),
                  _buildAboutSection(colorsPalletes),
                  _buildSectionDivider(colorsPalletes),
                  _buildServiceSelector(colorsPalletes),
                  _buildDateSelector(colorsPalletes),
                  _buildSectionDivider(colorsPalletes),
                  _buildServiceList(colorsPalletes),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: colorsPalletes.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      onPressed: () async {
                        _showDialog(_selectedDate!, _selectTime!);
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
                    Text(
                      'Selecione os serviços',
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
                      _selectedDate != null
                          ? _formatDateForPostgres(_selectedDate!)
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
              return const Center(
                child: Text('Nenhum serviço encontrado'),
              );
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
                    _selectedDate == null
                        ? 'Selecione a data do agendamento'
                        : 'Seus serviços selecionados para o dia ${_formatDateForPostgres(_selectedDate!)} ',
                    style: GoogleFonts.lato(
                      color: colorsPalletes.nonaryColor,
                      fontSize: 15,
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
      padding: EdgeInsets.all(10),
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
              // Personalizando as cores do calendário
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
                    'EEE', // Formato dos dias da semana (ex.: Mon, Tue, ...)
              ),
              backgroundColor:
                  colorsPalletes.secondaryColor, // Cor de fundo do calendário
              selectionColor: colorsPalletes.primaryColor,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                setState(() {
                  _selectedDate = args.value as DateTime?;
                  if (_selectedDate != null) {
                    final formattedDate =
                        _formatDateForPostgres(_selectedDate!);
                    Provider.of<SlotsStore>(context, listen: false)
                        .getSlots(widget.barbershop.id, formattedDate);
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
                      height: 200,
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
                            print(store.error);
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
                          return GridView.builder(
                            itemCount: store.slots.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 3),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectTime = store.slots[index].time;
                                  });
                                  print(
                                      'Horário selecionado: ${store.slots[index].time}');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colorsPalletes.secondaryColor,
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
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: colorsPalletes.primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        fixedSize: Size(300, 40)),
                    onPressed: () {
                      setState(() {
                        showDateService = !showDateService;
                      });
                    },
                    child: Text(
                      'Confirmar',
                      style: TextStyle(color: colorsPalletes.nonaryColor),
                    ),
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
                fixedSize: Size(300, 40)),
            onPressed: () {
              setState(() {
                showServices = !showServices;
              });
              print("LISTA DE SERVIÇOS BOTAO CONFIRMAR: $_selectedServices");
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
}
