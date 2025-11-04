import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/console_model.dart';

class ConsoleDetailPage extends StatelessWidget {
  const ConsoleDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // For simplicity, this page expects an argument of ConsoleModel
    final args = ModalRoute.of(context)?.settings.arguments;
    final console = args is ConsoleModel ? args : null;

    return Scaffold(
      appBar: AppBar(title: Text(console?.name ?? 'Console Detail')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Name: \\${console?.name ?? '-'}'),
            Text('Price / hour: \\${console?.pricePerHour ?? 0}'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/booking', arguments: console), child: const Text('Book')),
          ],
        ),
      ),
    );
  }
}
