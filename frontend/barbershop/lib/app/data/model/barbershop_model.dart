
import 'dart:convert';

class BarbershopModel {
  final String id;
  final String name;
  final String address;
  final String phones;
  final String description;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  BarbershopModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phones,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
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

  String toJson() => jsonEncode(toMap());

  factory BarbershopModel.fromMap(Map<String, dynamic> json) {
    return BarbershopModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phones: json['phones'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  factory BarbershopModel.fromJson(String json) => BarbershopModel.fromMap(jsonDecode(json));

}