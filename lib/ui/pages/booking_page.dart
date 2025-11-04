import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/console_model.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final console = args is ConsoleModel ? args : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Booking for: \\${console?.name ?? '-'}'),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Hours')), 
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Confirm')),
          ],
        ),
      ),
    );
  }
}
