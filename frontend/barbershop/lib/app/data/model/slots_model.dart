import 'dart:convert';
import 'package:intl/intl.dart';
class SlotsModel {
 final String id;
  final String babershopId;
  final DateTime date;
  final String timeId;
  final bool isavailable;
  final DateTime createdat;
  final DateTime updatedat;
  final DateTime time; // Manter como DateTime

  SlotsModel({
    required this.id,
    required this.babershopId,
    required this.date,
    required this.timeId,
    required this.isavailable,
    required this.createdat,
    required this.updatedat,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'babershopId': babershopId,
      'date': date,
      'timeId': timeId,
      'isavailable': isavailable,
      'createdat': createdat,
      'updatedat': updatedat,
      'time': time,
    };
  }

  String toJson() => jsonEncode(toMap());

    // Método para formatar a hora como "HH:mm:ss"
  String getFormattedTime() {
    return DateFormat('HH:mm:ss').format(time);
  }

  factory SlotsModel.fromMap(Map<String, dynamic> json) {
    return SlotsModel(
      id: json['id'] ?? 'nao checou nenhum id',
      babershopId: json['babershopId'] ?? 'nao checou nenhum barbershopid',
      date: DateTime.parse(json['date']),
      timeId: json['timeId'] ?? 'nao checou nenhum timeId',
      isavailable: json['isavailable'] ?? true,
      createdat: DateTime.parse(json['createdat']),
      updatedat: DateTime.parse(json['updatedat']),
      time: DateTime.parse('1970-01-01 ${json['time']}'), // Converter para DateTime
    );
  }

  factory SlotsModel.fromJson(String json) => SlotsModel.fromMap(jsonDecode(json));
}


