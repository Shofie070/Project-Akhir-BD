class GameModel {
  final int id;
  final String namaGame;
  final String? genre;
  final String? platform;

  GameModel({
    required this.id,
    required this.namaGame,
    this.genre,
    this.platform,
  });

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      id: map['id'] ?? 0,
      namaGame: map['namaGame'] ?? '',
      genre: map['genre'],
      platform: map['platform'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'namaGame': namaGame,
      'genre': genre,
      'platform': platform,
    };
  }
}
