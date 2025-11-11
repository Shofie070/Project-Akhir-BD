import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/console_model.dart';
import 'package:flutter_application_1/services/api_service.dart';

class ConsoleProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<ConsoleModel> _consoles = [];
  bool _isLoading = false;

  List<ConsoleModel> get consoles => List.unmodifiable(_consoles);
  bool get isLoading => _isLoading;

  ConsoleProvider() {
    fetchConsoles();
  }

  Future<void> fetchConsoles() async {
    _isLoading = true;
    notifyListeners();
    try {
      _consoles = await _apiService.fetchConsoles();
    } catch (e) {
      // Handle error, maybe show a snackbar or log
      // Error is silently handled to prevent UI disruption
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ConsoleModel? findById(int id) => _consoles.firstWhere((c) => c.id == id, orElse: () => _consoles.first);

  Future<void> add(ConsoleModel console) async {
    try {
      final newConsole = await _apiService.createConsole(console);
      _consoles.add(newConsole);
      notifyListeners();
    } catch (e) {
      // Error is silently handled to prevent UI disruption
      rethrow;
    }
  }
}
