import 'dart:convert';

import 'package:barbershop/app/data/http/http_client.dart';
import 'package:barbershop/app/data/model/barbershop_services.dart';

abstract class IBarbershopServiceRepository {
  Future<List<BarbershopServicesModel>> getBarbershopsWithServices(String id);
}

class BarbershopServiceRepository implements IBarbershopServiceRepository {
  final IHttpClient client;
  BarbershopServiceRepository({required this.client});

  @override
  Future<List<BarbershopServicesModel>> getBarbershopsWithServices(
      String id) async {
    try {
      final String url = 'http://10.0.2.2:8800/Barbershops/$id';
      // final String url = 'http://192.168.1.109:8800/Barbershops/$id';

      final response = await client.get(url: url);

      if (response.statusCode != 200) {
        throw Exception();
      }

      final barbershopServiceData = jsonDecode(response.body);

      final barbershopServices = barbershopServiceData
          .map<BarbershopServicesModel>((barbershopService) =>
              BarbershopServicesModel.fromMap(barbershopService))
          .toList();
      return barbershopServices;
    } catch (e) {
      throw Exception('Erro ao buscar serviços da barbearia: $e');
    } 
  }
}
