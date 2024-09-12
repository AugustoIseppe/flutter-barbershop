
import 'package:barbershop/app/data/model/barber_best_rated_model.dart';
import 'package:barbershop/app/data/repositories/barber_best_rated_repository.dart';
import 'package:flutter/material.dart';

class BestRatedBarberStore extends ChangeNotifier {
  bool isLoading = false;
  List<BarberBestRatedModel> bestRatedBarbers = [];
  String error = '';

  final IBarberBestRatedRepository repository;
  BestRatedBarberStore({required this.repository});

  Future getBestRatedBarbers() async {
    isLoading = true;
    try {
      final result = await repository.getBarberBestRated();
      print("RESULT BESTRATEDBARBER: $result");
      bestRatedBarbers = result;
      print("BESTRATEDBARBERS: $bestRatedBarbers");
    } on Exception catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
  
}