import 'dart:ui';
import 'package:flutter/material.dart';

class RentalManagementPage extends StatelessWidget {
  const RentalManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data Rental
    final rentals = [
      {'user': 'Andi', 'console': 'PS5-01', 'status': 'Active', 'time': '2 Jam'},
      {'user': 'Budi', 'console': 'PS4-03', 'status': 'Completed', 'time': '1 Jam'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF000E29),
      appBar: AppBar(
        title: const Text('All Rentals'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomRight,
            radius: 1.5,
            colors: [Color(0xFF1A237E), Color(0xFF000000)],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: rentals.length,
          itemBuilder: (context, index) {
            final item = rentals[index];
            final isActive = item['status'] == 'Active';
            
            return Card(
              color: Colors.white.withOpacity(0.05),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(Icons.gamepad, color: isActive ? Colors.green : Colors.grey, size: 30),
                title: Text('${item['user']} - ${item['console']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text('Durasi: ${item['time']}', style: const TextStyle(color: Colors.white70)),
                trailing: Text(
                  item['status']!,
                  style: TextStyle(color: isActive ? Colors.greenAccent : Colors.white54, fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}