import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/console_model.dart';
import 'package:flutter_application_1/models/game_model.dart';
import 'package:flutter_application_1/services/api_service.dart';

class ConsoleSelectionPage extends StatefulWidget {
  const ConsoleSelectionPage({super.key});

  @override
  State<ConsoleSelectionPage> createState() => _ConsoleSelectionPageState();
}

class _ConsoleSelectionPageState extends State<ConsoleSelectionPage> {
  final ApiService api = ApiService();
  List<ConsoleModel> consoles = [];
  List<GameModel> games = [];
  bool isLoading = true;
  ConsoleModel? selectedConsole;

  @override
  void initState() {
    super.initState();
    _loadConsoles();
  }

  Future<void> _loadConsoles() async {
    try {
      final allConsoles = await api.fetchConsoles();
      setState(() {
        consoles = allConsoles; // Tampilkan semua console
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading consoles: ${e.toString()}')),
      );
    }
  }

  Future<void> _loadGames(String platform) async {
    try {
      setState(() => isLoading = true);
      final allGames = await api.fetchGames();
      setState(() {
        games = allGames.where((g) => g.platform == platform).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading games: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Console'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Console Selection
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Consoles',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: consoles.length,
                          itemBuilder: (context, index) {
                            final console = consoles[index];
                            final isSelected = selectedConsole?.id == console.id;
                            
                            return Card(
                              margin: const EdgeInsets.only(right: 16),
                              elevation: isSelected ? 8 : 2,
                              color: isSelected ? const Color(0xFF1A237E) : null,
                              child: InkWell(
                                onTap: console.status.toLowerCase() == 'dipakai' ? null : () {
                                  setState(() => selectedConsole = console);
                                  _loadGames(console.jenisConsole);
                                },
                                child: Opacity(
                                opacity: console.status.toLowerCase() == 'dipakai' ? 0.7 : 1.0,
                                child: Container(
                                  width: 150,
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.gamepad,
                                        size: 32,
                                        color: isSelected ? Colors.white : 
                                               console.status.toLowerCase() == 'dipakai' ? Colors.red :
                                               const Color(0xFF1A237E),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        console.jenisConsole,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected ? Colors.white :
                                                 console.status.toLowerCase() == 'dipakai' ? Colors.red :
                                                 null,
                                        ),
                                      ),
                                      Text(
                                        '${console.nomorUnit} (${console.status})',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isSelected ? Colors.white70 :
                                                 console.status.toLowerCase() == 'dipakai' ? Colors.red[300] :
                                                 Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Games List
                if (selectedConsole != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Available Games for ${selectedConsole!.jenisConsole}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: games.length,
                      itemBuilder: (context, index) {
                        final game = games[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.sports_esports),
                            title: Text(game.namaGame),
                            subtitle: Text(game.genre ?? ''),
                            trailing: ElevatedButton(
                              onPressed: () {
                                // Navigate to booking page with console and game data
                                Navigator.pushNamed(
                                  context,
                                  '/booking',
                                  arguments: {
                                    'console': selectedConsole,
                                    'game': game,
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A237E),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Select'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                
                if (selectedConsole == null)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Please select a console to view available games',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}