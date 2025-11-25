import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/models/game_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // --- DAFTAR HALAMAN UTAMA ---
  final List<Widget> _pages = [
    const ConsolesView(), // Tab 1: Pilih Console
    const BookingView(),  // Tab 2: Riwayat Saya (User Spesifik)
    const ProfileView(),  // Tab 3: Profil Saya
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000E29),
      body: Stack(
        children: [
          // 1. BACKGROUND GLOBAL
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
          
          // Dekorasi Background
          _bgIcon(Icons.gamepad, Colors.blue, 100, -50, null, null),
          _bgIcon(Icons.history, Colors.purple, null, null, -40, 150),

          // 2. KONTEN UTAMA
          SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
        ],
      ),

      // 3. BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF000E29).withOpacity(0.9),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: Colors.blueAccent, 
          unselectedItemColor: Colors.white24,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset_rounded),
              label: 'Console',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
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

// ============================================================================
// TAB 1: CONSOLES VIEW (PILIH PS & SEWA)
// ============================================================================
class ConsolesView extends StatelessWidget {
  const ConsolesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy Console
    final consoles = [
      {'id': '1', 'name': 'PS5-01', 'type': 'PS5', 'price': 15000, 'status': 'Tersedia'},
      {'id': '2', 'name': 'PS5-02', 'type': 'PS5', 'price': 15000, 'status': 'Dipakai'},
      {'id': '3', 'name': 'PS4-PRO', 'type': 'PS4', 'price': 10000, 'status': 'Tersedia'},
      {'id': '4', 'name': 'PS3-SLIM', 'type': 'PS3', 'price': 5000, 'status': 'Tersedia'},
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mau main apa?', style: TextStyle(color: Colors.white54, fontSize: 14)),
                  Text('Pilih Console', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.1),
                child: const Icon(Icons.notifications_none, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 20),
          
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                mainAxisSpacing: 16, 
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: consoles.length,
              itemBuilder: (context, index) {
                final c = consoles[index];
                final available = c['status'] == 'Tersedia';
                
                return GestureDetector(
                  onTap: available ? () => _showBookingForm(context, c) : null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: available ? Colors.white.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: available ? Colors.white24 : Colors.redAccent),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.tv, size: 40, color: available ? Colors.blue : Colors.grey),
                            const SizedBox(height: 12),
                            Text(c['name'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Rp ${c['price']}/jam', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: available ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                available ? 'AVAILABLE' : 'IN USE',
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _showBookingForm(BuildContext context, Map<String, dynamic> console) {
    final durationController = TextEditingController(text: "1");
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF001530),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sewa ${console['name']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Durasi (Jam)',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Berhasil menyewa ${console['name']}!')),
                    );
                  },
                  child: const Text('KONFIRMASI SEWA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// TAB 2: BOOKING VIEW (LOGIC: FILTER USER YANG LOGIN SAJA)
// ============================================================================
class BookingView extends StatefulWidget {
  const BookingView({super.key});

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  final ApiService _api = ApiService();
  List<Map<String, dynamic>> _myBookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMyBookings();
  }

  Future<void> _loadMyBookings() async {
    try {
      // 1. Ambil data User yang sedang login
      final currentUser = _api.currentUser; 
      
      // 2. Ambil semua booking (mocking fetch)
      final allBookings = await _api.getBookings(); // Anggap ini ambil semua dari DB

      // 3. FILTER: Hanya ambil booking milik user ini
      if (currentUser != null) {
        final myData = allBookings.where((booking) {
          // Sesuaikan dengan field di database kamu, misal 'customerName' atau 'userId'
          return booking['customerName'] == currentUser['name']; 
        }).toList();

        if (mounted) {
          setState(() {
            _myBookings = myData;
            _isLoading = false;
          });
        }
      } else {
        // Jika tidak ada user login, kosongkan
        if (mounted) setState(() { _myBookings = []; _isLoading = false; });
      }

    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      // Gunakan data dummy jika API error, tapi filter juga kalau bisa
      // Untuk demo, kita kosongkan saja agar tidak membingungkan
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orangeAccent;
      case 'approved': return Colors.greenAccent;
      case 'rejected': return Colors.redAccent;
      case 'completed': return Colors.blueAccent;
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
          const Text('Riwayat Saya', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const Text('Daftar sewa kamu', style: TextStyle(color: Colors.white54)),
          const SizedBox(height: 20),
          
          Expanded(
            child: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
            : _myBookings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_toggle_off, size: 60, color: Colors.white.withOpacity(0.2)),
                      const SizedBox(height: 16),
                      const Text('Kamu belum pernah menyewa', style: TextStyle(color: Colors.white54)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _myBookings.length,
                  itemBuilder: (context, index) {
                    final item = _myBookings[index];
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['gameName'] ?? 'Rental Console', 
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text('${item['console']} • ${item['date']}', 
                                      style: const TextStyle(color: Colors.white54, fontSize: 12)),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(item['status']).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: _getStatusColor(item['status'])),
                                  ),
                                  child: Text(
                                    item['status'].toUpperCase(),
                                    style: TextStyle(
                                      color: _getStatusColor(item['status']), 
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 10
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
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

// ============================================================================
// TAB 3: PROFILE VIEW (TAMPILKAN DATA USER ASLI)
// ============================================================================
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ApiService _api = ApiService();
  String _name = 'Guest';
  String _role = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = _api.currentUser;
    if (user != null) {
      setState(() {
        _name = user['name'] ?? 'Gamer';
        _role = user['role'] ?? 'Customer';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          // Avatar Besar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent.withOpacity(0.2),
              border: Border.all(color: Colors.blueAccent, width: 2),
              boxShadow: [BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 20)],
            ),
            child: const Icon(Icons.person, size: 60, color: Colors.blueAccent),
          ),
          const SizedBox(height: 16),
          Text(_name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          Text('Role: $_role', style: const TextStyle(color: Colors.white54)),
          
          const SizedBox(height: 40),
          
          // Menu Profil
          _buildProfileItem(Icons.person_outline, 'Edit Profil', () {}),
          _buildProfileItem(Icons.lock_outline, 'Ganti Password', () {}),
          _buildProfileItem(Icons.settings_outlined, 'Pengaturan', () {}),
          
          const Spacer(),
          
          // Tombol Logout
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Logout dan kembali ke Login Page
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('LOGOUT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, VoidCallback onTap) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
        onTap: onTap,
      ),
    );
  }
}