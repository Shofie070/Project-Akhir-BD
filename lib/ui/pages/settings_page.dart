import 'dart:ui';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000E29),
      appBar: AppBar(
        title: const Text('Settings'),
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSettingItem(Icons.person_outline, 'Edit Profile', () {}),
            _buildSettingItem(Icons.notifications_outlined, 'Notifications', () {}),
            _buildSettingItem(Icons.lock_outline, 'Change Password', () {}),
            const Divider(color: Colors.white24, height: 40),
            _buildSettingItem(
              Icons.logout, 
              'Logout', 
              () {
                // Logika Logout: Kembali ke Login Page & Hapus Stack Navigasi
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }, 
              isDestructive: true
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.redAccent : Colors.blueAccent),
        title: Text(title, style: TextStyle(color: isDestructive ? Colors.redAccent : Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
        onTap: onTap,
      ),
    );
  }
}