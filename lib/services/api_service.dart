// REST API service for PlayStation rental system
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/console_model.dart';
import '../models/game_model.dart';
import '../models/customer_model.dart';
import '../models/rental_model.dart';
import '../models/rental_detail_model.dart';
import '../models/payment_model.dart';
import '../models/tariff_model.dart';


class ApiService {
  final String baseUrl;
  Map<String, dynamic>? currentUser;
  String? token;
  
  ApiService({this.baseUrl = 'http://localhost:4000/api'});

  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> bookingData) async {
    if (token == null) throw Exception('Not authenticated');
    
    final res = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(bookingData),
    );
    
    if (res.statusCode == 201) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to create booking: ${res.body}');
    }
  }

  Future<void> updateBookingStatus(int bookingId, String status) async {
    final res = await http.put(
      Uri.parse('$baseUrl/bookings/$bookingId/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );
    
    if (res.statusCode != 200) {
      throw Exception('Failed to update booking status: ${res.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getBookings() async {
    if (token == null) throw Exception('Not authenticated');
    
    final res = await http.get(
      Uri.parse('$baseUrl/bookings'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch bookings');
    }
  }

  // Consoles
  Future<List<ConsoleModel>> fetchConsoles() async {
    try {
      final uri = Uri.parse('$baseUrl/consoles');
      print('Fetching consoles from: $uri');
      
      final res = await http.get(uri);
      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
      
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => ConsoleModel.fromMap(e)).toList();
      } else {
        throw Exception('Failed to load consoles: ${res.body}');
      }
    } catch (e) {
      print('Error fetching consoles: $e');
      rethrow;
    }
  }

  Future<ConsoleModel> createConsole(ConsoleModel console) async {
    final res = await http.post(
      Uri.parse('$baseUrl/consoles'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(console.toMap()),
    );
    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return ConsoleModel.fromMap({...console.toMap(), 'id': data['id']});
    } else {
      throw Exception('Failed to create console');
    }
  }

  // Customers
  Future<List<CustomerModel>> fetchCustomers() async {
    final res = await http.get(Uri.parse('$baseUrl/customers'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => CustomerModel.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<CustomerModel> createCustomer(CustomerModel customer) async {
    final res = await http.post(
      Uri.parse('$baseUrl/customers'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(customer.toMap()),
    );
    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return CustomerModel.fromMap({...customer.toMap(), 'id': data['id']});
    } else {
      throw Exception('Failed to create customer');
    }
  }

  // Rentals
  Future<List<RentalModel>> fetchRentals() async {
    final res = await http.get(Uri.parse('$baseUrl/rentals'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => RentalModel.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load rentals');
    }
  }

  Future<RentalModel> createRental(RentalModel rental) async {
    final res = await http.post(
      Uri.parse('$baseUrl/rentals'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(rental.toMap()),
    );
    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return RentalModel.fromMap({...rental.toMap(), 'id': data['id']});
    } else {
      throw Exception('Failed to create rental');
    }
  }

  // Rental Details
  Future<List<RentalDetailModel>> fetchRentalDetails() async {
    final res = await http.get(Uri.parse('$baseUrl/rental_details'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => RentalDetailModel.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load rental details');
    }
  }

  Future<RentalDetailModel> createRentalDetail(RentalDetailModel detail) async {
    final res = await http.post(
      Uri.parse('$baseUrl/rental_details'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(detail.toMap()),
    );
    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return RentalDetailModel.fromMap({...detail.toMap(), 'id': data['id']});
    } else {
      throw Exception('Failed to create rental detail');
    }
  }

  // Payments
  Future<List<PaymentModel>> fetchPayments() async {
    final res = await http.get(Uri.parse('$baseUrl/payments'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => PaymentModel.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load payments');
    }
  }

  Future<PaymentModel> createPayment(PaymentModel payment) async {
    final res = await http.post(
      Uri.parse('$baseUrl/payments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payment.toMap()),
    );
    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return PaymentModel.fromMap({...payment.toMap(), 'id': data['id']});
    } else {
      throw Exception('Failed to create payment');
    }
  }

  // Tariffs
  Future<List<TariffModel>> fetchTariffs() async {
    final res = await http.get(Uri.parse('$baseUrl/tariffs'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => TariffModel.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load tariffs');
    }
  }

  Future<TariffModel> createTariff(TariffModel tariff) async {
    final res = await http.post(
      Uri.parse('$baseUrl/tariffs'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tariff.toMap()),
    );
    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return TariffModel.fromMap({...tariff.toMap(), 'id': data['id']});
    } else {
      throw Exception('Failed to create tariff');
    }
  }

  // Games
  Future<List<GameModel>> fetchGames() async {
    final res = await http.get(Uri.parse('$baseUrl/games'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => GameModel.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }

  Future<GameModel> createGame(GameModel game) async {
    final res = await http.post(
      Uri.parse('$baseUrl/games'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(game.toMap()),
    );
    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return GameModel.fromMap(data);
    } else {
      throw Exception('Failed to create game: ${res.body}');
    }
  }

  Future<GameModel> updateGame(GameModel game) async {
    final res = await http.put(
      Uri.parse('$baseUrl/games/${game.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(game.toMap()),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return GameModel.fromMap(data);
    } else {
      throw Exception('Failed to update game: ${res.body}');
    }
  }

  Future<void> deleteGame(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/games/$id'));
    if (res.statusCode != 200) {
      throw Exception('Failed to delete game: ${res.body}');
    }
  }

  // Authentication
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      // Log request untuk debugging
      final uri = Uri.parse('$baseUrl/login');
      final body = jsonEncode({
        'username': username,
        'password': password,
      });

      // ignore: avoid_print
      print('Login request to: $uri');
      // ignore: avoid_print
      print('Request body: $body');

      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      );

      // Log response untuk debugging
      // ignore: avoid_print
      print('Response status: ${res.statusCode}');
      // ignore: avoid_print
      print('Response body: ${res.body}');

      final responseData = jsonDecode(res.body);

      if (res.statusCode == 200) {
        // Response sukses berisi token dan data user
        if (responseData['token'] != null) {
          return {
            'token': responseData['token'],
            'user': responseData['user'],
            'message': responseData['message'] ?? 'Login successful',
          };
        } else {
          throw Exception('Invalid response format: missing token');
        }
      } else {
        // Response error, ambil pesan error dari server
        final errorMessage = responseData['error'] ?? 
                           responseData['message'] ?? 
                           'Unknown error occurred';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format from server');
      }
      rethrow;
    }
  }

  /// Convenience wrapper for UI code that expects a boolean result.
  /// Returns true if login succeeded (token received), false otherwise.
  Future<bool> authenticate(String username, String password) async {
    try {
      final res = await login(username, password);
      return res['token'] != null;
    } catch (_) {
      return false;
    }
  }

  Future<void> register(String name, String username, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama_user': name,
        'username': username,
        'password': password,
        'id_role': 3, // Default role for customer
      }),
    );
    if (res.statusCode != 201) {
      throw Exception('Registration failed: ${res.body}');
    }
  }
}
