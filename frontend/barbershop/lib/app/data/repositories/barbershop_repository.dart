import 'dart:convert';

import 'package:barbershop/app/data/http/http_client.dart';
import 'package:barbershop/app/data/model/barbershop_model.dart';
import 'package:barbershop/app/utils/constants.dart';

abstract class IBarbershopRepository {
  Future<List<BarbershopModel>> getAllBarbershops();
}

class BarbershopRepository implements IBarbershopRepository {
  final Constants constants = Constants();
  final IHttpClient client;
  BarbershopRepository({required this.client});

  @override
  Future<List<BarbershopModel>> getAllBarbershops() async {
    try {
      final url =
          "http://${constants.apiUrl}/barbershops"; // Emulador Android, dispositivo físico real
      // const url = "http://10.0.2.2:8800/barbershops"; // PC Localhost
      // PC Localhost
      final response = await client.get(url: url);

      if (response.statusCode != 200) {
        throw Exception();
      }

      final barbershopData = jsonDecode(response.body);

      final barbershops = barbershopData
          .map<BarbershopModel>(
              (barbershop) => BarbershopModel.fromMap(barbershop))
          .toList();

      return barbershops;
    } catch (e) {
      throw Exception('Erro ao buscar barbearias1: ${e.toString()}');
    }
  }
}
