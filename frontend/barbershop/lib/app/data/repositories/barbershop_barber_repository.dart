import 'dart:convert';

import 'package:barbershop/app/data/http/http_client.dart';
import 'package:barbershop/app/data/model/barbershop_barber_model.dart';

abstract class IBarbershopBarberRepository {
  Future<List<BarbershopBarberModel>> getBarbershopBarbers(String barbershopid);
}

class BarbershopBarberRepository implements IBarbershopBarberRepository {
  final IHttpClient client;
  BarbershopBarberRepository({required this.client});


  @override
  Future<List<BarbershopBarberModel>> getBarbershopBarbers(String barbershopid) async {
    try {
      final String url = 'http://10.0.2.2:8800/barber/$barbershopid';

      final response = await client.get(url: url);

      if (response.statusCode != 200) {
        throw Exception();
      }

      final barberData = jsonDecode(response.body);
      final barbers = barberData.map<BarbershopBarberModel>((barber) => BarbershopBarberModel.fromMap(barber)).toList();
      barbers.map((e) => print("BARBERS FROM REPOSITORY ${e.barbername}")).toList();
      return barbers;
    } catch (e) {
      throw Exception('Erro ao buscar barbeiros: $e');
    }
  }

}