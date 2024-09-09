import 'dart:convert';
import 'package:intl/intl.dart';
class SlotsModel {
 final String id;
  final String barberid;
  final DateTime date;
  final String timeid;
  final bool isavailable;
  final DateTime createdat;
  final DateTime updatedat;
  final DateTime time; // Manter como DateTime

  SlotsModel({
    required this.id,
    required this.barberid,
    required this.date,
    required this.timeid,
    required this.isavailable,
    required this.createdat,
    required this.updatedat,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barberid': barberid,
      'date': date,
      'timeId': timeid,
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
      id: json['id'] ?? 'nao chegou nenhum id',
      barberid: json['barberid'] ?? 'nao chegou nenhum barberid',
      date: DateTime.parse(json['date']),
      timeid: json['timeid'] ?? 'nao chegou nenhum timeId',
      isavailable: json['isavailable'] ?? true,
      createdat: DateTime.parse(json['createdat']),
      updatedat: DateTime.parse(json['updatedat']),
      time: DateTime.parse('1970-01-01 ${json['time']}'), // Converter para DateTime
    );
  }

  factory SlotsModel.fromJson(String json) => SlotsModel.fromMap(jsonDecode(json));
}


