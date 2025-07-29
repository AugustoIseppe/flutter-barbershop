import 'dart:convert';
import 'package:barbershop/app/data/model/user_model.dart';
import 'package:barbershop/app/utils/constants.dart';
import 'package:barbershop/app/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  final Constants constants = Constants();
  Map<String, dynamic> _userData = {};
  bool get isAuth => _userData.isNotEmpty;
  Map<String, dynamic> get userData => _userData;

  Future<List<UserModel>> login(String email, String password) async {
    final urlLogin =
        "http://${constants.apiUrl}/users/login"; // Emulador Android, dispositivo físico real

    try {
      final response = await http.post(
        Uri.parse(urlLogin),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("JSON DATA: $jsonData");

        // Converte a lista de JSON para uma lista de objetos UserModel
        final users = (jsonData as List)
            .map<UserModel>((json) => UserModel.fromMap(json))
            .toList();
        for (var user in users) {
          print("USER123123: ${user.toMap()}");
        }
        // Salva o primeiro usuário nos SharedPreferences
        final userMap = users[0].toMap();
        await Preferences.saveMap('userDataSharedPreferences', userMap);
        await Preferences.getMap('userDataSharedPreferences');
        print(userMap);
        _userData = userMap;
        print(users);
        print("USER DATA: $_userData");
        notifyListeners();
        return users;
      } else {
        throw Exception('Falha ao fazer login: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Erro ao fazer login FRONTEND: $e');
    }
  }

  Future<bool> tryAutoLogin() async {
    final storedUserData =
        await Preferences.getMap('userDataSharedPreferences');
    print("STORED USER DATA: $storedUserData");
    if (storedUserData.isNotEmpty) {
      _userData = storedUserData;
      notifyListeners();
      return true; // Retorna verdadeiro se o auto login for bem-sucedido
    }

    return false; // Retorna falso se não houver dados de usuário armazenados
  }

  Future<void> logout() async {
    await Preferences.remove('userDataSharedPreferences');

    // Verifica se os dados foram removidos corretamente
    // Deveria imprimir null ou um mapa vazio

    _userData = {};
    notifyListeners();
  }
}
