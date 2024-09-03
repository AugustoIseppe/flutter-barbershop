import 'dart:io';

import 'package:barbershop/app/data/repositories/user_repository.dart';
import 'package:flutter/foundation.dart';

class UserStore with ChangeNotifier {
  final IUserRepository repository;
  UserStore({required this.repository});

  bool isLoading = false;
  Map<String, dynamic> users = {};
  String error = '';

  Future getUsers(String id, String email, String name, String password,
      String phone) async {
    isLoading = true;
    notifyListeners(); // Notificar que a loading mudou
    try {
      final result = await repository.updateEmailAndPhone(
        id,
        email,
        name,
        password,
        phone,
      );

      users = result;  // Aqui, 'result' deve ser um objeto, não uma lista
      
      error = '';
      return users;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future getUsersforImage(String id, File? imageUrl) async {
    isLoading = true;
    notifyListeners(); // Notificar que a loading mudou
    try {
      final result = await repository.updateImageUser(id, imageUrl);

      users = result;  // Aqui, 'result' deve ser um objeto, não uma lista
      
      error = '';
      return users;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
