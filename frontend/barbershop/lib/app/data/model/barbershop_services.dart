
import 'dart:convert';

class BarbershopServicesModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String price;
  final String barbershopId;
  

  BarbershopServicesModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.barbershopId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'barbershopId': barbershopId,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory BarbershopServicesModel.fromMap(Map<String, dynamic> map) {
    return BarbershopServicesModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? 'Image not available',
      price: map['price'] ?? '',
      barbershopId: map['barbershopId'] ?? '',
    );
  }

  factory BarbershopServicesModel.fromJson(String json) => BarbershopServicesModel.fromMap(jsonDecode(json));

} 