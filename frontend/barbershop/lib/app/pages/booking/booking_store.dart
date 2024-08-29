
import 'package:barbershop/app/data/model/booking_model.dart';
import 'package:barbershop/app/data/repositories/booking_repository.dart';
import 'package:flutter/material.dart';

class BookingStore extends ChangeNotifier {
  final BookingRepository bookingRepository;
  BookingStore(this.bookingRepository);

  bool isLoading = false;
  String error = '';
  List<BookingModel> bookings = [];


  Future getBookingById(String id, String barbershopId) async {
    try {
      final result = await bookingRepository.getBookingById(id, barbershopId);
      bookings = result;
    } on Exception catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}