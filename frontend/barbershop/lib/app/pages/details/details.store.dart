
import 'package:barbershop/app/data/model/barbershop_services.dart';
import 'package:barbershop/app/data/repositories/babershop_service_repository.dart';
import 'package:flutter/material.dart';

class DetailsStore extends ChangeNotifier{
  final IBarbershopServiceRepository repository;
  DetailsStore({required this.repository});

  bool isLoading = false;
  List<BarbershopServicesModel> barbershopsServices = [];
  String error = '';

  Future getBarbershopsWithServices(String id) async {
    isLoading = true;
    try {
      final result = await repository.getBarbershopsWithServices(id);
      barbershopsServices = result;
    } on Exception catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

}