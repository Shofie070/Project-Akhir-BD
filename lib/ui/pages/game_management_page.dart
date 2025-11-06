import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/game_model.dart';
import 'package:flutter_application_1/services/api_service.dart';

class GameManagementPage extends StatefulWidget {
  const GameManagementPage({super.key});

  @override
  State<GameManagementPage> createState() => _GameManagementPageState();
}

class _GameManagementPageState extends State<GameManagementPage> {
  final ApiService api = ApiService();
  List<GameModel> games = [];
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _namaGameController = TextEditingController();
  final _genreController = TextEditingController();
  final _platformController = TextEditingController();
  GameModel? selectedGame;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  @override
  void dispose() {
    _namaGameController.dispose();
    _genreController.dispose();
    _platformController.dispose();
    super.dispose();
  }

  Future<void> _loadGames() async {
    try {
      setState(() => isLoading = true);
      final loadedGames = await api.fetchGames();
      setState(() {
        games = loadedGames;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showError('Error loading games: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _deleteGame(GameModel game) async {
    try {
      await api.deleteGame(game.id);
      _showSuccess('Game deleted successfully');
      _loadGames(); // Reload the list
    } catch (e) {
      _showError('Error deleting game: ${e.toString()}');
    }
  }

  Future<void> _saveGame() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final game = GameModel(
        id: selectedGame?.id ?? 0,
        namaGame: _namaGameController.text,
        genre: _genreController.text,
        platform: _platformController.text,
      );

      if (selectedGame == null) {
        await api.createGame(game);
        _showSuccess('Game created successfully');
      } else {
        await api.updateGame(game);
        _showSuccess('Game updated successfully');
      }

      _clearForm();
      _loadGames(); // Reload the list
    } catch (e) {
      _showError('Error saving game: ${e.toString()}');
    }
  }

  void _clearForm() {
    setState(() {
      selectedGame = null;
      _namaGameController.clear();
      _genreController.clear();
      _platformController.clear();
    });
  }

  void _editGame(GameModel game) {
    setState(() {
      selectedGame = game;
      _namaGameController.text = game.namaGame;
      _genreController.text = game.genre ?? '';
      _platformController.text = game.platform ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Management'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        selectedGame == null ? 'Add New Game' : 'Edit Game',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _namaGameController,
                        decoration: const InputDecoration(
                          labelText: 'Game Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter game name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _genreController,
                        decoration: const InputDecoration(
                          labelText: 'Genre',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _platformController,
                        decoration: const InputDecoration(
                          labelText: 'Platform',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter platform';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveGame,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A237E),
                                foregroundColor: Colors.white,
                              ),
                              child: Text(selectedGame == null ? 'Add Game' : 'Update Game'),
                            ),
                          ),
                          if (selectedGame != null) ...[
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: _clearForm,
                              child: const Text('Cancel'),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Game List',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: games.length,
                      itemBuilder: (context, index) {
                        final game = games[index];
                        return Card(
                          child: ListTile(
                            title: Text(game.namaGame),
                            subtitle: Text('${game.genre ?? "No genre"} • ${game.platform}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editGame(game),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Game'),
                                      content: Text('Are you sure you want to delete ${game.namaGame}?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _deleteGame(game);
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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