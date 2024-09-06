
import 'dart:convert';

class BarbershopBarberModel {

  //Atributos
  final String barberid;
  final String barberemail;
  final String barberwhatsapp;
  final String barbername;
  final int barberqtdservices;
  final String barberimage;
  final String barbershopid;

  //Construtor
  BarbershopBarberModel({
    required this.barberid,
    required this.barberemail,
    required this.barberwhatsapp,
    required this.barbername,
    required this.barberqtdservices,
    required this.barberimage,
    required this.barbershopid,
  });

  //O método toMap é responsável por converter o objeto em um Map
  Map<String, dynamic> toMap() {
    return {
      'barberid': barberid,
      'barberemail': barberemail,
      'barberwhatsapp': barberwhatsapp,
      'barbername': barbername,
      'barberqtdservices': barberqtdservices,
      'barberimage': barberimage,
      'barbershopid': barbershopid,
    };
  }

  //O método toJson é responsável por converter o objeto em um JSON
  String toJson() => jsonEncode(toMap());

  //O método fromMap é responsável por converter um Map em um objeto
  factory BarbershopBarberModel.fromMap(Map<String, dynamic> json) {
    return BarbershopBarberModel(
      barberid: json['barberid'] ?? 'Id não encontrado',
      barberemail: json['barberemail'] ?? 'E-mail não disponível',
      barberwhatsapp: json['barberwhatsapp'] ?? 'Whatsapp não disponível',
      barbername: json['barbername'] ?? 'Nome não disponível',
      barberqtdservices: json['barberqtdservices'] ?? 0,
      barberimage: json['barberimage'] ?? 'Imagem não disponível',
      barbershopid: json['barbershopid'] ?? 'Id da barbearia não encontrado',
    );
  }

  //O método fromJson é responsável por converter um JSON em um objeto
  factory BarbershopBarberModel.fromJson(String source) => BarbershopBarberModel.fromMap(json.decode(source));
  
}