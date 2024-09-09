
import 'package:barbershop/app/data/model/barbershop_barber_model.dart';
import 'package:barbershop/app/data/repositories/barbershop_barber_repository.dart';
import 'package:flutter/material.dart';

class BarberStore extends ChangeNotifier {

  final IBarbershopBarberRepository repository;
  BarberStore({required this.repository});
 bool isLoading = false;
  List<BarbershopBarberModel> barbers = [];
  String error = '';
  String? selectedBarberId;

  void selectBarber(String barberId) {
    selectedBarberId = barberId;
    notifyListeners();
  }

  Future<void> getBarbers(String barbershopid) async {
    isLoading = true;
    notifyListeners(); // Notifica a view que o carregamento começou
    try {
      final result = await repository.getBarbershopBarbers(barbershopid);
      barbers = result;
      error = '';
      barbers.map((e) => print("BARBERS FROM STORE ${e.barbername}")).toList();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;  // Garante que isLoading seja false após a operação
      notifyListeners();  // Notifica a view que o carregamento terminou
    }
  }
  
}