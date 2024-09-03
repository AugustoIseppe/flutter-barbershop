import 'package:barbershop/app/data/model/slots_model.dart';
import 'package:barbershop/app/data/repositories/slots_repository.dart';
import 'package:flutter/material.dart';

class SlotsStore extends ChangeNotifier {
  final ISlotsRepository repository;
  SlotsStore({required this.repository});

  bool isLoading = false;
  List<SlotsModel> slots = [];
  String error = '';
  int? _selectedSlotIndex;
  int? get selectedSlotIndex => _selectedSlotIndex;
  
  void setSelectedSlotIndex(int index) {
    _selectedSlotIndex = index;
    notifyListeners();
  }

  Future getSlots(String barbershopId, String date) async {
    isLoading = true;
    notifyListeners(); // Notificar que a loading mudou
    try {
      final result = await repository.getSlots(barbershopId, date);
      slots = result;
      error = '';
    } on Exception catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future updateSlots(String id, String timeid, String date, String barbershopid,) async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await repository.updateSlots(id, timeid, date, barbershopid);
      slots = result;
      error = '';
      for(var slot in slots){
        print(slot.toMap());
      }
    } on Exception catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

}
