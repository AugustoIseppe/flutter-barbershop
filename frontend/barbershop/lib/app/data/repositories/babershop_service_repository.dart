import 'dart:convert';

import 'package:barbershop/app/data/http/http_client.dart';
import 'package:barbershop/app/data/model/barbershop_services.dart';
import 'package:barbershop/app/utils/constants.dart';

abstract class IBarbershopServiceRepository {
  Future<List<BarbershopServicesModel>> getBarbershopsWithServices(String id);
}

class BarbershopServiceRepository implements IBarbershopServiceRepository {
  final Constants constants = Constants();
  final IHttpClient client;
  BarbershopServiceRepository({required this.client});

  @override
  Future<List<BarbershopServicesModel>> getBarbershopsWithServices(
      String id) async {
    try {
      final String url = 'http://${constants.apiUrl}/Barbershops/$id';

      final response = await client.get(url: url);

      if (response.statusCode != 200) {
        throw Exception();
      }

      final barbershopServiceData = jsonDecode(response.body);
      print(barbershopServiceData);
      final barbershopServices = barbershopServiceData
          .map<BarbershopServicesModel>((barbershopService) =>
              BarbershopServicesModel.fromMap(barbershopService))
          .toList();
      barbershopServices
          .map((e) => print("BARBERSHOPS SERVICES FROM REPOSITORY ${e.name}"))
          .toList();
      return barbershopServices;
    } catch (e) {
      throw Exception('Erro ao buscar serviços da barbearia: $e');
    }
  }
}
