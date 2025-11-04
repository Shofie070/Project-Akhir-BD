import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/rental_model.dart';
import 'package:flutter_application_1/services/api_service.dart';

class RentalProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<RentalModel> _rentals = [];
  bool _isLoading = false;

  List<RentalModel> get rentals => List.unmodifiable(_rentals);
  bool get isLoading => _isLoading;

  RentalProvider() {
    fetchRentals();
  }

  Future<void> fetchRentals() async {
    _isLoading = true;
    notifyListeners();
    try {
      _rentals = await _apiService.fetchRentals();
    } catch (e) {
      print('Error fetching rentals: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createRental(RentalModel rental) async {
    try {
      final newRental = await _apiService.createRental(rental);
      _rentals.add(newRental);
      notifyListeners();
    } catch (e) {
      print('Error creating rental: $e');
      throw e;
    }
  }
}
