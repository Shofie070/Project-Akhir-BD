class ConsoleModel {
  final int id;
  final String jenisConsole;
  final String nomorUnit;
  final String status;
  final double? pricePerHour;

  ConsoleModel({
    required this.id,
    required this.jenisConsole,
    required this.nomorUnit,
    this.status = 'tersedia',
    this.pricePerHour,
  });

  factory ConsoleModel.fromMap(Map<String, dynamic> map) {
    return ConsoleModel(
      id: map['id_console'] ?? map['id'],
      jenisConsole: map['jenis_console'] ?? '',
      nomorUnit: map['nomor_unit'] ?? '',
      status: map['status'] ?? 'tersedia',
      pricePerHour: map['price_per_hour'] != null 
          ? (map['price_per_hour'] as num).toDouble() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_console': id,
      'jenis_console': jenisConsole,
      'nomor_unit': nomorUnit,
      'status': status,
      'price_per_hour': pricePerHour,
    };
  }
}
