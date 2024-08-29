import 'dart:convert';

import 'package:barbershop/app/data/http/exceptions.dart';
import 'package:barbershop/app/data/http/http_client.dart';
import 'package:barbershop/app/data/model/slots_model.dart';

abstract class ISlotsRepository {
  Future<List<SlotsModel>> getSlots(String babershopId, String date);
}

class SlotsRepository implements ISlotsRepository {
  final IHttpClient client;
  SlotsRepository({required this.client});

  @override
  Future<List<SlotsModel>> getSlots(String babershopId, String date) async {
    try {
      final String url =
          'http://10.0.2.2:8800/slots?barbershopId=$babershopId&date=$date';
      // final String url =
      //     'http://192.168.1.109:8800/slots?barbershopId=$babershopId&date=$date';

      final response = await client.get(url: url);

      if (response.statusCode != 200) {
        throw Exception();
      }

      if (response.statusCode == 200) {
        final List<SlotsModel> slots = [];
        final body = jsonDecode(response.body);
        print("BODYY: $body");
        body.map((x) {
          final SlotsModel slot = SlotsModel.fromMap(x);
          slots.add(slot);
        }).toList();
        print('PASSEI DO body.map');
        slots.forEach((element) {
          print('ELEMENT: $element');
        });

        return slots;
      } else if (response.statusCode != 200) {
        throw NotFoundException('Slots não encontrados');
      } else {
        throw Exception('Erro ao buscar slots');
      }
    } catch (e) {
      throw Exception('Erro ao buscar slots: $e');
    }
  }
}
