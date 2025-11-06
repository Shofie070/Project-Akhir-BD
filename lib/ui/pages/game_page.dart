import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/game_model.dart';

class GamePage extends StatelessWidget {
  final GameModel game;
  const GamePage({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(game.namaGame)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(game.namaGame, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Genre: ${game.genre ?? "-"}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Platform: ${game.platform ?? "-"}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Deskripsi:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Tidak ada deskripsi tersedia.'),
          ],
        ),
      ),
    );
  }
}
