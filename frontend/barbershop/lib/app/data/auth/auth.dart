import 'dart:convert';
import 'package:barbershop/app/data/model/user_model.dart';
import 'package:barbershop/app/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  Map<String, dynamic> _userData = {};
  bool get isAuth => _userData.isNotEmpty;
  Map<String, dynamic> get userData => _userData;

Future<List<UserModel>> login(String email, String password) async {
  // const urlLogin = "http://192.168.1.109:8800/Users/login"; // Emulador Android, dispositivo físico real
  const urlLogin = "http://10.0.2.2:8800/Users/login"; // PC Localhost

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
      print('JSON Retornado DO LOGIN (AUTH): $jsonData');

      // Converte a lista de JSON para uma lista de objetos UserModel
      final users = (jsonData as List)
          .map<UserModel>((json) => UserModel.fromMap(json))
          .toList();

      // Salva o primeiro usuário nos SharedPreferences
      final userMap = users[0].toMap();
      await Preferences.saveMap('userDataSharedPreferences', userMap);
      await Preferences.getMap('userDataSharedPreferences');

      _userData = userMap;
      print('DADOS DO LOGIN: $_userData');
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

    if (storedUserData.isNotEmpty) {
      _userData = storedUserData;
      notifyListeners();
      return true; // Retorna verdadeiro se o auto login for bem-sucedido
    }

    return false; // Retorna falso se não houver dados de usuário armazenados
  }

  Future<void> logout() async {
    await Preferences.remove('userDataSharedPreferences');
    print('Usuário deslogado e dados removidos do SharedPreferences');

    // Verifica se os dados foram removidos corretamente
    final storedUserData = await Preferences.getMap('userDataSharedPreferences');
    print('Dados após logout: $storedUserData'); // Deveria imprimir null ou um mapa vazio

    _userData = {};
    notifyListeners();
  }

}
