import 'dart:convert';
import 'package:barbershop/app/data/model/barber_best_rated_model.dart';
import 'package:barbershop/app/data/http/http_client.dart';
import 'package:barbershop/app/utils/constants.dart';

abstract class IBarberBestRatedRepository {
  Future<List<BarberBestRatedModel>> getBarberBestRated();
}

class BarberBestRatedRepository implements IBarberBestRatedRepository {
  final Constants constants = Constants();
  final IHttpClient client;
  BarberBestRatedRepository({required this.client});

  @override
  Future<List<BarberBestRatedModel>> getBarberBestRated() async {
    final String bestRatedBarberUrl =
        'http://${constants.apiUrl}/best-rated-barbers';

    try {
      final response = await client.get(url: bestRatedBarberUrl);
      print(response);

      if (response.statusCode != 200) {
        throw Exception();
      }

      final bestRatedBarberData = jsonDecode(response.body);
      print(bestRatedBarberData);
      final bestBarbers = bestRatedBarberData
          .map<BarberBestRatedModel>(
              (barber) => BarberBestRatedModel.fromMap(barber))
          .toList();
      return bestBarbers;
    } catch (e) {
      throw Exception('Erro ao buscar barbeiros mais bem avaliados: $e');
    }
  }
}
