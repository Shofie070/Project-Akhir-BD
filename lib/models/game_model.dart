class GameModel {
  final int? id;
  final String title;
  final String genre;
  final String platform;

  GameModel({this.id, required this.title, this.genre = '', this.platform = ''});

  factory GameModel.fromMap(Map<String, dynamic> m) => GameModel(
        id: (m['id'] is int) ? m['id'] as int : (m['id'] != null ? int.tryParse(m['id'].toString()) : null),
        title: (m['title'] as String?) ?? (m['nama_game'] as String?) ?? '',
        genre: (m['genre'] as String?) ?? '',
        platform: (m['platform'] as String?) ?? '',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'genre': genre,
        'platform': platform,
      };
}
