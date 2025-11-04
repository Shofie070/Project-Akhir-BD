import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/models/game_model.dart';
import 'game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _api = ApiService();
  late Future<List<GameModel>> _gamesFuture;

  @override
  void initState() {
    super.initState();
    _gamesFuture = _api.fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Games', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<GameModel>>(
                future: _gamesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final games = snapshot.data ?? [];
                  if (games.isEmpty) return const Center(child: Text('No games found'));
                  return ListView.builder(
                    itemCount: games.length,
                    itemBuilder: (context, i) {
                      final g = games[i];
                      return Card(
                        child: ListTile(
                          title: Text(g.title),
                          subtitle: Text('${g.genre} • ${g.platform}'),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => GamePage(game: g)),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
