import 'dart:ui'; // Diperlukan untuk efek Blur (Glassmorphism)
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart'; // Pastikan path ini sesuai

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk mengambil input user
  final TextEditingController nimController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // State untuk loading
  bool _isLoading = false;
  
  // Service API
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    nimController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // --- LOGIKA LOGIN ---
  Future<void> _handleLogin() async {
    // 1. Tutup Keyboard
    FocusScope.of(context).unfocus();

    // 2. Validasi Input Kosong
    if (nimController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username dan Password harus diisi!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 3. Mulai Loading
    setState(() => _isLoading = true);

    try {
      // 4. Panggil API Login
      final response = await _apiService.login(
        nimController.text.trim(),
        passwordController.text.trim(),
      );

      if (!mounted) return;

      // 5. Cek Token
      if (response['token'] != null) {
        // Simpan sesi user (sesuaikan dengan logic di ApiService kamu)
        _apiService.token = response['token'];
        _apiService.currentUser = response['user'];

        final role = response['user']['role'];

        // 6. --- NAVIGASI (BAGIAN PENTING) ---
        if (role == 'Admin') {
          Navigator.pushReplacementNamed(context, '/admin');
        } else if (role == 'Customer') {
          // PERBAIKAN: Arahkan ke '/home' (Dashboard Utama)
          // Jangan ke '/consoles', nanti tombol back/navigasinya error.
          Navigator.pushReplacementNamed(context, '/home'); 
        } else {
          // Role tidak dikenali
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Role tidak dikenal: $role')),
          );
        }
      } else {
        // Token null (Login Gagal)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Gagal! Username atau Password salah.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      // Error Jaringan / Server
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // 7. Stop Loading
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background default gelap (Backup jika gambar gagal load)
      backgroundColor: const Color(0xFF000E29),
      
      body: Stack(
        children: [
          // LAYER 1: Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.5,
                  colors: [
                    Color(0xFF1A237E), // Navy Terang (Tengah atas)
                    Color(0xFF000000), // Hitam (Pinggir)
                  ],
                ),
              ),
            ),
          ),

          // Dekorasi Icon Samar di Background
          Positioned(top: 100, right: -20, child: _bgIcon(Icons.gamepad, Colors.purple)),
          Positioned(bottom: 100, left: -20, child: _bgIcon(Icons.sports_esports, Colors.blue)),

          // LAYER 2: Form Login
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png', // Pastikan path ini benar
                    width: 100,
                    height: 100,
                    errorBuilder: (ctx, _, __) => const Icon(Icons.videogame_asset, size: 80, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  
                  // Judul
                  const Text(
                    'WELCOME BACK',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to your rental account',
                    style: TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(height: 40),

                  // KARTU GLASSMORPHISM
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Efek Blur Kaca
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05), // Transparan Putih
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Column(
                          children: [
                            // Input Username
                            _buildModernInput(
                              controller: nimController,
                              label: 'Username',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 20),
                            
                            // Input Password
                            _buildModernInput(
                              controller: passwordController,
                              label: 'Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                            ),
                            const SizedBox(height: 30),

                            // Tombol Login
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  elevation: 5,
                                  shadowColor: Colors.blueAccent.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20, height: 20,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : const Text(
                                        'LOGIN',
                                        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Link Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(color: Colors.white54)),
                      GestureDetector(
                        onTap: () {
                          // Navigasi ke Halaman Register
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BANTUAN (HELPER) ---

  // Helper untuk Input Field Modern
  Widget _buildModernInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white), // Warna teks ketikan
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        
        filled: true,
        fillColor: Colors.white.withOpacity(0.05), // Background kolom gelap transparan
        
        // Border Default
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        
        // Border saat diklik (Focus) -> Warna Biru Neon
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  // Helper untuk Background Icon
  Widget _bgIcon(IconData icon, Color color) {
    return Icon(
      icon,
      size: 150,
      color: color.withOpacity(0.05), // Sangat transparan
    );
  }
}