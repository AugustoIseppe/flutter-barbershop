
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
      print(result);
      barbershopsServices = result;
      barbershopsServices.map((e) => print("BARBERSHOPS SERVICES FROM STORE ${e.name}")).toList();
    } on Exception catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

}