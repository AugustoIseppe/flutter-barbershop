
import 'dart:convert';

class UserModel {
  // Atributos
  final String id;
  final String email;
  final String name;
  final String createdAt;
  final String updatedAt;
  final String password;
  final String image;
  final bool userType;
  final String phone;

  // Construtor
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.password,
    required this.image,
    required this.userType,
    required this.phone,
  });

  // O método toMap é responsável por converter o objeto em um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'password': password,
      'image': image,
      'userType': userType,
      'phone': phone,
    };
  }

  // O método toJson é responsável por converter o objeto em um JSON
  String toJson() => jsonEncode(toMap());
  
  // O método fromMap é responsável por converter um Map em um objeto
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '-',
      email: json['email'] ?? 'E-mail não disponível',
      name: json['name'] ?? '-',
      createdAt: json['createdAt'] ?? '-',
      updatedAt: json['updatedAt'] ?? "",
      password: json['password'] ?? '',
      image: json['image'] ?? 'Image not available',
      userType: json['userType'] ?? false, // false = cliente, true = barbeiro
      phone: json['phone'] ?? '(00) 00000-0000',
    );
  }

  // O método fromJson é responsável por converter um JSON em um objeto
  factory UserModel.fromJson(String json) => UserModel.fromMap(jsonDecode(json));



}

