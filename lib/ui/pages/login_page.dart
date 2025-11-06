import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nimController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;
  final ApiService api = ApiService();

 Future<void> login() async {
  setState(() => loading = true);
  try {
    final resp = await api.login(nimController.text.trim(), passwordController.text.trim());
    setState(() => loading = false);

    print('Login response: $resp'); // Debug print

    if (resp['token'] != null) {
      // Simpan token dan data user
      api.token = resp['token'];
      api.currentUser = resp['user'];
      
      final userRole = resp['user']['role'];
      print('User role: $userRole'); // Debug print

      if (userRole == 'Admin') {
        print('Redirecting to admin page'); // Debug print
        Navigator.pushReplacementNamed(context, '/admin');
      } else if (userRole == 'Customer') {
        print('Redirecting to consoles page'); // Debug print
        Navigator.pushReplacementNamed(context, '/consoles');
      } else {
        print('Unknown role: $userRole'); // Debug print
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unknown user role: $userRole')),
        );
      }
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login gagal! Periksa username atau password.')),
    );
  } catch (e) {
    print('Login error: $e'); // Debug print
    setState(() => loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login error: ${e.toString()}')),
    );
  }
}

  @override
  void dispose() {
    nimController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A237E), // Deep indigo
              Color(0xFF303F9F), // Indigo
              Color(0xFF3949AB), // Lighter indigo
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 16),
                    const Icon(
                      Icons.pedal_bike,
                      size: 60,
                      color: Color(0xFF002D72),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'PlayStation SticknPlay',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'penyewaan playstation SticknPlay',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Card(
                      elevation: 8,
                      shadowColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            TextField(
                              controller: nimController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(color: Color(0xFF1A237E)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Color(0xFF1A237E)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Color(0xFF3949AB)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Color(0xFF1A237E), width: 2),
                                ),
                                prefixIcon: Icon(Icons.person, color: Color(0xFF3949AB)),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Color(0xFF1A237E)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Color(0xFF1A237E)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Color(0xFF3949AB)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Color(0xFF1A237E), width: 2),
                                ),
                                prefixIcon: Icon(Icons.lock, color: Color(0xFF3949AB)),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: loading
                                  ? const Center(child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A237E)),
                                    ))
                                  : ElevatedButton(
                                      onPressed: login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1A237E),
                                        foregroundColor: Colors.white,
                                        elevation: 3,
                                        shadowColor: Colors.black54,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/register'),
                              style: TextButton.styleFrom(
                                foregroundColor: Color(0xFF1A237E),
                                textStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              child: const Text('Belum punya akun? Daftar'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
