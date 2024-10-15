import 'dart:convert';

import 'package:barbershop/app/data/http/http_client.dart';
import 'package:barbershop/app/data/model/barbershop_barber_model.dart';
import 'package:barbershop/app/utils/constants.dart';

abstract class IBarbershopBarberRepository {
  Future<List<BarbershopBarberModel>> getBarbershopBarbers(String barbershopid);
}

class BarbershopBarberRepository implements IBarbershopBarberRepository {
  final Constants constants = Constants();

  final IHttpClient client;
  BarbershopBarberRepository({required this.client});

  @override
  Future<List<BarbershopBarberModel>> getBarbershopBarbers(
      String barbershopid) async {
    try {
      final String url = 'http://${constants.apiUrl}/barber/$barbershopid';

      final response = await client.get(url: url);

      if (response.statusCode != 200) {
        throw Exception();
      }

      final barberData = jsonDecode(response.body);
      final barbers = barberData
          .map<BarbershopBarberModel>(
              (barber) => BarbershopBarberModel.fromMap(barber))
          .toList();
      barbers
          .map((e) => print("BARBERS FROM REPOSITORY ${e.barbername}"))
          .toList();
      return barbers;
    } catch (e) {
      throw Exception('Erro ao buscar barbeiros: $e');
    }
  }
}
