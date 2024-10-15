import 'dart:convert';
import 'package:barbershop/app/data/http/http_client.dart';
import 'package:barbershop/app/data/model/booking_model.dart';
import 'package:barbershop/app/utils/constants.dart';
import 'package:intl/intl.dart';

abstract class IBookingRepository {
  Future<List<BookingModel>> getBookingById(String id, String barbershopId);
  Future<void> createBooking(
      String userId, List<String> serviceId, DateTime date, DateTime time);
}

class BookingRepository implements IBookingRepository {
  final Constants constants = Constants();
  final IHttpClient client;
  BookingRepository({required this.client});

  @override
  Future<List<BookingModel>> getBookingById(
      String id, String barbershopId) async {
    try {
      final String url =
          'http://${constants.apiUrl}/bookings/$id?barbershopId=$barbershopId';

      final response = await client.get(url: url);

      if (response.statusCode != 200) {
        // Imprime a resposta para ver o conteúdo completo
        throw Exception('Erro ao buscar agendamentos: ${response.body}');
      }

      final bookingData = jsonDecode(response.body);

      final booking = bookingData
          .map<BookingModel>((booking) => BookingModel.fromMap(booking))
          .toList();
      return booking;
    } catch (e) {
      throw Exception('Erro ao buscar agendamento: $e');
    }
  }

  String _formatDateForPostgres(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(date);
  }

  @override
  Future<void> createBooking(String userId, List<String> serviceId,
      DateTime date, DateTime time) async {
    try {
      final String url = "http://${constants.apiUrl}/bookings";

      // Formatar a data para o formato que o backend espera
      final formattedDate = _formatDateForPostgres(date);

      final body = {
        "userId": userId,
        "serviceId": serviceId,
        "date": formattedDate,
        "time": DateFormat('HH:mm:ss').format(time),
      };

      final bodyJson = jsonEncode(body);

      // Realizar a requisição POST
      final response = await client.post(
        url: url,
        headers: {
          'Content-Type': 'application/json', // Especifica que o corpo é JSON
        },
        body: bodyJson,
      );

      if (response.statusCode != 201) {
        throw Exception(
            'Falha ao criar agendamento. Status code: ${response.statusCode}');
      }

      // Decodificar a resposta apenas se for necessário
      jsonDecode(response.body);

      // Aqui você pode fazer algo com responseData, se necessário
    } catch (e) {
      throw Exception('Erro ao criar agendamento: $e');
    }
  }

// @override
// Future<void> createBooking(String userId, List<String> serviceId, DateTime date) async {
//   try {
//     const String url = "http://10.0.2.2:8800/bookings";

//     final formattedDate = _formatDateForPostgres(date);

//     final body = {
//       "userId": userId,
//       "serviceId": serviceId,
//       "date": formattedDate,
//     };

//     final bodyJson = jsonEncode(body);

//     final response = await client.post(
//       url: url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: bodyJson,
//     );

//     if (response.statusCode != 201) {
//       throw Exception('Falha ao criar agendamento. Status code: ${response.statusCode}');
//     }

//     return jsonDecode(response.body);
//   } catch (e) {
//     throw Exception('Erro ao criar agendamento: $e');
//   }
// }
}
