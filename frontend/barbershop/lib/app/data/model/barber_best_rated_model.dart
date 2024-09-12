
import 'dart:convert';

class BarberBestRatedModel {
  final String barberid;
  final String barberemail;
  final String barberwhatsapp;
  final String barbername;
  final int barberqtdservices;
  final String barberimage;
  final String barbershopid;
  final String id;
  final String name;
  final String address;
  final String phones;
  final String description;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  BarberBestRatedModel({
    required this.barberid,
    required this.barberemail,
    required this.barberwhatsapp,
    required this.barbername,
    required this.barberqtdservices,
    required this.barberimage,
    required this.barbershopid,
    required this.id,
    required this.name,
    required this.address,
    required this.phones,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // O método toMap é responsável por converter o objeto em um Map
  Map<String, dynamic> toMap() {
    return {
      'barberid': barberid,
      'barberemail': barberemail,
      'barberwhatsapp': barberwhatsapp,
      'barbername': barbername,
      'barberqtdservices': barberqtdservices,
      'barberimage': barberimage,
      'barbershopid': barbershopid,
      'id': id,
      'name': name,
      'address': address,
      'phones': phones,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // O método toJson é responsável por converter o objeto em um JSON
  String toJson() => jsonEncode(toMap());


  factory BarberBestRatedModel.fromMap(Map<String, dynamic> json) {
    return BarberBestRatedModel(
      barberid: json['barberid'] ?? 'Info não disponível',
      barberemail: json['barberemail'] ?? 'Info não disponível',
      barberwhatsapp: json['barberwhatsapp'] ?? '00-000000000',
      barbername: json['barbername'] ?? 'Info não disponível',
      barberqtdservices: json['barberqtdservices'] ?? 0,
      barberimage: json['barberimage'] ?? 'Info não disponível',
      barbershopid: json['barbershopid'] ?? 'Info não disponível',
      id: json['id'] ?? 'Info não disponível',
      name: json['name'] ?? 'Info não disponível',
      address: json['address'] ?? 'Info não disponível',
      phones: json['phones']  ?? '00-000000000',
      description: json['description'] ?? 'Info não disponível',
      imageUrl: json['imageUrl']  ?? 'Info não disponível',
      createdAt: json['createdAt'] ?? 'Info não disponível',
      updatedAt: json['updatedAt']  ?? 'Info não disponível',
    );
  }



  factory BarberBestRatedModel.fromJson(String json) => BarberBestRatedModel.fromMap(jsonDecode(json));


  @override
  String toString() {
    return 'BarberBestRatedModel(barberid: $barberid, barberemail: $barberemail, barberwhatsapp: $barberwhatsapp, barbername: $barbername, barberqtdservices: $barberqtdservices, barberimage: $barberimage, barbershopid: $barbershopid, id: $id, address: $address, phones: $phones, description: $description, imageUrl: $imageUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

}