import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/console_provider.dart';
import 'package:flutter_application_1/providers/rental_provider.dart';
import 'package:flutter_application_1/ui/pages/splash_page.dart';
import 'package:flutter_application_1/ui/pages/login_page.dart';
import 'package:flutter_application_1/ui/pages/register_page.dart';
import 'package:flutter_application_1/ui/pages/home_page.dart';

import 'package:flutter_application_1/ui/pages/console_detail_page.dart';
import 'package:flutter_application_1/ui/pages/booking_page.dart';
import 'package:flutter_application_1/ui/pages/admin_page.dart';
import 'package:flutter_application_1/ui/pages/console_selection_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConsoleProvider()),
        ChangeNotifierProvider(create: (_) => RentalProvider()),
      ],
      child: MaterialApp(
        title: 'PlayStation Rental',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const SplashPage(),
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),
          '/home': (_) => const HomePage(),
          '/consoles': (_) => const ConsoleSelectionPage(), // Updated this route
          '/console': (_) => const ConsoleDetailPage(),
          '/booking': (_) => const BookingPage(),
          '/admin': (_) => const AdminPage(),
        },
      ),
    );
  }
}
