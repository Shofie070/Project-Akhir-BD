import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/console_model.dart';

class ConsoleCard extends StatelessWidget {
  final ConsoleModel console;
  const ConsoleCard({super.key, required this.console});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.videogame_asset),
        title: Text(console.name),
        subtitle: Text('Rp \\${console.pricePerHour.toStringAsFixed(0)} / hour'),
        trailing: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/console', arguments: console),
          child: const Text('Detail'),
        ),
      ),
    );
  }
}
