import 'dart:convert';
import 'dart:io';
import 'package:barbershop/app/data/http/http_client.dart';
import 'package:barbershop/app/data/model/user_model.dart';
import 'package:barbershop/app/utils/constants.dart';
import 'package:barbershop/app/utils/preferences.dart';

//* Interface IUserRepository
abstract class IUserRepository {
  Future<List<UserModel>> getUsers();
  Future createUser(
      String email,
      String name,
      String password,
      File? imageFile, // O arquivo da imagem
      String phone);

  Future updateEmailAndPhone(
      String id, String email, String name, String password, String phone);

  Future updateImageUser(String id, File? imageUrl);

  Future deleteUser(String id);
}

//* Implementação da interface IUserRepository
class UserRepository implements IUserRepository {
  final Constants constants = Constants();

  final IHttpClient client;
  UserRepository({required this.client});

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final String url = 'http://${constants.apiUrl}/Users';

      final response = await client.get(url: url);

      if (response.statusCode != 200) {
        throw Exception();
      }

      final userData = jsonDecode(response.body);

      final users =
          userData.map<UserModel>((user) => UserModel.fromMap(user)).toList();

      return users;
    } catch (e) {
      throw Exception('Erro ao buscar usuários: $e');
    }
  }

  @override
  Future createUser(
      String email,
      String name,
      String password,
      File? imageFile, // O arquivo da imagem
      String phone) async {
    final url = "http://${constants.apiUrl}/Users"; // PC Localhost

    try {
      var response = await client.uploadFile(
          url: url,
          fields: {
            'email': email,
            'name': name,
            'password': password,
            'phone': phone
          },
          file: imageFile,
          fileField: 'image');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        // print(body);
        return body;
      } else {}
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Future updateImageUser(String id, File? image) async {
    final String url = "http://${constants.apiUrl}/Users/updateImageUser/$id";
    try {
      final response = await client.updateUserImage(
        url: url,
        file: image,
      );

      if (response.statusCode != 200) {
        throw Exception('Erro na atualização dos dados');
      }
      final List<dynamic> body = jsonDecode(response.body);

      // Supondo que a API retorne uma lista com um único objeto, pegamos o primeiro
      final updatedUserData = body.isNotEmpty ? body.first : {};

      final existingData =
          await Preferences.getMap('userDataSharedPreferences');

      // Atualiza os dados existentes com os novos
      existingData['email'] = updatedUserData['email'];
      existingData['name'] = updatedUserData['name'];
      existingData['password'] = updatedUserData['password'];
      existingData['phone'] = updatedUserData['phone'];

      // Salva os novos dados no SharedPreferences
      await Preferences.saveMap('userDataSharedPreferences', updatedUserData);
      return updatedUserData;
    } catch (e) {
      throw Exception('Erro ao atualizar imagem: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateEmailAndPhone(String id, String email,
      String name, String password, String phone) async {
    String url = 'http://${constants.apiUrl}/Users/$id';
    try {
      final response = await client.put(
        url: url,
        body: {
          'email': email,
          'name': name,
          'password': password,
          'phone': phone,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Erro na atualização dos dados');
      }

      final List<dynamic> body = jsonDecode(response.body);

      // Supondo que a API retorne uma lista com um único objeto, pegamos o primeiro
      final updatedUserData = body.isNotEmpty ? body.first : {};

      final existingData =
          await Preferences.getMap('userDataSharedPreferences');

      // Atualiza os dados existentes com os novos
      existingData['email'] = updatedUserData['email'];
      existingData['name'] = updatedUserData['name'];
      existingData['password'] = updatedUserData['password'];
      existingData['phone'] = updatedUserData['phone'];

      // Salva os novos dados no SharedPreferences
      await Preferences.saveMap('userDataSharedPreferences', updatedUserData);
      return updatedUserData;
    } catch (e) {
      throw Exception('Erro ao atualizar email e telefone: $e');
    }
  }

  @override
  Future deleteUser(String id) async {
    try {
      String url = 'http://${constants.apiUrl}/Users/$id';
      final response = await client.delete(url: url);
      if (response.statusCode != 200) {
        throw Exception('Erro ao deletar usuário');
      }

      final body = jsonDecode(response.body);
      return body;
    } catch (e) {
      throw Exception('Erro ao deletar usuário: $e');
    }
  }
}
