import 'dart:ui';
import 'package:flutter/material.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data User
    final users = [
      {'name': 'Andi Saputra', 'role': 'Customer', 'email': 'andi@email.com'},
      {'name': 'Budi Santoso', 'role': 'Customer', 'email': 'budi@email.com'},
      {'name': 'Admin Utama', 'role': 'Admin', 'email': 'admin@rental.com'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF000E29),
      appBar: AppBar(
        title: const Text('Manage Users'),
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
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              color: Colors.white.withOpacity(0.05),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                  child: const Icon(Icons.person, color: Colors.blueAccent),
                ),
                title: Text(user['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(user['email']!, style: const TextStyle(color: Colors.white70)),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: user['role'] == 'Admin' ? Colors.red.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    user['role']!,
                    style: TextStyle(
                      color: user['role'] == 'Admin' ? Colors.redAccent : Colors.greenAccent,
                      fontSize: 10, fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}