import 'dart:convert';
import 'package:barbershop/app/data/model/barber_best_rated_model.dart';
import 'package:barbershop/app/data/http/http_client.dart';

abstract class IBarberBestRatedRepository {
  Future<List<BarberBestRatedModel>> getBarberBestRated();
}

class BarberBestRatedRepository implements IBarberBestRatedRepository {
  final IHttpClient client;
  BarberBestRatedRepository({required this.client});

  @override
  Future<List<BarberBestRatedModel>> getBarberBestRated() async {
    final String bestRatedBarberUrl = 'http://10.0.2.2:8800/best-rated-barbers';

    try {
      final response = await client.get(url: bestRatedBarberUrl);
      print(response);

      if (response.statusCode != 200) {
        throw Exception();
      }

      final bestRatedBarberData = jsonDecode(response.body);
      print(bestRatedBarberData);
      final bestBarbers = bestRatedBarberData.map<BarberBestRatedModel>((barber) => BarberBestRatedModel.fromMap(barber)).toList();
      return bestBarbers;
    } catch (e) {
      throw Exception('Erro ao buscar barbeiros mais bem avaliados: $e');
    }
  }
}
