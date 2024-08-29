
import 'package:barbershop/app/data/model/barbershop_model.dart';
import 'package:barbershop/app/data/repositories/barbershop_repository.dart';
import 'package:flutter/material.dart';

class BarbershopStore extends ChangeNotifier {
  final IBarbershopRepository repository;
  BarbershopStore({required this.repository});

  bool isLoading = false;
  List<BarbershopModel> barbershops = [];
  String error = '';

  Future getBarbershops() async {
    isLoading = true;
    try {
      final result = await repository.getAllBarbershops();
      barbershops = result;
    } on Exception catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}