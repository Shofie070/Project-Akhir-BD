class ConsoleModel {
  final int? id;
  final String name;
  final String image;
  final double pricePerHour;
  final bool available;

  ConsoleModel({this.id, required this.name, required this.image, required this.pricePerHour, this.available = true});

  factory ConsoleModel.fromMap(Map<String, dynamic> m) => ConsoleModel(
        id: m['id'] as int?,
        name: m['name'] as String? ?? '',
        image: m['image'] as String? ?? '',
        pricePerHour: (m['price_per_hour'] as num?)?.toDouble() ?? 0.0,
        available: (m['available'] as int? ?? 1) == 1,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'image': image,
        'price_per_hour': pricePerHour,
        'available': available ? 1 : 0,
      };
}
