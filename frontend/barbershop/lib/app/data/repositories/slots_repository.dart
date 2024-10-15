import 'dart:convert';

import 'package:barbershop/app/data/http/exceptions.dart';
import 'package:barbershop/app/data/http/http_client.dart';
import 'package:barbershop/app/data/model/slots_model.dart';
import 'package:barbershop/app/utils/constants.dart';

abstract class ISlotsRepository {
  Future<List<SlotsModel>> getSlots(String baberid, String date);
  Future<List<SlotsModel>> updateSlots(
      String id, String timeid, String date, String barberid);
}

class SlotsRepository implements ISlotsRepository {
  final Constants constants = Constants();
  final IHttpClient client;
  SlotsRepository({required this.client});

  @override
  Future<List<SlotsModel>> getSlots(String baberid, String date) async {
    try {
      final String url =
          'http://${constants.apiUrl}/slots?barberid=$baberid&date=$date';
      // final String url =
      //     'http://192.168.1.109:8800/slots?barbershopId=$babershopId&date=$date';

      final response = await client.get(url: url);

      if (response.statusCode != 200) {
        throw Exception();
      }

      if (response.statusCode == 200) {
        final List<SlotsModel> slots = [];
        final body = jsonDecode(response.body);
        body.map((x) {
          final SlotsModel slot = SlotsModel.fromMap(x);
          slots.add(slot);
        }).toList();
        // ignore: unused_local_variable
        for (var element in slots) {}

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

  @override
  Future<List<SlotsModel>> updateSlots(
      String id, String timeid, String date, String barberid) async {
    try {
      final String url = 'http://${constants.apiUrl}/Slots';

      final response = await client.updateSlot(
        url: url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: {
          'id': id,
          'timeid': timeid,
          'date': date,
          'barberid': barberid,
        },
      );

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);
        throw Exception('Erro ao atualizar slot ${body['message']}');
      }

      // Aqui, tratamos a resposta como um único objeto JSON
      jsonDecode(response.body);

      // Convertendo o mapa em uma instância de SlotsModel

      final getSlots = await this.getSlots(barberid, date);

      return getSlots;
      // Retornando uma lista com um único elemento
      // return [slot];
    } catch (e) {
      throw Exception('Erro ao buscar slots: $e');
    }
  }
}
