import 'dart:ui'; // Wajib untuk efek Blur
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';

// --- IMPORT HALAMAN MANAJEMEN ---
import 'package:flutter_application_1/ui/pages/console_management_page.dart'; 
import 'package:flutter_application_1/ui/pages/user_management_page.dart';
import 'package:flutter_application_1/ui/pages/rental_management_page.dart';
import 'package:flutter_application_1/ui/pages/settings_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;

  // Daftar Halaman Admin
  final List<Widget> _pages = [
    const AdminDashboardView(), // Tab 0: Dashboard
    const AdminManagementView(), // Tab 1: Menu Tombol (Semua fungsi ada disini)
    const AdminReportsView(),    // Tab 2: Laporan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000E29),
      body: Stack(
        children: [
          // BACKGROUND GLOBAL
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.5,
                  colors: [Color(0xFF1A237E), Color(0xFF000000)],
                ),
              ),
            ),
          ),
          // Dekorasi
          _bgIcon(Icons.admin_panel_settings, Colors.red, 100, -50, null, null),
          _bgIcon(Icons.videogame_asset, Colors.blue, null, null, -40, 100),

          // CONTENT
          SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
        ],
      ),
      
      // BOTTOM NAV
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF000E29).withOpacity(0.9),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.white24,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Manage'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
          ],
        ),
      ),
    );
  }

  Widget _bgIcon(IconData icon, Color color, double? top, double? left, double? right, double? bottom) {
    return Positioned(
      top: top, left: left, right: right, bottom: bottom,
      child: Icon(icon, size: 150, color: color.withOpacity(0.05)),
    );
  }
}

// ---------------------------------------------------------------------------
// VIEW 1: DASHBOARD (LIST BOOKING)
// ---------------------------------------------------------------------------
class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});
  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  final ApiService api = ApiService();
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final data = await api.getBookings();
      if (mounted) setState(() { bookings = data; isLoading = false; });
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orangeAccent;
      case 'approved': return Colors.greenAccent;
      case 'rejected': return Colors.redAccent;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Overview', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text('Recent Requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
                : bookings.isEmpty
                    ? const Center(child: Text('No bookings found', style: TextStyle(color: Colors.white54)))
                    : ListView.builder(
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final booking = bookings[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('ID #${booking['id']}', style: const TextStyle(color: Colors.white54)),
                                    Text(booking['status'].toUpperCase(), style: TextStyle(color: _getStatusColor(booking['status']), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text('${booking['gameName']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                Text('Customer: ${booking['customerName']}', style: const TextStyle(color: Colors.white70)),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// VIEW 2: MANAGEMENT MENU (SEMUA TOMBOL BERFUNGSI)
// ---------------------------------------------------------------------------
class AdminManagementView extends StatelessWidget {
  const AdminManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Management', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const Text('Manage system resources', style: TextStyle(color: Colors.white54)),
          const SizedBox(height: 24),
          
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                // 1. MANAGE CONSOLES
                _buildMenuCard(
                  context,
                  'Manage Consoles',
                  Icons.videogame_asset,
                  Colors.purpleAccent,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConsoleManagementPage())),
                ),
                
                // 2. USERS (BERFUNGSI)
                _buildMenuCard(
                  context, 
                  'Users', 
                  Icons.people, 
                  Colors.blue, 
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserManagementPage())),
                ),
                
                // 3. RENTALS (BERFUNGSI)
                _buildMenuCard(
                  context, 
                  'Rentals', 
                  Icons.assignment, 
                  Colors.orange, 
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RentalManagementPage())),
                ),
                
                // 4. SETTINGS (BERFUNGSI)
                _buildMenuCard(
                  context, 
                  'Settings', 
                  Icons.settings, 
                  Colors.grey, 
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 40),
                const SizedBox(height: 16),
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// VIEW 3: REPORTS
// ---------------------------------------------------------------------------
class AdminReportsView extends StatelessWidget {
  const AdminReportsView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Reports View', style: TextStyle(color: Colors.white)));
  }
}