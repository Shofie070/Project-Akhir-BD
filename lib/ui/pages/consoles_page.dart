import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/console_provider.dart';
import 'package:flutter_application_1/ui/widgets/console_card.dart';

class ConsolesPage extends StatelessWidget {
  const ConsolesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final consoles = context.watch<ConsoleProvider>().consoles;
    return Scaffold(
      appBar: AppBar(title: const Text('Consoles')),
      body: ListView.builder(
        itemCount: consoles.length,
        itemBuilder: (context, i) => ConsoleCard(console: consoles[i]),
      ),
    );
  }
}
