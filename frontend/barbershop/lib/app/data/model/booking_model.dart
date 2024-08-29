import 'dart:convert';

class BookingModel {
  final String id;
  final String userId;
  final DateTime date;
  final String createdAt;
  final String updatedAt;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String barbershopId;
  final DateTime time;

  BookingModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.barbershopId,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'barbershopId': barbershopId,
      'time': time,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory BookingModel.fromMap(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? 'NADINHA',
      userId: json['userId'] ?? 'NADINHA',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      createdAt: json['createdAt'] ?? 'NADINHA',
      updatedAt: json['updatedAt'] ?? 'NADINHA',
      name: json['name'] ?? 'NADINHA',
      description: json['description'] ?? 'NADINHA',
      imageUrl: json['imageUrl'] ?? 'NADINHA',
      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,
      barbershopId: json['barbershopId'] ?? 'NADINHA',
      time: DateTime.parse('1970-01-01 ${json['time']}')
    );
  }

  factory BookingModel.fromJson(String json) =>
      BookingModel.fromMap(jsonDecode(json));
}
