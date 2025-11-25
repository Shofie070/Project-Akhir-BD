import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  
  // Animasi untuk elemen-elemen UI
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<Offset> _textSlide;
  late Animation<double> _textFade;
  
  // Controller untuk background berputar pelan
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();

    // 1. Controller Utama (Durasi masuk)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // 2. Controller Background (Looping terus menerus)
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Setup Animasi Logo (Muncul dan membesar sedikit)
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );
    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.elasticOut)),
    );

    // Setup Animasi Teks (Geser dari bawah ke atas)
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic)),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.8, curve: Curves.easeIn)),
    );

    // Jalankan animasi masuk
    _controller.forward();

    // Timer navigasi pindah halaman
    Future.delayed(const Duration(seconds: 6), () async {
      if (mounted) {
        await _navigateAway();
      }
    });
  }

  Future<void> _navigateAway() async {
    // Efek keluar (Reverse animation)
    await _controller.reverse();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000E29), // Base color dark blue
      body: Stack(
        children: [
          // --- LAYER 1: Animated Background Gradient & Shapes ---
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.5,
                  colors: [
                    Color(0xFF1A237E), // Lighter Navy
                    Color(0xFF000000), // Deep Black
                  ],
                ),
              ),
            ),
          ),
          
          // Dekorasi Simbol PlayStation Melayang
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return Stack(
                  children: [
                    _buildFloatingShape(Icons.circle_outlined, -50, 100, Colors.redAccent),
                    _buildFloatingShape(Icons.close, 80, 200, Colors.blueAccent),
                    _buildFloatingShape(Icons.change_history, -80, 400, Colors.greenAccent), // Segitiga
                    _buildFloatingShape(Icons.crop_square, 50, 550, Colors.pinkAccent),
                  ],
                );
              },
            ),
          ),

          // --- LAYER 2: Main Content ---
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO SECTION
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoFade.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 130,
                            height: 130,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // TEXT SECTION
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: Column(
                      children: [
                        const Text(
                          'STICKNPLAY',
                          style: TextStyle(
                            fontSize: 36,
                            fontFamily: 'Arial', // Ganti dengan font gaming jika ada
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 4.0,
                            shadows: [
                              Shadow(
                                blurRadius: 15.0,
                                color: Colors.blueAccent,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Text(
                            'PREMIUM PLAYSTATION RENTAL',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                // LOADING INDICATOR SECTION
                FadeTransition(
                  opacity: _textFade, // Muncul barengan text
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      backgroundColor: Colors.white10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // --- LAYER 3: Copyright Text (Bottom) ---
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _textFade,
              child: const Text(
                'v1.0.0 • Powered by Flutter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Helper widget untuk membuat dekorasi background melayang
  Widget _buildFloatingShape(IconData icon, double offsetX, double offsetY, Color color) {
    // Membuat efek parallax/gerak lambat berdasarkan _bgController
    return Transform.translate(
      offset: Offset(
        offsetX + (math.sin(_bgController.value * 2 * math.pi) * 10), // Gerak kiri-kanan halus
        offsetY + (math.cos(_bgController.value * 2 * math.pi) * 10), // Gerak atas-bawah halus
      ),
      child: Transform.rotate(
        angle: _bgController.value * 2 * math.pi, // Berputar pelan
        child: Icon(
          icon,
          size: 40,
          color: color.withOpacity(0.15), // Transparan agar tidak mengganggu
        ),
      ),
    );
  }
}