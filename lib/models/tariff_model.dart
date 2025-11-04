class TariffModel {
  final int? id;
  final String name;
  final double pricePerHour;

  TariffModel({this.id, required this.name, required this.pricePerHour});

  factory TariffModel.fromMap(Map<String, dynamic> m) => TariffModel(
        id: m['id'] as int?,
        name: m['name'] as String? ?? '',
        pricePerHour: (m['price_per_hour'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'price_per_hour': pricePerHour,
      };
}
