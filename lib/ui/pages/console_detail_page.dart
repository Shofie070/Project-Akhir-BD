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
      appBar: AppBar(title: Text(console?.jenisConsole ?? 'Console Detail')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Console: ${console?.jenisConsole ?? '-'}'),
            Text('Unit: ${console?.nomorUnit ?? '-'}'),
            Text('Status: ${console?.status ?? '-'}'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/booking', arguments: console), child: const Text('Book')),
          ],
        ),
      ),
    );
  }
}
